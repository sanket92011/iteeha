// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:provider/provider.dart';

class TotalSavingWidget extends StatelessWidget {
  TotalSavingWidget({super.key});

  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  TextTheme get textTheme => Theme.of(bContext).textTheme;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    final user = Provider.of<AuthProvider>(context).user;

    return Stack(
      children: [
        Image.asset('assets/images/saving_bg_new.png'),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: dW * 0.04, vertical: dW * 0.06),
          child: Row(
            children: [
              TextWidget(
                title: language['totalSavings'],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                width: dW * 0.015,
              ),
              // TextWidget(
              //   title: '\u20B9 ${user.totalSavings}',
              //   fontSize: 16,
              //   fontWeight: FontWeight.w600,
              // ),
              TextWidget(
                title: '\u20B9 ${user.totalSavings.toInt()}',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        )
      ],
    );
  }
}
