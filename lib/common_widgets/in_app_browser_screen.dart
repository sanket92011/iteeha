// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'package:webview_flutter/webview_flutter.dart';

// import 'circular_loader.dart';
// import 'custom_dialog.dart';

// class InAppBrowserScreen extends StatefulWidget {
//   const InAppBrowserScreen({super.key});

//   @override
//   State<InAppBrowserScreen> createState() => _InAppBrowserScreenState();
// }

// class _InAppBrowserScreenState extends State<InAppBrowserScreen> {
//   bool isLoading = true;

//   bool iOSCondition(double dH) => Platform.isIOS && dH > 850;

//   WebViewController? controller;

//   String link = 'https://order.iteeha.coffee/';
//   setController() {
//     // controller = WebViewController()
//     //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     //   ..setBackgroundColor(const Color(0x00000000))
//     //   ..setNavigationDelegate(
//     //     NavigationDelegate(
//     //       onPageStarted: (String url) {
//     //         if (isLoading) setState(() => isLoading = false);
//     //       },
//     //       onNavigationRequest: (NavigationRequest request) {
//     //         return NavigationDecision.navigate;
//     //       },
//     //       onUrlChange: (change) {},
//     //     ),
//     //   )
//     //   ..loadRequest(Uri.parse(link));
//   }

//   Future<bool> goBack() async {
//     bool canGoBack = await controller!.canGoBack();
//     if (canGoBack) {
//       controller!.goBack();
//     } else {
//       closeApp();
//     }
//     return false;
//   }

//   closeApp() {
//     return showDialog(
//       context: context,
//       builder: ((context) => CustomDialog(
//             title: "Are you sure you want to exit the application?",
//             noText: 'No',
//             yesText: 'Yes',
//             subTitle: '',
//             noFunction: () {
//               Navigator.of(context).pop();
//             },
//             yesFunction: () async {
//               Navigator.of(context).pop();
//               SystemNavigator.pop();
//             },
//           )),
//     );
//   }

//   requestCameraPermission() async {
//     var status = await Permission.camera.request();
//     if (status.isDenied) {
//     } else if (status.isPermanentlyDenied) {
//       openAppSettings();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     setController();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     if (controller != null) controller!.clearCache();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dH = MediaQuery.of(context).size.height;
//     final dW = MediaQuery.of(context).size.width;

//     return WillPopScope(
//       onWillPop: () => goBack(),
//       child: Scaffold(
//         body:
//             // iOSCondition(dH) ? screenBody(dW) :
//             SafeArea(child: screenBody(dW)),
//       ),
//     );
//   }

//   screenBody(double dW) {
//     return Stack(
//       children: [
//         WebView(
//           initialUrl: link,
//           zoomEnabled: false,
//           javascriptMode: JavascriptMode.unrestricted,
//           onPageFinished: (String url) {
//             setState(() => isLoading = false);
//           },
//           onWebViewCreated: (WebViewController webViewController) {
//             controller = webViewController;
//           },
//         ),
//         if (isLoading) const CircularLoader()
//       ],
//     );
//   }
// }

// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../authModule/providers/auth_provider.dart';
import '../common_functions.dart';
import 'circular_loader.dart';
import 'custom_dialog.dart';

class InAppBrowserScreen extends StatefulWidget {
  const InAppBrowserScreen({super.key});

  @override
  State<InAppBrowserScreen> createState() => _InAppBrowserScreenState();
}

class _InAppBrowserScreenState extends State<InAppBrowserScreen> {
  bool isLoading = true;
  String link = '';
  WebViewController? controller;

  Future<void> fetchContent() async {
    final response = await Provider.of<AuthProvider>(context, listen: false)
        .getAppConfig(['Link']);

    if (response['success']) {
      setState(() {
        link = response['result'][0]['value'];
      });
      // Load the URL after getting it
      if (controller != null && link.isNotEmpty) {
        controller!.loadRequest(Uri.parse(link));
      }
    } else {
      showSnackbar(response['message']);
    }
  }

  Future<bool> goBack() async {
    bool canGoBack = await controller!.canGoBack();
    if (canGoBack) {
      controller!.goBack();
    } else {
      closeApp();
    }
    return false;
  }

  closeApp() {
    return showDialog(
      context: context,
      builder: ((context) => CustomDialog(
            title: "Are you sure you want to exit the application?",
            noText: 'No',
            yesText: 'Yes',
            subTitle: '',
            noFunction: () {
              Navigator.of(context).pop();
            },
            yesFunction: () async {
              Navigator.of(context).pop();
              SystemNavigator.pop();
            },
          )),
    );
  }

  requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status.isDenied) {
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void initializeController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => isLoading = false);
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  @override
  void initState() {
    super.initState();
    initializeController();
    fetchContent();
  }

  @override
  void dispose() {
    super.dispose();
    if (controller != null) controller!.clearCache();
  }

  @override
  Widget build(BuildContext context) {
    final dH = MediaQuery.of(context).size.height;
    final dW = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () => goBack(),
      child: Scaffold(
        body: SafeArea(
          child: isLoading ? const CircularLoader() : screenBody(dW),
        ),
      ),
    );
  }

  screenBody(double dW) {
    return Stack(
      children: [
        controller != null
            ? WebViewWidget(controller: controller!)
            : const Center(child: Text('Loading...')),
        if (isLoading) const CircularLoader()
      ],
    );
  }
}
