// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:iteeha_app/authModule/widgets/onBoarding_widget1.dart';
// import 'package:iteeha_app/authModule/widgets/onBoarding_widget2.dart';
// import 'package:iteeha_app/authModule/widgets/onBoarding_widget3.dart';
// import 'package:iteeha_app/colors.dart';
// import 'package:iteeha_app/common_widgets/asset_svg_icon.dart';
// import 'package:iteeha_app/common_widgets/text_widget.dart';
// import 'package:iteeha_app/navigation/navigators.dart';
// import 'package:iteeha_app/navigation/routes.dart';
// import 'package:provider/provider.dart';

// import '../../common_functions.dart';
// import '../providers/auth_provider.dart';

// class OnBoardingScreen1 extends StatefulWidget {
//   const OnBoardingScreen1({super.key});

//   @override
//   State<OnBoardingScreen1> createState() => _OnBoardingScreen1State();
// }

// class _OnBoardingScreen1State extends State<OnBoardingScreen1> {
//   double dW = 0.0;
//   double dH = 0.0;

//   double tS = 0.0;

//   Map language = {};

//   int screenNumber = 1;

//   TextTheme get textTheme => Theme.of(bContext).textTheme;

//   @override
//   Widget build(BuildContext context) {
//     dW = MediaQuery.of(context).size.width;
//     dH = MediaQuery.of(context).size.height;

//     tS = MediaQuery.of(context).textScaleFactor;
//     language = Provider.of<AuthProvider>(context).selectedLanguage;

//     return Scaffold(
//       backgroundColor: getScaffoldBgColor(context),
//       body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
//     );
//   }

//   screenBody() {
//     Widget currentWidget = OnBoardingWidget1();

//     switch (screenNumber) {
//       case 2:
//         currentWidget = OnBoardingWidget2();
//         break;
//       case 3:
//         currentWidget = OnBoardingWidget3();
//         break;
//     }
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Expanded(
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Container(
//                     margin: EdgeInsets.only(
//                       left: dW * 0.1,
//                       top: iOSCondition(dH) ? (dW * 0.06) : 0,
//                     ),
//                     child: Image.asset(
//                       'assets/images/onBoarding_background.png',
//                       height: dW * 1.05,
//                       width: dW,
//                     )),
//                 Container(
//                   margin: EdgeInsets.only(top: dW * 0.09, right: dW * 0.09),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           push(NamedRoute.mobileNumberScreen);
//                         },
//                         child: TextWidget(
//                           title: language['skip'],
//                           color: const Color(0xff1DA3CF),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             currentWidget,
//           ],
//         ),
//       ),
//       Container(
//         margin: EdgeInsets.only(
//             left: dW * 0.08, right: dW * 0.08, bottom: dW * 0.07),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             AssetSvgIcon('corousel$screenNumber'),
//             GestureDetector(
//               onTap: () {
//                 if (screenNumber < 3) {
//                   setState(() {
//                     screenNumber++;
//                   });
//                 } else {
//                   push(NamedRoute.mobileNumberScreen);
//                 }
//               },
//               child: Container(
//                 padding: EdgeInsets.all(dW * 0.04),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(
//                   Icons.arrow_forward_ios,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ]);
//   }
// }

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../colors.dart';
import '../../common_functions.dart';
import '../../common_widgets/asset_svg_icon.dart';
import '../../common_widgets/text_widget.dart';
import '../../navigation/navigators.dart';
import '../../navigation/routes.dart';
import '../providers/auth_provider.dart';

class OnBoardingScreen1 extends StatefulWidget {
  const OnBoardingScreen1({super.key});

  @override
  State<OnBoardingScreen1> createState() => _OnBoardingScreen1State();
}

class _OnBoardingScreen1State extends State<OnBoardingScreen1> {
  double dW = 0.0;
  double dH = 0.0;

  double tS = 0.0;

  Map language = {};

  TextTheme get textTheme => Theme.of(bContext).textTheme;

  int onboardingScreen = 1;

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
      backgroundColor: getScaffoldBgColor(context),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            if (onboardingScreen == 1)
              Image.asset(
                'assets/images/onboarding_one.png',
              ),
            if (onboardingScreen == 2)
              Image.asset(
                'assets/images/onboarding_two.png',
              ),
            if (onboardingScreen == 3)
              Image.asset(
                'assets/images/onboarding_three.png',
              ),
            Positioned(
              top: dW * 0.1,
              left: dW * 0.81,
              child: GestureDetector(
                onTap: () {
                  push(NamedRoute.mobileNumberScreen);
                },
                child: TextWidget(
                  title: language['skip'],
                  color: const Color(0xff1DA3CF),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
                bottom: dW * 0.4,
                left: dW * 0.1,
                child: AssetSvgIcon('corousel$onboardingScreen')),
            Positioned(
              bottom: dW * 0.35,
              left: dW * 0.7,
              child: GestureDetector(
                onTap: () {
                  if (onboardingScreen < 3) {
                    setState(() {
                      onboardingScreen++;
                    });
                  } else {
                    push(NamedRoute.mobileNumberScreen);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(dW * 0.04),
                  decoration: BoxDecoration(
                    color: const Color(0XFF292454),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
