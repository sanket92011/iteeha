// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/asset_svg_icon.dart';
import 'package:iteeha_app/common_widgets/cached_image_widget.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/rewardsModule/models/loyalty_level_model.dart';
import 'package:iteeha_app/rewardsModule/providers/loyalty_provider.dart';
import 'package:provider/provider.dart';

class LoyaltyLevelWidget extends StatefulWidget {
  const LoyaltyLevelWidget({super.key});

  @override
  State<LoyaltyLevelWidget> createState() => _LoyaltyLevelWidgetState();
}

class _LoyaltyLevelWidgetState extends State<LoyaltyLevelWidget> {
  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;
  late LoyaltyLevel currentLoyaltyLevel;
  LoyaltyLevel? nextLoyaltyLevel;
  int orders = 0;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    final loyaltyProvider = Provider.of<LoyaltyProvider>(context);

    currentLoyaltyLevel = loyaltyProvider.currentLoyaltyLevel();
    nextLoyaltyLevel =
        loyaltyProvider.nextLoyaltyLevel(currentLoyaltyLevel.level);

    orders = loyaltyProvider
        .loyaltyTransactionCounts['loyalty${currentLoyaltyLevel.level}'];

    return Container(
      decoration: BoxDecoration(
          // color: const Color(0xffFFCABC),
          color: const Color(0xffCAF2FF),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Stack(children: [
            //Image.asset('assets/images/level_bg.png'),
            Image.asset('assets/images/card_bg.png'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image.asset(
                    //   'assets/images/bean_icon.png',
                    //   scale: 1.7,
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: dW * 0.04, vertical: dW * 0.06),
                      child: CachedImageWidget(
                        currentLoyaltyLevel.badge,
                        scale: 1.7,
                        width: 42,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: dW * 0.06),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: dW * 0.01),
                          TextWidget(
                            title: currentLoyaltyLevel.name,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0XFF292454),
                          ),
                          SizedBox(height: dW * 0.025),
                          TextWidget(
                            title:
                                // currentLoyaltyLevel.level == 1
                                //     ? '${language['validTill']} ${DateFormat('dd MMM yyyy').format(DateTime.now().add(Duration(days: (currentLoyaltyLevel.days).toInt())))}'
                                //     : currentLoyaltyLevel.level == 2
                                //         ? '${language['validTill']} ${DateFormat('dd MMM yyyy').format(DateTime.now().add(Duration(days: (currentLoyaltyLevel.days).toInt())))}'
                                //         :
                                '${language['validTill']} ${DateFormat('dd MMM yyyy').format(DateTime.now().add(Duration(days: (currentLoyaltyLevel.days).toInt())))}',
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0XFF84858E),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (nextLoyaltyLevel == null)
                      Padding(
                        padding: EdgeInsets.only(top: dW * 0.06),
                        child: const AssetSvgIcon('patron_cup'),
                      )
                  ],
                ),
                // Container(
                //   margin: EdgeInsets.symmetric(vertical: dW * 0.03),
                //   child: const Divider(
                //     color: Color(0xff925546),
                //     thickness: 1.5,
                //   ),
                // ),
                if (nextLoyaltyLevel != null) ...[
                  Padding(
                    padding: EdgeInsets.only(
                      right: dW * 0.05,
                      left: dW * 0.05,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          title: 'For Level ${nextLoyaltyLevel!.level}',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0XFF292454),
                        ),
                        Row(
                          children: [
                            TextWidget(
                              title:
                                  '$orders/${nextLoyaltyLevel!.transactionCount} ',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0XFF292454),
                            ),
                            const AssetSvgIcon(
                              'coffee_new',
                              width: 25,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: dW * 0.02),
                  Container(
                    margin: EdgeInsets.only(
                      right: dW * 0.05,
                      left: dW * 0.05,
                    ),
                    height: dW * 0.02,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: LinearProgressIndicator(
                        value: orders / nextLoyaltyLevel!.transactionCount,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xff5ECBEE)),
                      ),
                    ),
                  ),
                  SizedBox(height: dW * 0.03),
                  Padding(
                    padding: EdgeInsets.only(
                      right: dW * 0.05,
                      left: dW * 0.05,
                    ),
                    child: Row(
                      children: [
                        TextWidget(
                          title:
                              'Make ${nextLoyaltyLevel!.transactionCount - (orders)} more transactions ️in ${nextLoyaltyLevel!.days} Days',
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: const Color(0XFF84858E),
                        ),
                        // const AssetSvgIcon(
                        //   'calendar',
                        //   width: 18,
                        // ),
                        const TextWidget(
                          title: ' to level up.',
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color(0XFF84858E),
                        ),
                      ],
                    ),
                  ),
                ] else
                  Container(
                    padding: EdgeInsets.only(
                        left: dW * 0.05, right: dW * 0.05, top: dW * 0.02),
                    child: Text(
                      language['milestone'],
                      style: textTheme.headlineLarge!.copyWith(
                        fontSize: tS * 12,
                        color: const Color(0XFF292454),
                      ),
                    ),
                  ),
              ],
            ),
          ]),
          if (currentLoyaltyLevel.birthdayBeverage)
            Padding(
              padding: EdgeInsets.only(
                  left: dW * horizontalPaddingFactor,
                  top: dW * 0.04,
                  bottom: dW * 0.04),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/beverage_coin_bg_new.png',
                    scale: 1.6,
                  ),
                  SizedBox(
                    width: dW * 0.02,
                  ),
                  TextWidget(
                    title: language['reward'],
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff1D1E22),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          title: language['1freeBeverageAsACompletionReward'],
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff1D1E22),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
