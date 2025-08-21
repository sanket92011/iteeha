// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/cached_image_widget.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/homeModule/models/cafe_model.dart';
import 'package:iteeha_app/navigation/arguments.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:iteeha_app/navigation/routes.dart';
import 'package:provider/provider.dart';

class AllMenuScreen extends StatefulWidget {
  final AllMenuScreenArguments args;

  const AllMenuScreen({super.key, required this.args});

  @override
  State<AllMenuScreen> createState() => _AllMenuScreenState();
}

class _AllMenuScreenState extends State<AllMenuScreen> {
  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  TextTheme get textTheme => Theme.of(bContext).textTheme;
  late Cafe cafe;

  @override
  void initState() {
    super.initState();
    cafe = widget.args.cafe;
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
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
        title: TextWidget(
          title: language['menu'],
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      body: SafeArea(
          child: ListView.builder(
        shrinkWrap: true,
        itemCount: cafe.menu.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) => Padding(
          padding: EdgeInsets.symmetric(
            // horizontal: dW * horizontalPaddingFactor,
            vertical: dW * 0.05,
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => push(
                  NamedRoute.menuImageScreen,
                  arguments: MenuImageArguments(menuPhoto: cafe.menu[i]),
                ),
                child: CachedImageWidget(
                  cafe.menu[i],
                  width: dW,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
