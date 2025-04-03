import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_payment_demo/payment_services.dart';

class PaymentDemoPage extends StatefulWidget {
  const PaymentDemoPage({super.key});

  @override
  State<PaymentDemoPage> createState() => _PaymentDemoPageState();
}

class _PaymentDemoPageState extends State<PaymentDemoPage> {
  final paymentService = PaymentServices.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white, // Background color
              borderRadius: BorderRadius.circular(10), // Rounded corners
              border:
                  Border.all(color: Colors.grey.shade300, width: 1), // Border
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Soft shadow
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Card Details",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                CardFormField(
                  style: CardFormStyle(
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    borderRadius: 10,
                    cursorColor: Colors.blue,
                    fontSize: 16,
                    placeholderColor: Colors.grey.shade500,
                    borderColor: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              paymentService.createStripeTokenInitialization("100", "USD");
            },
            child: const Text("Pay"),
          ),
        ],
      ),
    );
  }
}
