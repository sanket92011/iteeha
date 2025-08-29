import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  /// 🔑 Helper: Launch with specific package (if available)
  Future<void> _launchWithPackage(String upiUrl, String packageName, String? fallbackUrl) async {
    final uri = Uri.parse(upiUrl);

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webViewConfiguration: const WebViewConfiguration(
        headers: <String, String>{},
      ),
      webOnlyWindowName: packageName, // Helps Android pick specific package
    );

    if (!launched && fallbackUrl != null) {
      // If app not installed, open fallback (Play Store)
      await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
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
          onNavigationRequest: (NavigationRequest request) async {
            final url = request.url;

            // Handle direct UPI links
            if (url.startsWith("upi:")) {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
              return NavigationDecision.prevent;
            }

            // Handle intent:// links
            if (url.startsWith("intent://")) {
              try {
                // Extract package name
                final packageRegex = RegExp(r'package=([\w\.]+);');
                final match = packageRegex.firstMatch(url);
                final packageName = match != null ? match.group(1) : null;

                // Extract fallback
                String? fallbackUrl;
                if (url.contains("browser_fallback_url=")) {
                  fallbackUrl = Uri.decodeComponent(
                    url.split("browser_fallback_url=").last.split(";").first,
                  );
                }

                // Convert intent:// to upi ://
                final upiUrl = url.replaceFirst("intent://", "upi://");

                if (packageName != null) {
                  await _launchWithPackage(upiUrl, packageName, fallbackUrl);
                } else {
                  // No package given, just try normal UPI launch
                  final uri = Uri.parse(upiUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else if (fallbackUrl != null) {
                    await launchUrl(Uri.parse(fallbackUrl),
                        mode: LaunchMode.externalApplication);
                  }
                }
              } catch (e) {
                debugPrint("Error handling intent:// $e");
              }
              return NavigationDecision.prevent;
            }

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
    controller?.clearCache();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => goBack(),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              controller != null
                  ? WebViewWidget(controller: controller!)
                  : const Center(child: Text('Loading...')),
              if (isLoading) const CircularLoader(),
            ],
          ),
        ),
      ),
    );
  }
}
