// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/asset_svg_icon.dart';
import 'package:iteeha_app/common_widgets/cached_image_widget.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/common_widgets/vertical_dotted_line.dart';
import 'package:iteeha_app/navigation/arguments.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:iteeha_app/navigation/routes.dart';
import 'package:iteeha_app/rewardsModule/models/loyalty_level_model.dart';
import 'package:iteeha_app/rewardsModule/models/offer_model.dart';
import 'package:iteeha_app/rewardsModule/providers/loyalty_provider.dart';
import 'package:iteeha_app/rewardsModule/providers/offers_provider.dart';
import 'package:iteeha_app/homeModule/widgets/offer_widget.dart';
import 'package:iteeha_app/homeModule/widgets/offers_bottomSheet_widget.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/empty_list_widget.dart';
import '../../homeModule/widgets/refer_bottom_sheet_widget.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen>
    with TickerProviderStateMixin {
  //
  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;
  late TabController _tabController;
  late LoyaltyLevel currentLoyaltyLevel;
  LoyaltyLevel? nextLoyaltyLevel;
  int orders = 0;

  final List<Color> containerColors = [
    const Color(0xffF1FCFF),
    const Color(0xffDFF7FF),
    const Color(0xffD0F5FF),
    const Color(0xffD0F5FF),
  ];

  fetchData() async {}

  void offerBottomSheet(Offer offer) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => Wrap(
        children: [
          OffersBottomSheetWidget(
            offer: offer,
          ),
        ],
      ),
    );
  }

  void referBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => Wrap(
        children: const [
          ReferBottomSheetWidget(),
        ],
      ),
    );
  }

  Widget get loyaltyProgramTab {
    final user = Provider.of<AuthProvider>(context).user;
    currentLoyaltyLevel =
        Provider.of<LoyaltyProvider>(context).currentLoyaltyLevel();

    nextLoyaltyLevel = Provider.of<LoyaltyProvider>(context)
            .nextLoyaltyLevel(currentLoyaltyLevel.level)
        // ?? currentLoyaltyLevel
        ;
    final loyaltyLevels = Provider.of<LoyaltyProvider>(context).loyaltyLevels;
    final loyaltyProgramNotes =
        Provider.of<LoyaltyProvider>(context).loyaltyProgramNotes;

    orders = Provider.of<LoyaltyProvider>(context)
        .loyaltyTransactionCounts['loyalty${currentLoyaltyLevel.level}'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dW * horizontalPaddingFactor),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: dW * 0.06),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffDBDBE3)),
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Stack(children: [
                      Image.asset('assets/images/reward_level_bg_new.png'),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: dW * 0.04, vertical: dW * 0.06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedImageWidget(
                                  currentLoyaltyLevel.badge,
                                  scale: 1.7,
                                  width: 42,
                                ),
                                SizedBox(width: dW * 0.04),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: dW * 0.01),
                                    TextWidget(
                                      title: currentLoyaltyLevel.name,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff292454),
                                    ),
                                    SizedBox(height: dW * 0.015),
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
                                      color: const Color(0xff84858E),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // SizedBox(height: dW * 0.03),
                            // const Divider(
                            //   color: Color(0xff925546),
                            //   thickness: 1,
                            // ),
                            // SizedBox(height: dW * 0.1),
                            Padding(
                              padding: EdgeInsets.only(top: dW * 0.2),
                              child: TextWidget(
                                title: user.fullName,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: const Color(0xff292454),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  // SizedBox(
                  //   height: dW * (nextLoyaltyLevel != null ? 0.08 : 0.02),
                  // ),
                  if (nextLoyaltyLevel != null)
                    Container(
                      margin: EdgeInsets.only(top: dW * 0.08),
                      padding: EdgeInsets.only(
                        bottom: dW * 0.04,
                        left: dW * 0.06,
                        right: dW * 0.06,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CachedImageWidget(
                                nextLoyaltyLevel!.badge,
                                scale: 1.8,
                                width: 35,
                              ),
                              SizedBox(width: dW * 0.04),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            TextWidget(
                                              title: nextLoyaltyLevel!.name,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff606060),
                                            ),
                                            TextWidget(
                                              title:
                                                  ' (${language['forLevel']} ${nextLoyaltyLevel!.level})',
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff9B9B9B),
                                            ),
                                          ],
                                        ),
                                        TextWidget(
                                          title:
                                              '$orders/${nextLoyaltyLevel!.transactionCount} ',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: dW * 0.025,
                                    ),
                                    Container(
                                      height: dW * 0.02,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: LinearProgressIndicator(
                                          value: (orders) /
                                              nextLoyaltyLevel!
                                                  .transactionCount,
                                          backgroundColor:
                                              const Color(0xffEFF6F8),
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(Color(0xff272559)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: dW * 0.03),
                          const Divider(color: Color(0xffDBDBE3)),
                          SizedBox(height: dW * 0.03),
                          Wrap(
                            children: [
                              TextWidget(
                                title:
                                    'Need ${nextLoyaltyLevel!.transactionCount - orders} more purchases in next ${nextLoyaltyLevel!.days} days to level up.',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff9B9B9B),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: EdgeInsets.only(top: dW * 0.01),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/max_lvl_achieved.png',
                              width: dW,
                            ),
                            Positioned(
                              top: 12,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: dW * 0.045),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  language['achvdMaxLvl'],
                                  style: textTheme.headlineLarge!.copyWith(
                                    fontSize: tS * 11.5,
                                    color: const Color(0xFF37383F),
                                    height: 1.7,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (nextLoyaltyLevel != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: dW * 0.06, vertical: dW * 0.04),
                      decoration: const BoxDecoration(
                        // border: Border.fromBorderSide(),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular((16)),
                            bottomRight: Radius.circular(16)),
                        color: Color(0xffCAF2FF),
                      ),
                      child: Row(children: [
                        Column(
                          children: [
                            Image.asset(
                              'assets/images/beverage_coin_bg_new2.png',
                              height: dW * 0.125,
                            ),
                          ],
                        ),
                        SizedBox(width: dW * 0.04),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              TextWidget(
                                title:
                                    'You’ll get one coffee for free when you complete level one.',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                ],
              ),
            ),
            SizedBox(height: dW * 0.1),
            TextWidget(
              title: language['loyaltyProgramBenefits'],
              fontWeight: FontWeight.w600,
              color: const Color(0xff434343),
            ),
            Container(
              margin: EdgeInsets.only(top: dW * 0.06, bottom: dW * 0.08),
              padding: EdgeInsets.only(
                left: dW * 0.045,
              ),
              decoration: BoxDecoration(
                  color: const Color(0xffF1FCFF),
                  borderRadius: BorderRadius.circular(16)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: dW * 0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: dW * 0.15,
                        ),
                        TextWidget(
                          title: language['benefits'],
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: const Color(0xff434343),
                        ),
                        SizedBox(
                          height: dW * 0.12,
                        ),
                        TextWidget(
                          title: language['birthdayBeverage'],
                          fontSize: 12,
                          color: const Color(0xff434343),
                        ),
                        SizedBox(
                          height: dW * 0.07,
                        ),
                        TextWidget(
                          title: language['loyaltyPoints'],
                          fontSize: 12,
                          color: const Color(0xff434343),
                        ),
                        SizedBox(
                          height: dW * 0.07,
                        ),
                        TextWidget(
                          title: language['1FreeBeverageAfter'],
                          fontSize: 12,
                          color: const Color(0xff434343),
                        ),
                        SizedBox(
                          height: dW * 0.07,
                        ),
                        // TextWidget(
                        //   title: language['discountOnFood'],
                        //   fontSize: 12,
                        //   color: const Color(0xff434343),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: dW * 0.02,
                  ),
                  ...loyaltyLevels.map(
                    (loyaltyLevel) => Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            color:
                                loyaltyLevel.level == currentLoyaltyLevel.level
                                    ? const Color(0xffDFF7FF)
                                    : null,
                            margin: EdgeInsets.only(
                                left: dW * 0.01, right: dW * 0.01),
                            padding: EdgeInsets.only(
                                left: dW * 0.015, right: dW * 0.015),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: dW * 0.1,
                                ),
                                CachedImageWidget(
                                  loyaltyLevel.badge,
                                  width: 30,
                                ),
                                SizedBox(height: dW * 0.02),
                                TextWidget(
                                  textAlign: TextAlign.center,
                                  title: loyaltyLevel.name,
                                  fontSize: 8,
                                ),
                                SizedBox(height: dW * 0.085),
                                loyaltyLevel.birthdayBeverage
                                    ? const AssetSvgIcon('tick_green_new')
                                    : const AssetSvgIcon('cross_red'),
                                SizedBox(height: dW * 0.075),
                                loyaltyLevel.loyaltyPoints == 0
                                    ? Container(
                                        height: dW * 0.066,
                                        alignment: Alignment.center,
                                        child: const AssetSvgIcon('cross_red'))
                                    : Container(
                                        height: dW * 0.066,
                                        alignment: Alignment.center,
                                        child: TextWidget(
                                          title:
                                              '${loyaltyLevel.loyaltyPoints.toString()}%',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                SizedBox(height: dW * 0.085),
                                TextWidget(
                                  title: loyaltyLevel.freeBeveragePurchaseCount
                                      .toString(),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                                SizedBox(height: dW * 0.02),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: TextWidget(
                                    title: language['purchases'],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: dW * 0.09),
                                // loyaltyLevel.foodDiscount == 0
                                //     ? Container(
                                //         height: dW * 0.066,
                                //         alignment: Alignment.center,
                                //         child: const AssetSvgIcon('cross_red'))
                                //     : Container(
                                //         height: dW * 0.066,
                                //         alignment: Alignment.center,
                                //         child: TextWidget(
                                //           title:
                                //               '${loyaltyLevel.foodDiscount.toString()}%',
                                //           fontWeight: FontWeight.w600,
                                //           fontSize: 12,
                                //         ),
                                //       ),
                                // SizedBox(height: dW * 0.08)
                              ],
                            ),
                          ),
                          if (loyaltyLevel.level == currentLoyaltyLevel.level)
                            Positioned(
                              top: -10,
                              child: Container(
                                margin: EdgeInsets.only(left: dW * 0.03),
                                padding: EdgeInsets.symmetric(
                                    horizontal: dW * 0.02, vertical: dW * 0.01),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xff000000)
                                            .withOpacity(0.15),
                                        offset: const Offset(0, 4),
                                        blurRadius: 4,
                                      ),
                                    ],
                                    border: Border.all(
                                      width: 1,
                                      color: const Color(0xffDBDBE3),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                    color: white),
                                child: TextWidget(
                                  title: language['ongoing'],
                                  color: const Color(0xff272559),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextWidget(
              title: language['loyaltyProgramLevels'],
              fontWeight: FontWeight.w600,
              color: const Color(0xff434343),
            ),
            SizedBox(height: dW * 0.06),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: loyaltyLevels.length,
              itemBuilder: (context, i) {
                Color itemColor = containerColors[i];
                BorderRadius borderRadius;
                bool isLast =
                    loyaltyLevels[i].level == loyaltyLevels.last.level;

                if (i == 0) {
                  borderRadius = const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  );
                } else if (i == loyaltyLevels.length - 1) {
                  borderRadius = const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  );
                } else {
                  borderRadius = BorderRadius.zero;
                }
                return Container(
                  padding: EdgeInsets.only(
                      top: dW * 0.04,
                      right: dW * 0.04,
                      bottom: dW * 0.05,
                      left: dW * 0.035),
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: itemColor,
                  ),
                  key: ValueKey(loyaltyLevels[i]),
                  child: Row(
                    children: [
                      SizedBox(
                        width: dW * 0.22,
                        child: Column(
                          children: [
                            CachedImageWidget(
                              loyaltyLevels[i].badge,
                              width: 27,
                            ),
                            SizedBox(height: dW * 0.015),
                            TextWidget(
                              textAlign: TextAlign.center,
                              title: loyaltyLevels[i].name,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                            SizedBox(height: dW * 0.02),
                            TextWidget(
                              title:
                                  '${language['level']} ${loyaltyLevels[i].level.toString()}',
                              fontWeight: FontWeight.w500,
                              fontSize: 8,
                              color: const Color(0xff84858E),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: dW * 0.05, right: dW * 0.04),
                        height: dW * 0.15,
                        child: VerticalSeparator(
                          color: const Color(0xff686868),
                        ),
                      ),
                      // if (loyaltyLevels[i].level != loyaltyLevels.last.level)
                      //   Expanded(
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Row(
                      //               children: [
                      //                 TextWidget(
                      //                   title:
                      //                       // loyaltyLevels[i].level ==
                      //                       //         loyaltyLevels.last.level
                      //                       //     ? '${language['toMaintainLevel']} ${loyaltyLevels[i].level}'
                      //                       //     :
                      //                       '${language['forLevel']} ${loyaltyLevels[i].level + 1}',
                      //                   fontSize: 10,
                      //                   fontWeight: FontWeight.w600,
                      //                   color: const Color(0xff9B9B9B),
                      //                 ),
                      //               ],
                      //             ),
                      //             Row(
                      //               children: [
                      //                 TextWidget(
                      //                   title:
                      //                       '$orders/${loyaltyLevels[i].transactionCount} ',
                      //                   fontSize: 10,
                      //                   fontWeight: FontWeight.w500,
                      //                 ),
                      //                 const AssetSvgIcon(
                      //                   'coffee_new',
                      //                   width: 15,
                      //                 ),
                      //               ],
                      //             ),
                      //           ],
                      //         ),
                      //         SizedBox(height: dW * 0.025),
                      //         Container(
                      //           height: dW * 0.02,
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(8.0),
                      //           ),
                      //           child: ClipRRect(
                      //             borderRadius: BorderRadius.circular(8.0),
                      //             child: LinearProgressIndicator(
                      //               value: (orders) /
                      //                   (loyaltyLevels[i].transactionCount),
                      //               backgroundColor: const Color(0xffEFF6F8),
                      //               valueColor:
                      //                   const AlwaysStoppedAnimation<Color>(
                      //                       Color(0xff272559)),
                      //             ),
                      //           ),
                      //         ),
                      //         SizedBox(height: dW * 0.025),
                      //         TextWidget(
                      //           title:
                      //               '${loyaltyLevels[i].transactionCount} transactions ️in ${loyaltyLevels[i].days} days to upgrade to level ${loyaltyLevels[i].level + 1}',
                      //           color: const Color(0xff84858E),
                      //           fontSize: 10,
                      //         )
                      //       ],
                      //     ),
                      //   )
                      // else
                      //   Expanded(
                      //     child: Text(
                      //       currentLoyaltyLevel.level ==
                      //               loyaltyLevels.last.level
                      //           ? language['achvdMaxLvl']
                      //           : (language['notAchvdMaxLvl'] as String)
                      //               .replaceAll('{{level}}',
                      //                   loyaltyLevels.last.level.toString()),
                      //       style: textTheme.headlineLarge!.copyWith(
                      //         fontSize: tS *
                      //             (currentLoyaltyLevel.level ==
                      //                     loyaltyLevels.last.level
                      //                 ? 11
                      //                 : 11.5),
                      //         color: const Color(0xFF37383F),
                      //         height: 1.7,
                      //       ),
                      //     ),
                      //   ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    TextWidget(
                                      title: isLast
                                          ? '${language['toMaintainLevel']} ${loyaltyLevels[i].level}'
                                          : '${language['forLevel']} ${loyaltyLevels[i].level + 1}',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff9B9B9B),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    TextWidget(
                                      title: isLast
                                          ? '${currentLoyaltyLevel.level < loyaltyLevels[i].level ? (0) : orders}/${loyaltyLevels[i].transactionCount} '
                                          : '${currentLoyaltyLevel.level < loyaltyLevels[i].level ? (0) : orders}/${loyaltyLevels[i + 1].transactionCount} ',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const AssetSvgIcon(
                                      'coffee_new',
                                      width: 15,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: dW * 0.025),
                            Container(
                              height: dW * 0.02,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: LinearProgressIndicator(
                                  value: currentLoyaltyLevel.level <
                                          loyaltyLevels[i].level
                                      ? (0)
                                      : ((orders) /
                                          (isLast
                                              ? loyaltyLevels[i]
                                                  .transactionCount
                                              : loyaltyLevels[i + 1]
                                                  .transactionCount)),
                                  backgroundColor: const Color(0xffEFF6F8),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Color(0xff272559)),
                                ),
                              ),
                            ),
                            SizedBox(height: dW * 0.025),
                            if (!isLast)
                              TextWidget(
                                title:
                                    '${loyaltyLevels[i + 1].transactionCount} transactions ️in ${loyaltyLevels[i + 1].days} days to upgrade to level ${loyaltyLevels[i + 1].level}',
                                color: const Color(0xff84858E),
                                fontSize: 10,
                              ),
                            if (isLast)
                              Text(
                                currentLoyaltyLevel.level ==
                                        loyaltyLevels.last.level
                                    ? language['achvdMaxLvl']
                                    : (language['notAchvdMaxLvl'] as String)
                                        .replaceAll(
                                            '{{level}}',
                                            loyaltyLevels.last.level
                                                .toString()),
                                style: textTheme.headlineLarge!.copyWith(
                                  fontSize: 10,
                                  color: const Color(0xFF84858E),
                                ),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: dW * 0.06),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color(0xffDBDBE3),
                  ),
                  borderRadius: BorderRadius.circular(16)),
              padding: EdgeInsets.symmetric(
                  horizontal: dW * 0.04, vertical: dW * 0.06),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    title: language['note'],
                    color: const Color(0xff37383F),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(width: dW * 0.02),
                  Expanded(
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: loyaltyProgramNotes.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      title: '${index + 1}. ',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: const Color(0xffAAABB5),
                                    ),
                                    Expanded(
                                      child: TextWidget(
                                        title: loyaltyProgramNotes[index],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: const Color(0xffAAABB5),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: dW * 0.01),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: dW * 0.08),
            GestureDetector(
              onTap: () => push(NamedRoute.faqsScreen,
                  arguments: FaqsScreenArguments(topicName: 'Loyalty Program')),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color(0xffDBDBE3),
                    ),
                    borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.symmetric(
                    horizontal: dW * 0.06, vertical: dW * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(
                          title: 'Still have doubts?',
                          color: Color(0xff37383F),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: dW * 0.02),
                        const TextWidget(
                          title: 'Go to the FAQs section.',
                          color: Color(0xff9B9B9B),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    const AssetSvgIcon(
                      'arrow_forward',
                      color: Color(0xff292D32),
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: dW * 0.1)
          ],
        ),
      ),
    );
  }

  Widget get offersTab {
    final offers = Provider.of<OffersProvider>(context).alignedOffers;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dW * horizontalPaddingFactor),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (offers.isNotEmpty) ...[
              SizedBox(height: dW * 0.06),
              TextWidget(
                title: language['exclusiveOffers'],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ],
            SizedBox(height: dW * 0.04),
            if (offers.isEmpty)
              EmptyListWidget(text: language['noOfrsAvailbl'], topPadding: 0.1),
            ListView.builder(
              shrinkWrap: true,
              itemCount: offers.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, i) => GestureDetector(
                  onTap: () => offerBottomSheet(offers[i]),
                  child: OfferWidget(
                    key: ValueKey(offers[i].id),
                    offer: offers[i],
                  )),
            ),
            if (offers.isNotEmpty)
              GestureDetector(
                onTap: referBottomSheet,
                child: Padding(
                  padding: EdgeInsets.only(bottom: dW * 0.1),
                  child: Image.asset(
                    'assets/images/refer1_bg_new.png',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    final dH = MediaQuery.of(context).size.height;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.only(top: dW * 0.04, bottom: dW * 0.04),
              padding: EdgeInsets.symmetric(
                  horizontal: dW * horizontalPaddingFactor),
              child: TextWidget(
                title: language['rewards'],
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            if (!iOSCondition(dH)) SizedBox(height: dW * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: dW * horizontalPaddingFactor),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: dW * 0.06),
                padding: EdgeInsets.all(dW * .02),
                decoration: BoxDecoration(
                    color: const Color(0xffEFF6F8),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4))
                    ]),
                child: TabBar(
                  physics: const BouncingScrollPhysics(),
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  splashBorderRadius: BorderRadius.circular(8),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                  unselectedLabelColor: getUnselectedLabelColor(context),
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.w400),
                  labelColor: const Color(0xff434343),
                  labelStyle: textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.w500),
                  tabs: [
                    Tab(
                      height: dW * .1,
                      child: const Text(
                        'Loyalty Program',
                        style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
                      ),
                    ),
                    Tab(
                      height: dW * .1,
                      child: const Text(
                        'Offers',
                        style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
                      ),
                    ),
                  ],
                  controller: _tabController,
                ),
              ),
            ),
            Flexible(
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                controller: _tabController,
                children: [
                  loyaltyProgramTab,
                  offersTab,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
