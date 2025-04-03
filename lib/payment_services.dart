import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:stripe_payment_demo/keys.dart';

class PaymentServices {
  static final PaymentServices instance = PaymentServices._internal();

  PaymentServices._internal();

  Map<String, dynamic>? paymentIntentResponse;

  //1
  createStripeTokenInitialization(String amount, String currency) async {
    // Generate token
    final token = await Stripe.instance.createToken(
      const CreateTokenParams.card(
        params: CardTokenParams(),
      ),
    );
    log(token.id);
    // paymentIntentResponse = await createPaymentIntent(
    //   amount,
    //   currency,
    //   token.id,
    // ); //2

    //confirm payemnt using the client secret from paymentIntentResponse.

    // confirmPaymentSheet(); //3
  }

  //2
  //create Payment intent
  createPaymentIntent(String amount, String currency, String tokenid) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        "amount": calculateAmount(amount),
        "currency": currency,
        "token": tokenid,
        // "payment_method": "card"
      };

      //Make post request to Stripe
      final dio = Dio(BaseOptions(
        baseUrl: "backendurl to create a intent",
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      ));

      if (kDebugMode) {
        dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ));
      }
      var response = await dio.post(
        'backendurl to create a intent',
        data: body,
      );

      print("response from stripe: ${response.data}");

      return response.data;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  //3
  confirmPaymentSheet() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance
          .confirmPayment(
        paymentIntentClientSecret: "client secret provided by backend",
        // data: const PaymentMethodParams.card(
        //   paymentMethodData: PaymentMethodData(),
        // ),
      )
          .then((value) {
        paymentIntentResponse = null;
        print("$value");
      });

      log("msg: 'Payment succesfully completed'");
    } on Exception catch (e) {
      if (e is StripeException) {
        log("msg: 'Error from Stripe: ${e.error.localizedMessage}'");
      } else {
        log("msg: 'Unforeseen error: $e'");
      }
    }
  }

  //calculate Amount

  //Stripe requires the amount parameter in the smallest currency unit for the provided currency.
  //For USD, the smallest unit is cents.
  //If you want to create a payment intent for $100.00, you must pass 10000 as the amount (representing 10,000 cents).

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount;
  }
}
