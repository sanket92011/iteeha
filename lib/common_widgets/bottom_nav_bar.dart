// ignore_for_file: unused_import, depend_on_referenced_packages

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:iteeha_app/authModule/model/user_model.dart';
import 'package:iteeha_app/homeModule/screens/home_screen.dart';
import 'package:iteeha_app/moreModule/screens/more_screen.dart';
import 'package:iteeha_app/rewardsModule/screens/reward_screen.dart';
import 'package:iteeha_app/walletModule/screens/guest_login_screen.dart';
import 'package:iteeha_app/walletModule/screens/wallet_screen.dart';

import '../../navigation/arguments.dart';
import '../../main.dart';
import '../authModule/providers/auth_provider.dart';
import '../colors.dart';
import '../common_functions.dart';
import '../localNotificationService.dart';
import '../navigation/navigators.dart';
import '../navigation/routes.dart';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'asset_svg_icon.dart';
import 'gradient_widget.dart';
import 'in_app_browser_screen.dart';

class BottomNavBar extends StatefulWidget {
  final BottomNavArgumnets args;
  const BottomNavBar({super.key, required this.args});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  final LocalStorage storage = LocalStorage('household');

  int _currentIndex = 0;
  bool isLoading = false;

  double dW = 0;
  double dH = 0;
  double tS = 0;
  Map language = {};

  String? notificationId;
  final unselectedColor = const Color(0xFF969698);
  // User user;

  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  initFcm() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      LocalNotificationService.initialize(
          navigatorKey.currentContext!, handleNotificationClick);

      FirebaseMessaging.onBackgroundMessage(
          (RemoteMessage message) => handleNotificationClick(message));

      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          message.data['notificationId'] = message.messageId;
          handleNotificationClick(message.data);
        }
      });

      FirebaseMessaging.onMessage.listen((message) async {
        if (message.notification != null) {
          message.data['notificationId'] = message.messageId;

          LocalNotificationService.display(message);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        if (message.notification != null) {
          message.data['notificationId'] = message.messageId;
          handleNotificationClick(message.data);
        }
      });
      awaitStoreReady();
    }
  }

  awaitStoreReady() async {
    await storage.ready;
  }

  handleNotificationClick(data) async {
    final notificationIdString = storage.getItem('fcmNotificationIds');
    if (notificationIdString != null) {
      notificationId = json.decode(notificationIdString);
      if (notificationId == data['notificationId']) {
        return;
      }
    }
    storage.setItem('fcmNotificationIds', json.encode(data['notificationId']));

    switch (data['type']) {
      // case 'Signup':
      //   pushAndRemoveUntil(NamedRoute.bottomNavBarScreen,
      //       arguments: BottomNavArgumnets(index: 0));
      //   break;
    }
  }

  Future<bool> _willPopCallback() async {
    // customDialogBox(
    //   okBtnPress: () {
    //     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    //     return true;
    //   },
    //   cancelBtnPress: () {
    //     Navigator.of(context).pop();
    //     return true;
    //   },
    //   context: context,
    //   title: language['alert'],
    //   titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    //   content: language['wantToExit'],
    //   okBtnText: language['yes'],
    //   cancelBtnText: language['no'],
    //   cancelBtnStyle: const TextStyle(color: Colors.blue),
    // );

    if (_currentIndex == 0) {
      return true;
    } else {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    }
  }

  List<Widget> get _children => [
        HomeScreen(
          onIndexChanged: onTapped,
        ),
        Provider.of<AuthProvider>(context).user.isGuest
            ? GuestLoginScreen(
                title: 'wallet',
                image: 'assets/images/login_wallet_new.png',
              )
            : const WalletScreen(),
        const InAppBrowserScreen(),
        Provider.of<AuthProvider>(context).user.isGuest
            ? GuestLoginScreen(
                title: 'rewards',
                image: 'assets/images/login_rewards_new.png',
              )
            : const RewardScreen(),
        Provider.of<AuthProvider>(context).user.isGuest
            ? GuestLoginScreen(
                title: 'more',
                image: 'assets/images/login_more_new.png',
              )
            : MoreScreen(onIndexChanged: onTapped),
      ];

  @override
  void dispose() {
    super.dispose();
  }

  Widget navbarItemContent({
    required String label,
    required String svg,
    required String colouredsvg,
    required bool isSelected,
  }) =>
      Container(
        padding: iOSCondition(dH)
            ? EdgeInsets.only(top: dW * 0.02)
            : EdgeInsets.symmetric(vertical: dW * 0.048),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isSelected
                    ? AssetSvgIcon(
                        colouredsvg,
                        height: 26,
                      )
                    : AssetSvgIcon(svg, height: 26),
                SizedBox(width: dW * 0.025),
                isSelected
                    ? Text(
                        label,
                        style: TextStyle(
                            color: const Color(0xff272559),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: tS * 10),
                      )
                    : Text(
                        label,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: tS * 10,
                            color: lightGray),
                      ),
              ],
            ),
            // if (isSelected)
            //   Positioned(
            //     left: 0,
            //     right: 0,
            //     top: -18.5,
            //     child: Container(
            //       height: 4,
            //       decoration: BoxDecoration(
            //           gradient: linearGradient,
            //           borderRadius: BorderRadius.circular(25)),
            //     ),
            //   ),
          ],
        ),
      );

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.args.index;

    initFcm();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    dH = MediaQuery.of(context).size.height;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _children[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -1),
                  blurRadius: 2,
                  spreadRadius: 2)
            ],
            border: Border.all(
                width: 0, style: BorderStyle.none, color: Colors.transparent),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              BottomNavigationBar(
                elevation: 10,
                currentIndex: _currentIndex,
                onTap: onTapped,
                selectedFontSize: 0,
                unselectedFontSize: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Theme.of(context).primaryColor,
                items: [
                  BottomNavigationBarItem(
                    icon: navbarItemContent(
                      label: language['home'],
                      colouredsvg: 'coloured_home_new',
                      svg: 'home_new',
                      isSelected: _currentIndex == 0,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: navbarItemContent(
                      label: language['wallet'],
                      colouredsvg: 'coloured_wallet_new',
                      svg: 'wallet_new',
                      isSelected: _currentIndex == 1,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: navbarItemContent(
                      label: language['orderOnline'],
                      colouredsvg: 'iteeha_coloured_new',
                      svg: 'iteeha_new',
                      isSelected: _currentIndex == 2,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: navbarItemContent(
                      label: language['rewards'],
                      colouredsvg: 'coloured_rewards_new',
                      svg: 'reward_new',
                      isSelected: _currentIndex == 3,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: navbarItemContent(
                      label: language['more'],
                      colouredsvg: 'coloured_more_new',
                      svg: 'more_new',
                      isSelected: _currentIndex == 4,
                    ),
                    label: '',
                  ),
                ],
              ),
              // Positioned(
              //   left: 0,
              //   right: 0,
              //   top: 0,
              //   child: Center(
              //     child: Container(
              //       margin: const EdgeInsets.only(top: 13),
              //       width: 1.5,
              //       height: dH * 0.05,
              //       decoration: BoxDecoration(
              //         color: dividerColor,
              //         borderRadius: BorderRadius.circular(25),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
