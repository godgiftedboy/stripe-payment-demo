import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:stripe_payment_demo/keys.dart';

class PaymentServices {
  static final PaymentServices instance = PaymentServices._internal();

  PaymentServices._internal();

  Map<String, dynamic>? paymentIntent;

  //1
  paymentSheetInitialization(String amount, String currency) async {
    paymentIntent = await createPaymentIntent(amount, currency); //2
    await Stripe.instance
        .initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        allowsDelayedPaymentMethods: true,
        paymentIntentClientSecret: paymentIntent!['client_secret'],
        style: ThemeMode.dark,
        merchantDisplayName: 'Swo hum Stripe Store Demo',
      ),
    )
        .then((value) {
      print(value);
    });
    displayPaymentSheet(); //3
  }

  //2
  //create Payment
  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        "amount": calculateAmount(amount),
        "currency": currency,
        // "payment_method": "card"
      };

      //Make post request to Stripe
      final dio = Dio(BaseOptions(
        baseUrl: "https://api.stripe.com/v1/payment_intents",
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
        'https://api.stripe.com/v1/payment_intents',
        data: body,
      );

      print("response from stripe: ${response.data}");

      return response.data;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  //3
  displayPaymentSheet() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet().then((value) {
        paymentIntent = null;
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
