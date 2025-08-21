// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/circular_loader.dart';
import 'package:iteeha_app/navigation/arguments.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../authModule/providers/auth_provider.dart';

class PaymentScreen extends StatefulWidget {
  final PaymentScreenArguments args;
  const PaymentScreen({super.key, required this.args});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorPay;

  @override
  void initState() {
    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentError);
    getPayment();

    super.initState();
  }

  @override
  void dispose() {
    _razorPay.clear();
    super.dispose();
  }

  Future<void> paymentError(PaymentFailureResponse error) async {
    try {
      print("Error: ${error.message}${error.code}");
      pop();
      if (error.message != null) {
        var err;
        if (Platform.isAndroid) {
          err = json.decode(error.message!);
          showSnackbar("${err['error']['description']}");
        } else {
          err = error.message;
          showSnackbar(err);
        }
      }

      // final response =
      //     await Provider.of<ChatGPTProvider>(context, listen: false)
      //         .updateTransactionStatus(
      //   body: {
      //     'tId': widget.args.transaction['_id'],
      //     'status': 'Failed',
      //   },
      // );
    } catch (e) {
      print(e);
    }
  }

  void paymentSuccess(PaymentSuccessResponse paymentSuccessResponse) async {
    print("Success: ${paymentSuccessResponse.orderId}");
    if (widget.args.type == 'walletRecharge') {
      await Provider.of<AuthProvider>(context, listen: false).refreshUser();
      pop();

      pop(true);
    }
  }

  getPayment() async {
    var auth = Provider.of<AuthProvider>(context, listen: false);
    var options = {
      'key': auth.razorpayId,
      'amount': widget.args.amount * 100,
      'name': '',
      'order_id': widget.args.orderId,
      'description': '',
      'timeout': 300, // in seconds
      'prefill': {'contact': auth.user.phone, 'email': auth.user.email}
    };
    try {
      _razorPay.open(options);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dW = MediaQuery.of(context).size.width;
    return const Scaffold(body: Center(child: CircularLoader()));
  }
}
