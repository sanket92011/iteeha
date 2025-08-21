// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/asset_svg_icon.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:provider/provider.dart';

class FaqTopicContainerWidget extends StatelessWidget {
  String title;
  final Function onTap;
  FaqTopicContainerWidget(
      {super.key, required this.title, required this.onTap});

  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  TextTheme get textTheme => Theme.of(bContext).textTheme;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.only(bottom: dW * 0.04),
        padding: EdgeInsets.all(dW * 0.04),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: const Color(0xffBFC0C8),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              title: title,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: const Color(0xff84858E),
            ),
            const AssetSvgIcon('arrow_forward')
          ],
        ),
      ),
    );
  }
}
