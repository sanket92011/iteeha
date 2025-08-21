// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iteeha_app/homeModule/providers/cafe_provider.dart';
import 'package:iteeha_app/homeModule/providers/notification_provider.dart';
import 'package:iteeha_app/moreModule/providers/faq_provider.dart';
import 'package:iteeha_app/moreModule/providers/faq_topic_provider.dart';
import 'package:iteeha_app/navigation/arguments.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:iteeha_app/navigation/routes.dart';
import 'package:iteeha_app/rewardsModule/providers/loyalty_provider.dart';
import 'package:iteeha_app/rewardsModule/providers/offers_provider.dart';
import 'package:iteeha_app/walletModule/providers/transaction_provider.dart';

import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'authModule/providers/auth_provider.dart';
import 'authModule/screens/splash_screen.dart';
import 'homeModule/providers/banner_provider.dart';
import 'navigation/navigation_service.dart';
import 'theme_manager.dart';

final LocalStorage storage = LocalStorage('re_household');

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> backgroundHandler(RemoteMessage message) async {}

awaitStorageReady() async {
  await storage.ready;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (Platform.isAndroid) {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  // }

  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    if (double.parse(androidInfo.version.release.split('')[0]) <= 8.0) {
      HttpOverrides.global = MyHttpOverrides();
    }
  }

  return runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  myInit() async {
    await initDynamicLinks();
  }

  processDynamicLink(PendingDynamicLinkData dynamicLink) async {
    final Uri deepLink = dynamicLink.link;
    final queryParams = deepLink.queryParameters;

    // refer a friend
    var userId = queryParams['userId'];
    var cafeId = queryParams['cafeId'];
    if (userId != null) {
      // navigatorKey.currentState!.push(MaterialPageRoute(
      //     builder: (context) => ViewPostScreen(postId: postId)));
    }
    if (cafeId != null) {
      push(NamedRoute.loadingScreen,
          arguments: LoadingScreenArguments(featureId: cafeId, type: 'cafe'));
    }
  }

  initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      processDynamicLink(dynamicLinkData);
    }).onError((error) {
      debugPrint('onLink error');
      debugPrint(error.message);
    });

    final PendingDynamicLinkData? dynamicLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (dynamicLink != null) {
      processDynamicLink(dynamicLink);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    myInit();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LoyaltyProvider()),
        ChangeNotifierProvider(create: (_) => CafeProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => OffersProvider()),
        ChangeNotifierProvider(create: (_) => FaqProvider()),
        ChangeNotifierProvider(create: (_) => FaqTopicProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => BannerProvider()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
            navigatorKey: navigatorKey,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
            title: 'Recyclink',
            theme: theme.getTheme(),
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: generateRoute,
            routes: {
              '/': (BuildContext context) => const SplashScreen(),
              // '/': (BuildContext context) =>
              //     HomeScreen(args: HomeScreenArguments()),
            }),
      ),
    );
  }
}
