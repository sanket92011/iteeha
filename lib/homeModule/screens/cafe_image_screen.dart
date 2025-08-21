// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/cached_image_widget.dart';
import 'package:iteeha_app/homeModule/models/cafe_model.dart';
import 'package:iteeha_app/navigation/arguments.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class CafeImageScreen extends StatefulWidget {
  final CafeImageArguments args;

  const CafeImageScreen({super.key, required this.args});

  @override
  State<CafeImageScreen> createState() => _CafeImageScreenState();
}

class _CafeImageScreenState extends State<CafeImageScreen> {
  double dW = 0.0;
  double dH = 0.0;

  double tS = 0.0;

  Map language = {};

  TextTheme get textTheme => Theme.of(bContext).textTheme;

  late Cafe cafe;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;

    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

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
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: dW * horizontalPaddingFactor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: dW * 0.1),
              child: CachedImageWidget(
                widget.args.otherPhoto,
                height: dH * 0.6,
              ),
            )
          ],
        ),
      )),
    );
  }
}
