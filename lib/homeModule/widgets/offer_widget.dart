// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/cached_image_widget.dart';
import 'package:iteeha_app/rewardsModule/models/offer_model.dart';
import 'package:provider/provider.dart';

class OfferWidget extends StatefulWidget {
  final Offer offer;

  const OfferWidget({super.key, required this.offer});

  @override
  State<OfferWidget> createState() => _OfferWidgetState();
}

class _OfferWidgetState extends State<OfferWidget> {
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
          widget.offer.image,
          height: dW * 0.45,
        ),
      ),
    );
  }
}
