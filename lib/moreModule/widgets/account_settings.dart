// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/asset_svg_icon.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:provider/provider.dart';

class AccountSettings extends StatelessWidget {
  final String title;
  final Function function;
  final String svg;

  AccountSettings({
    Key? key,
    required this.title,
    required this.function,
    required this.svg,
  }) : super(key: key);

  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  TextTheme get textTheme => Theme.of(bContext).textTheme;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return InkWell(
      highlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
      splashColor: Colors.transparent,
      enableFeedback: true,
      onTap: () => function(),
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(left: dW * 0.05),
        child: Row(
          children: [
            // Container(
            //   padding: const EdgeInsets.all(6),
            //   decoration: const BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: Color(0xFFF6F6F6),
            //   ),
            //   child: AssetSvgIcon(svg),
            // ),
            AssetSvgIcon(svg),
            SizedBox(width: dW * 0.03),
            Container(
              width: dW * 0.67,
              padding: EdgeInsets.only(
                top: dW * 0.05,
                bottom: dW * 0.05,
                right: dW * 0.02,
              ),
              // decoration: BoxDecoration(
              //   border: Border(
              //       bottom: BorderSide(
              //     color: Colors.grey.withOpacity(0.2),
              //     width: 1,
              //   )),
              // ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      title: title,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(width: dW * 0.05),
                    const AssetSvgIcon('arrow_forward'),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
