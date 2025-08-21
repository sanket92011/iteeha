// import 'package:flutter/material.dart';
// import 'package:iteeha_app/authModule/providers/auth_provider.dart';
// import 'package:iteeha_app/colors.dart';
// import 'package:iteeha_app/common_functions.dart';
// import 'package:iteeha_app/common_widgets/custom_button.dart';
// import 'package:iteeha_app/common_widgets/text_widget.dart';
// import 'package:iteeha_app/navigation/navigators.dart';
// import 'package:iteeha_app/navigation/routes.dart';
// import 'package:provider/provider.dart';

// // ignore: must_be_immutable
// class GuestLoginScreen extends StatefulWidget {
//   String title;
//   String image;

//   GuestLoginScreen({super.key, required this.title, required this.image});

//   @override
//   State<GuestLoginScreen> createState() => _GuestLoginScreenState();
// }

// class _GuestLoginScreenState extends State<GuestLoginScreen> {
//   //
//   Map language = {};
//   double dW = 0.0;
//   double dH = 0.0;

//   double tS = 0.0;
//   TextTheme get textTheme => Theme.of(context).textTheme;

//   @override
//   Widget build(BuildContext context) {
//     dW = MediaQuery.of(context).size.width;
//     dH = MediaQuery.of(context).size.height;

//     tS = MediaQuery.of(context).textScaleFactor;
//     language = Provider.of<AuthProvider>(context).selectedLanguage;
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           width: dW,
//           height: dH,
//           padding: EdgeInsets.symmetric(
//               horizontal: dW * horizontalPaddingFactor, vertical: dW * 0.04),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextWidget(
//                 title: language[widget.title],
//                 fontWeight: FontWeight.w500,
//                 fontSize: 18,
//               ),
//               SizedBox(height: dW * 0.2),
//               Container(
//                 width: dW,
//                 alignment: Alignment.center,
//                 height: dH * 0.4,
//                 child: Image.asset(
//                   widget.image,
//                   scale: 1.9,
//                 ),
//               ),
//               CustomButton(
//                 width: dW,
//                 height: dW * 0.13,
//                 buttonText: language['login'],
//                 buttonColor: buttonColor,
//                 radius: 8,
//                 onPressed: () => push(NamedRoute.mobileNumberScreen),
//                 borderColor: buttonColor,
//                 buttonTextSyle:
//                     Theme.of(context).textTheme.displayLarge!.copyWith(
//                           fontSize: tS * 16,
//                           color: white,
//                         ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_widgets/custom_button.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:iteeha_app/navigation/routes.dart';
import 'package:provider/provider.dart';

class GuestLoginScreen extends StatefulWidget {
  String title;
  String image;

  GuestLoginScreen({super.key, required this.title, required this.image});

  @override
  State<GuestLoginScreen> createState() => _GuestLoginScreenState();
}

class _GuestLoginScreenState extends State<GuestLoginScreen> {
  //
  Map language = {};
  double dW = 0.0;
  double dH = 0.0;

  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;

    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: dW * 0.15),
              width: dW,
              height: dH,
              child: Image.asset(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: dW * 0.04,
              left: dW * 0.04,
              child: TextWidget(
                title: language[widget.title],
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            Positioned(
              bottom: dW * 0.06,
              left: dW * 0.04,
              right: dW * 0.04,
              child: CustomButton(
                width: dW,
                height: dW * 0.13,
                buttonText: language['logIn'],
                buttonColor: buttonColor,
                radius: 8,
                onPressed: () => push(NamedRoute.mobileNumberScreen),
                borderColor: buttonColor,
                buttonTextSyle:
                    Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: tS * 16,
                          color: white,
                        ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
