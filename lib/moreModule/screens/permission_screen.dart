import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/moreModule/widgets/permission_toggle_button.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => PermissionScreenState();
}

class PermissionScreenState extends State<PermissionScreen> {
  //
  Map language = {};
  double dW = 0.0;
  double dH = 0.0;

  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;

  int notifications = 03;

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    final permissionProvider = Provider.of<AuthProvider>(context).user;
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
            size: 25,
          ),
        ),
        titleSpacing: dH * 0.01,
        title: TextWidget(
          title: language['permissions'],
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: dW * horizontalPaddingFactor),
        child: Column(
          children: [
            SizedBox(
              height: dW * 0.08,
            ),
            PermissionToggleButtonWidget(
              text: 'notifications',
              isActive: permissionProvider.isNotificationAllowed,
            ),
            SizedBox(
              height: dW * 0.04,
            ),
            PermissionToggleButtonWidget(
              text: 'location',
              isActive: permissionProvider.isLocationAllowed,
            ),
          ],
        ),
      ),
    );
  }
}
