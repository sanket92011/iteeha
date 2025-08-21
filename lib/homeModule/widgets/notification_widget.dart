// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:provider/provider.dart';

class NotificationWidget extends StatelessWidget {
  String title;
  String subTitle;
  NotificationWidget({super.key, required this.title, required this.subTitle});

  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  TextTheme get textTheme => Theme.of(bContext).textTheme;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dW * horizontalPaddingFactor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/iteeha_coffee.png',
            scale: 1.7,
          ),
          SizedBox(
            width: dW * 0.04,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                title: title,
                fontWeight: FontWeight.w500,
                color: const Color(0xff000000),
              ),
              SizedBox(
                height: dW * 0.01,
              ),
              TextWidget(
                title: subTitle,
                color: const Color(0xff767676),
                fontSize: 12,
              ),
            ],
          )
        ],
      ),
    );
  }
}
