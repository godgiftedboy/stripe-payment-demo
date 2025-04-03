import 'package:flutter/material.dart';
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
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            paymentService.paymentSheetInitialization("100", "USD");
          },
          child: const Text("Pay"),
        ),
      ),
    );
  }
}
