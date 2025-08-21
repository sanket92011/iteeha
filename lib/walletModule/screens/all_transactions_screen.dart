import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/walletModule/providers/transaction_provider.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:iteeha_app/walletModule/widgets/transaction_widget.dart';
import 'package:provider/provider.dart';

class AllTransactionScreen extends StatefulWidget {
  const AllTransactionScreen({super.key});

  @override
  State<AllTransactionScreen> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<AllTransactionScreen> {
  //
  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    final transaction = Provider.of<TransactionProvider>(context).transactions;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => pop(),
          child: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
            size: 30,
          ),
        ),
        title: TextWidget(
          title: language['transactionHistory'],
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: dW * 0.06, vertical: dW * 0.08),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ...transaction.map(
                  (transaction) => TransactionWidget(transaction: transaction),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
