import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/homeModule/providers/notification_provider.dart';
import 'package:iteeha_app/homeModule/widgets/notification_widget.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  //
  Map language = {};
  double dW = 0.0;
  double dH = 0.0;
  bool isClearButtonVisible = true;

  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;
  late Notification notifications;

  @override
  void initState() {
    super.initState();
    Provider.of<NotificationsProvider>(context, listen: false)
        .fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;

    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language =
        Provider.of<AuthProvider>(context, listen: false).selectedLanguage;
    final notifications = Provider.of<NotificationsProvider>(context);

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
          title: language['notifications'],
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      body: Column(
        children: [
          // SizedBox(height: dW * 0.08),
          // Padding(
          //   padding:
          //       EdgeInsets.symmetric(horizontal: dW * horizontalPaddingFactor),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       TextWidget(
          //         title:
          //             '${notifications.newNotifications} ${language['newNotifications']}',
          //         fontSize: 16,
          //         color: const Color(0xff1D1E22),
          //         fontWeight: FontWeight.w600,
          //       ),
          //       Opacity(
          //         opacity: isClearButtonVisible ? 1.0 : 0.0,
          //         child: Visibility(
          //           visible: isClearButtonVisible,
          //           child: AnimatedSizeAndFade(
          //             fadeDuration: const Duration(seconds: 3),
          //             sizeDuration: const Duration(seconds: 2),
          //             child: GestureDetector(
          //               onTap: () {
          //                 setState(() {
          //                   isClearButtonVisible = false;
          //                 });
          //                 final clearNotifications =
          //                     Provider.of<NotificationsProvider>(context,
          //                             listen: false)
          //                         .clearNotifications();
          //                 clearNotifications;
          //               },
          //               child: TextWidget(
          //                 title: language['clear'],
          //                 color: const Color(0xffAAABB5),
          //                 fontWeight: FontWeight.w600,
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: dW * 0.08,
          // ),
          if (notifications.notifications.isNotEmpty)
            ...notifications.notifications.map(
              (e) => Column(
                children: [
                  NotificationWidget(title: e.title, subTitle: e.subTitle),
                  Container(
                    margin: EdgeInsets.only(top: dW * 0.03, bottom: dW * 0.03),
                    child: const Divider(
                      thickness: 1,
                      color: Color(0xffE8E8E8),
                    ),
                  ),
                ],
              ),
            ),
          if (notifications.notifications.isEmpty)
            Expanded(
              child: SizedBox(
                  width: dW,
                  height: dH,
                  child: Image.asset(
                    'assets/images/empty_notification_bg.png',
                    fit: BoxFit.cover,
                  )),
            )
        ],
      ),
    );
  }
}
