// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../common_widgets/asset_svg_icon.dart';
import '../../common_widgets/text_widget.dart';
import '../models/transaction_model.dart';

class TransactionWidget extends StatelessWidget {
  final Transaction transaction;
  TransactionWidget({super.key, required this.transaction});

  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  TextTheme get textTheme => Theme.of(bContext).textTheme;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Container(
      margin: EdgeInsets.only(bottom: dW * 0.05),
      padding: EdgeInsets.all(dW * 0.025),
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xffF4F4F4),
          ),
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AssetSvgIcon(transaction.transactionType.contains('Debit')
              ? 'wallet_debit'
              : 'wallet_credit'),
          SizedBox(width: dW * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  title: transaction.transactionType.contains('Debit')
                      ? 'Order #${transaction.ppOrderId}'
                      : "Money Added To Card",
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: dW * 0.015),
                Row(
                  children: [
                    // TextWidget(
                    //   title: DateFormat('dd/MM/yyyy')
                    //       .format(transaction.createdAt),
                    //   fontSize: 10,
                    //   color: const Color(0xff515259),
                    // ),
                    TextWidget(
                      title: DateFormat('d MMMM, yyyy')
                          .format(transaction.createdAt),
                      fontSize: 10,
                      color: const Color(0xff515259),
                    ),

                    if (transaction.transactionType.contains('Debit')) ...[
                      SizedBox(width: dW * 0.01),
                      const Icon(
                        Icons.circle,
                        size: 5,
                        color: Color(0xffAAABB5),
                      ),
                      SizedBox(width: dW * 0.01),
                      // if (transaction.cafe != null)
                      //   TextWidget(
                      //     title: transaction.cafe!.area,
                      //     fontSize: 10,
                      //     color: const Color(0xff515259),
                      //   ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (transaction.transactionType.contains('Debit')) ...[
                TextWidget(
                  title: '- \u20B9 ${transaction.totalAmount}',
                  color: const Color(0xff515259),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: dW * 0.02),
              ] else
                TextWidget(
                  title: '+ \u20B9 ${transaction.totalAmount}',
                  color: greenColor,
                  fontWeight: FontWeight.w600,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
