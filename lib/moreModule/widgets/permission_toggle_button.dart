import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/circular_loader.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PermissionToggleButtonWidget extends StatefulWidget {
  final String text;
  final bool isActive;

  const PermissionToggleButtonWidget(
      {super.key, required this.text, required this.isActive});

  @override
  State<PermissionToggleButtonWidget> createState() =>
      _PermissionToggleButtonWidgetState();
}

class _PermissionToggleButtonWidgetState
    extends State<PermissionToggleButtonWidget> {
  double dW = 0.0;
  double dH = 0.0;
  Map language = {};
  bool isLoading = false;
  double tS = 0.0;

  editPermissions({
    required bool newValue,
  }) async {
    final permissionProvider =
        Provider.of<AuthProvider>(context, listen: false).user;
    setState(() => isLoading = true);

    final Map<String, String> body = {
      if (widget.text == 'location')
        "isLocationAllowed": permissionProvider.isLocationAllowed.toString(),
      if (widget.text == 'notifications')
        "isNotificationAllowed":
            permissionProvider.isNotificationAllowed.toString(),
    };

    final Map<String, String> files = {};

    if (permissionProvider.isLocationAllowed) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.fetchMyLocation();
    }

    final response =
        await Provider.of<AuthProvider>(context, listen: false).editProfile(
      body: body,
      files: files,
    );
    setState(() => isLoading = false);

    if (!response['success']) {
      // ignore: use_build_context_synchronously
      Provider.of<AuthProvider>(context, listen: false)
          .updatePermission(permissionType: widget.text, newValue: !newValue);
      showSnackbar(language['failedToUpdate']);
    }
    // else {
    //   pop();
    // }
  }

  void onChangedCallback({
    required String permissionType,
    required bool newValue,
  }) async {
    Provider.of<AuthProvider>(context, listen: false)
        .updatePermission(permissionType: widget.text, newValue: newValue);

    await editPermissions(newValue: newValue);
  }

  @override
  Widget build(BuildContext context) {
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: dW * 0.04, vertical: dW * 0.035),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffBFC0C8), width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextWidget(
            title: language[widget.text],
            fontWeight: FontWeight.w600,
            color: const Color(0xff84858E),
          ),
          Stack(
            children: [
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  activeColor: const Color(0xff272559),
                  value: widget.isActive,

                  // inactiveTrackColor: const Color(0xffBFC0C8),
                  // activeTrackColor: const Color(0xff272559),
                  // value: widget.text == 'location'
                  //     ? userProvider.user.isLocationAllowed
                  //     : userProvider.user.isNotificationAllowed,

                  onChanged: (bool newValue) async {
                    if (widget.text == 'notifications' && !widget.isActive) {
                      final statuses =
                          await [Permission.notification].request();

                      if (statuses.containsValue(
                              PermissionStatus.permanentlyDenied) ||
                          statuses.containsValue(PermissionStatus.denied)) {
                        AppSettings.openAppSettings(
                            type: AppSettingsType.notification);

                        return;
                      }
                    }

                    if (widget.text == 'location' && !widget.isActive) {
                      final statuses = await [
                        Permission.location,
                        if (Platform.isIOS) Permission.locationAlways
                      ].request();

                      if (statuses.containsValue(
                              PermissionStatus.permanentlyDenied) ||
                          statuses.containsValue(PermissionStatus.denied)) {
                        AppSettings.openAppSettings(
                            type: AppSettingsType.location);
                        return;
                      }
                    }
                    if (!isLoading) {
                      onChangedCallback(
                          permissionType: widget.text, newValue: newValue);
                    }
                  },
                ),
              ),
              if (isLoading)
                Positioned(
                  right: 16.5,
                  top: 14,
                  child: SizedBox(
                    height: 10,
                    width: 10,
                    child: circularForButton(9, color: Colors.blue, sW: 2),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
