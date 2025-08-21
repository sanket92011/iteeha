// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/cached_image_widget.dart';
import 'package:provider/provider.dart';

import '../models/banner_model.dart';

class BannerWidget extends StatefulWidget {
  final BannerModel banner;

  const BannerWidget({super.key, required this.banner});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(bottom: dW * 0.06),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedImageWidget(
          widget.banner.image,
          height: dW * 0.45,
        ),
      ),
    );
  }
}
