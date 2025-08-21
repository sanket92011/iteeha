// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:provider/provider.dart';

class NewWidget extends StatelessWidget {
  NewWidget({super.key});

  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  TextTheme get textTheme => Theme.of(bContext).textTheme;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Container();
  }
}
