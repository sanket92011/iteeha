import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/asset_svg_icon.dart';
import 'package:iteeha_app/common_widgets/cached_image_widget.dart';
import 'package:iteeha_app/common_widgets/custom_dialog.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/moreModule/widgets/account_settings.dart';
import 'package:iteeha_app/navigation/arguments.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:iteeha_app/navigation/routes.dart';
import 'package:iteeha_app/rewardsModule/models/loyalty_level_model.dart';
import 'package:iteeha_app/rewardsModule/providers/loyalty_provider.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatefulWidget {
  final Function(int) onIndexChanged;

  const MoreScreen({super.key, required this.onIndexChanged});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  //
  Map language = {};
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;
  String imgPath = '';
  late LoyaltyLevel currentLoyaltylevel;
  LoyaltyLevel? nextLoyaltylevel;
  int orders = 7;

  bool isLoading = false;

  late String thisVersion;
  Map? deleteFeature;

  logout() async {
    Provider.of<AuthProvider>(context, listen: false).logout();
    pushAndRemoveUntil(NamedRoute.mobileNumberScreen);
  }

  deleteAccount() async {
    setState(() => isLoading = true);
    final response = await Provider.of<AuthProvider>(context, listen: false).deleteAccount();
    setState(() => isLoading = false);
    if (response['success']) {
      logout();
    } else {
      showSnackbar(language[response['message']]);
    }
  }

  Widget getProfilePic(
      {required BuildContext context,
      required String? name,
      required String? avatar,
      required double radius,
      Color? backgroundColor,
      double fontSize = 18,
      FontWeight? fontWeight,
      bool isNetworkImage = false,
      Color? fontColor,
      required double tS}) {
    final user = Provider.of<AuthProvider>(context).user;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: radius,
          height: radius,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xff272559), width: 2),
              color: backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.2)),
          child: avatar == null || avatar == ''
              ? Text(
                  name != null ? getInitials(user.fullName) : '',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: tS * fontSize, fontWeight: fontWeight ?? FontWeight.w600, color: fontColor ?? Theme.of(context).primaryColor),
                )
              : Container(
                  width: radius,
                  height: radius,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: isNetworkImage
                        ? CachedImageWidget(user.avatar)
                        : Image.file(
                            File(imgPath),
                            repeat: ImageRepeat.repeat,
                            fit: BoxFit.cover,
                            width: 32,
                            height: 32,
                          ),
                  ),
                ),
        ),
        Container(
          padding: EdgeInsets.all(dW * 0.02),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: buttonColor,
          ),
          child: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    final auth = Provider.of<AuthProvider>(context, listen: false);
    // user = auth.user;
    thisVersion = Platform.isAndroid ? auth.androidVersion : auth.iOSVersion;
    deleteFeature = auth.deleteFeature;
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;

    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    final user = Provider.of<AuthProvider>(context).user;

    final loyaltyProvider = Provider.of<LoyaltyProvider>(context);

    currentLoyaltylevel = loyaltyProvider.currentLoyaltyLevel();
    nextLoyaltylevel = loyaltyProvider.nextLoyaltyLevel(currentLoyaltylevel.level);

    orders = loyaltyProvider.loyaltyTransactionCounts['loyalty${currentLoyaltylevel.level}'];

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: dW * horizontalPaddingFactor, vertical: dW * 0.08),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: dW * 0.05),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/more_bg_new.png',
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: dW * 0.19,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => push(NamedRoute.editProfileScreen, arguments: EditProfileScreenArguments(user: user)),
                                  child: getProfilePic(
                                      context: context,
                                      isNetworkImage: user.avatar != '',
                                      name: user.fullName,
                                      avatar: user.avatar != '' ? user.avatar : imgPath,
                                      backgroundColor: white,
                                      radius: 100,
                                      fontSize: 26,
                                      tS: tS),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: dW * 0.05,
                            ),
                            TextWidget(
                              title: user.fullName,
                              color: const Color(0xff404040),
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onIndexChanged(3);
                          },
                          child: Container(
                            padding: EdgeInsets.all(dW * 0.04),
                            margin: EdgeInsets.only(left: dW * 0.04, right: dW * 0.04, bottom: dW * 0.04, top: dW * 0.085),
                            decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextWidget(
                                      title: '${currentLoyaltylevel.name} (Level ${currentLoyaltylevel.level})',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff37383F),
                                    ),
                                    Row(
                                      children: [
                                        TextWidget(
                                          title: '$orders/${(nextLoyaltylevel ?? currentLoyaltylevel).transactionCount} ',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff515259),
                                        ),
                                        const AssetSvgIcon('cup')
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: dW * 0.028),
                                Container(
                                  height: dW * 0.02,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: LinearProgressIndicator(
                                      value: orders / (nextLoyaltylevel ?? currentLoyaltylevel).transactionCount,
                                      backgroundColor: const Color(0xffEFF6F8),
                                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff4F4D8B)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: dW * 0.025),
                                if (nextLoyaltylevel != null) ...[
                                  Row(
                                    children: [
                                      TextWidget(
                                        title:
                                            'Make ${nextLoyaltylevel!.transactionCount - (orders)} more purchases in the next ${nextLoyaltylevel!.days} days',
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff84858E),
                                      ),
                                      // AssetSvgIcon(
                                      //   'calender1',
                                      //   width: 20,
                                      // ),
                                      const TextWidget(
                                        title: ' to level up.',
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff84858E),
                                      ),
                                    ],
                                  )
                                ],
                                if (nextLoyaltylevel == null)
                                  TextWidget(
                                    title: language['milestone'],
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff84858E),
                                  ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: dW * 0.02),
                  margin: EdgeInsets.only(top: dW * 0.08, bottom: dW * 0.06),
                  decoration: BoxDecoration(
                    color: const Color(0xffEFFAFE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      AccountSettings(
                        svg: 'faq_icon',
                        title: "FAQs",
                        function: () => push(NamedRoute.faqTopicsScreen),
                      ),
                      AccountSettings(
                        svg: 'help_support',
                        title: language['help&Support'],
                        function: () => launchWhatsApp(phoneNumber: Provider.of<AuthProvider>(context, listen: false).helpAndSuppWhatsApp),
                        // function: () {},
                      ),
                      AccountSettings(
                        svg: 'permission_icon',
                        title: language['permissions'],
                        function: () => push(NamedRoute.permissionScreen),
                      ),
                      if (deleteFeature != null && deleteFeature!['version'] == thisVersion && deleteFeature!['enabled'])
                        AccountSettings(
                          svg: 'delete_account',
                          title: language['deleteAccount'],
                          function: () => showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                              title: language['deleteAccount'],
                              subTitle: language['confirmDeleteAccount'],
                              noText: language['no'],
                              yesText: language['yes'],
                              noFunction: () {
                                pop();
                              },
                              yesFunction: () {
                                deleteAccount();
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: dW * 0.01),
                  decoration: BoxDecoration(
                    color: const Color(0xffEFFAFE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      AccountSettings(
                        svg: 'logout',
                        title: language['logout'],
                        function: () => showDialog(
                          context: context,
                          builder: (context) => CustomDialog(
                            title: language['logout'],
                            subTitle: language['wantToLogout'],
                            noText: language['no'],
                            yesText: language['yes'],
                            noFunction: () {
                              pop();
                            },
                            yesFunction: () {
                              logout();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
