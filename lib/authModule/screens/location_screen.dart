// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/model/user_model.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/asset_svg_icon.dart';
import 'package:iteeha_app/common_widgets/custom_button.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/homeModule/providers/cafe_provider.dart';
import 'package:iteeha_app/navigation/arguments.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:iteeha_app/navigation/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Map language = {};
  double dW = 0.0;
  double dH = 0.0;

  double tS = 0.0;
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;
  bool validatePhone = false;
  User? user;

  checkAndGetLocationPermission() async {
    setState(() => isLoading = true);
    try {
      await handlePermissionsFunction();

      if (await Permission.location.isGranted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        await authProvider.fetchMyLocation();

        final coord = authProvider.user.coordinates;
        if (coord != null) {
          final User user =
              Provider.of<AuthProvider>(context, listen: false).user;
          String coordString = [coord.longitude, coord.latitude].toString();
          final response =
              await Provider.of<CafeProvider>(context, listen: false).fetchCafe(
                  accessToken: user.accessToken,
                  query: 'coordinates=$coordString');

          if (response['success']) {
            if (!user.isLocationAllowed) {
              if (!user.isGuest) {
                await Provider.of<AuthProvider>(context, listen: false)
                    .editProfile(
                        body: {'isLocationAllowed': 'true'}, files: {});
              } else {
                user.isLocationAllowed = true;
              }
            }
            pushAndRemoveUntil(NamedRoute.bottomNavBarScreen,
                arguments: BottomNavArgumnets());
          } else {
            push(NamedRoute.searchCafeScreen);
          }
        } else {
          push(NamedRoute.searchCafeScreen);
        }
      } else {
        showSnackbar('Please enable location access');
        return;
      }
      //
    } catch (e) {
      showSnackbar('Please enable location access');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<AuthProvider>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;

    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: dW,
            height: dH,
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Image.asset('assets/images/location_graphic_new.png'),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: dW * horizontalPaddingFactor, vertical: dW * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: dH * 0.065),
                  padding: EdgeInsets.only(right: dW * 0.04),
                  child: TextWidget(
                    title: language['locationAccessPermissionIsRequired'],
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Column(
                  children: [
                    CustomButton(
                      isLoading: isLoading,
                      width: dW,
                      height: dW * 0.13,
                      buttonText: language['allowLocationAccess'],
                      buttonColor: buttonColor,
                      radius: 8,
                      onPressed:
                          isLoading ? () {} : checkAndGetLocationPermission,
                    ),
                    SizedBox(
                      height: dW * 0.04,
                    ),
                    // CustomButton(
                    //   width: dW,
                    //   height: dW * 0.13,
                    //   buttonText: language['enterLocationManually'],
                    //   buttonColor: Colors.transparent.withOpacity(0.0),
                    //   radius: 8,
                    //   onPressed: () => push(NamedRoute.searchCafeScreen),
                    //   borderColor: buttonColor,
                    //   buttonTextSyle:
                    //       Theme.of(context).textTheme.displayLarge!.copyWith(
                    //             fontSize: tS * 16,
                    //             color: buttonColor,
                    //           ),
                    // ),
                    GestureDetector(
                      onTap: () {
                        push(NamedRoute.searchCafeScreen);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: dW,
                        height: dW * 0.13,
                        decoration: BoxDecoration(
                            border: Border.all(color: buttonColor),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          language['enterLocationManually'],
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                fontSize: tS * 16,
                                color: buttonColor,
                              ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
