import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/screens/location_screen.dart';
import 'package:iteeha_app/authModule/screens/mobile_number_screen.dart';
import 'package:iteeha_app/authModule/screens/privacy_policy_screen.dart';
import 'package:iteeha_app/authModule/screens/register_user_screen.dart';
import 'package:iteeha_app/authModule/screens/search_cafe_screen.dart';
import 'package:iteeha_app/authModule/screens/verify_otp_screen.dart';
import 'package:iteeha_app/common_widgets/bottom_nav_bar.dart';
import 'package:iteeha_app/common_widgets/loading_screen.dart';
import 'package:iteeha_app/homeModule/screens/all_cafes_screen.dart';
import 'package:iteeha_app/homeModule/screens/all_menu_screen.dart';
import 'package:iteeha_app/homeModule/screens/cafe_image_screen.dart';
import 'package:iteeha_app/homeModule/screens/menu_image.screen.dart';
import 'package:iteeha_app/homeModule/screens/notification_screen.dart';
import 'package:iteeha_app/moreModule/screens/edit_profile_screen.dart';
import 'package:iteeha_app/moreModule/screens/faq_topics_screen.dart';
import 'package:iteeha_app/moreModule/screens/faqs_screen.dart';
import 'package:iteeha_app/moreModule/screens/permission_screen.dart';
import 'package:iteeha_app/walletModule/screens/all_transactions_screen.dart';
import 'package:iteeha_app/homeModule/screens/cafe_detail_screen.dart';
import 'package:iteeha_app/homeModule/screens/cafe_photosList_screen.dart';
import 'package:iteeha_app/rewardsModule/screens/reward_screen.dart';
import 'package:iteeha_app/walletModule/screens/payment_screen.dart';
import '../authModule/screens/onBoarding_screen1.dart';
import '../authModule/screens/splash_screen.dart';
import 'arguments.dart';
import 'routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // Auth Screens
    case NamedRoute.onBoardingScreen:
      return _getPageRoute(const SplashScreen());

    case NamedRoute.loadingScreen:
      return _getPageRoute(
          LoadingScreen(args: settings.arguments as LoadingScreenArguments));

    case NamedRoute.onBoardingScreen1:
      return _getPageRoute(const OnBoardingScreen1());

    case NamedRoute.mobileNumberScreen:
      return _getPageRoute(const MobileNumberScreen());

    case NamedRoute.verifyOtpScreen:
      return _getPageRoute(VerifyOtpScreen(
        args: settings.arguments as VerifyOtpArguments,
      ));

    case NamedRoute.registerUserScreen:
      return _getPageRoute(RegisterUserScreen(
          args: settings.arguments as RegistrationArguments));

    case NamedRoute.privacyPolicyAndTcScreen:
      return _getPageRoute(PrivacyPolicyAndTcScreen(
        args: settings.arguments as PrivacyPolicyAndTcScreenArguments,
      ));

    // case NamedRoute.termsOfServicesScreen:
    //   return _getPageRoute(const TermsOfServicesScreen());

    case NamedRoute.locationScreen:
      return _getPageRoute(const LocationScreen());

    case NamedRoute.searchCafeScreen:
      return _getPageRoute(const SearchCafeScreen());

    // Home Screen
    case NamedRoute.bottomNavBarScreen:
      return _getPageRoute(BottomNavBar(
        args: settings.arguments as BottomNavArgumnets,
      ));

    // case NamedRoute.walletScreen:
    //   return _getPageRoute(const WalletScreen());

    case NamedRoute.allTransactionScreen:
      return _getPageRoute(const AllTransactionScreen());

    case NamedRoute.rewardScreen:
      return _getPageRoute(const RewardScreen());

    case NamedRoute.cafePhotosListScreen:
      return _getPageRoute(const CafePhotosListScreen());

    case NamedRoute.allCafesScreen:
      return _getPageRoute(const AllCafesScreen());

    case NamedRoute.cafeDetailScreen:
      return _getPageRoute(CafeDetailScreen(
        args: settings.arguments as CafeDetailScreenArguments,
      ));

    case NamedRoute.allMenuScreen:
      return _getPageRoute(AllMenuScreen(
        args: settings.arguments as AllMenuScreenArguments,
      ));

    case NamedRoute.cafeImageScreen:
      return _getPageRoute(CafeImageScreen(
        args: settings.arguments as CafeImageArguments,
      ));

    case NamedRoute.menuImageScreen:
      return _getPageRoute(MenuImageScreen(
        args: settings.arguments as MenuImageArguments,
      ));

    case NamedRoute.editProfileScreen:
      return _getPageRoute(EditProfileScreen(
        args: settings.arguments as EditProfileScreenArguments,
      ));

    case NamedRoute.faqTopicsScreen:
      return _getPageRoute(const FaqTopicsScreen());

    case NamedRoute.notificationScreen:
      return _getPageRoute(const NotificationScreen());

    case NamedRoute.permissionScreen:
      return _getPageRoute(const PermissionScreen());

    case NamedRoute.faqsScreen:
      return _getPageRoute(
          FaqsScreen(args: settings.arguments as FaqsScreenArguments));

    case NamedRoute.paymentScreen:
      return _getPageRoute(PaymentScreen(
        args: settings.arguments as PaymentScreenArguments,
      ));

    default:
      return _getPageRoute(const SplashScreen());
  }
}

PageRoute _getPageRoute(Widget screen) {
  return MaterialPageRoute(builder: (context) => screen);
}
