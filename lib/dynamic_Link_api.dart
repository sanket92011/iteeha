// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

import 'main.dart';

// class DynamicLinksApi {
final dynamicLink = FirebaseDynamicLinks.instance;

createAppLink(String userId) async {
  final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
    uriPrefix: 'https://iteeha.page.link/',
    link: Uri.parse('https://iteeha.page.link/refer?userId=$userId'),
    androidParameters: const AndroidParameters(packageName: 'com.iteeha.app'),
    iosParameters: const IOSParameters(bundleId: 'com.iteeha.app'),
    socialMetaTagParameters: const SocialMetaTagParameters(
      title: 'Iteeha',
      description: 'Join the app now!!',
    ),
  );

  final ShortDynamicLink shortLink =
      await FirebaseDynamicLinks.instance.buildShortLink(
    dynamicLinkParameters,
    shortLinkType: ShortDynamicLinkType.unguessable,
  );

  final RenderBox? box =
      navigatorKey.currentContext!.findRenderObject() as RenderBox?;

  await Share.share(
    '${shortLink.shortUrl}',
    subject: '',
    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
  );
}

createShareCafeLink(String cafeId) async {
  final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
    uriPrefix: 'https://iteeha.page.link/',
    link: Uri.parse('https://iteeha.page.link/cafe?cafeId=$cafeId'),
    androidParameters: const AndroidParameters(packageName: 'com.iteeha.app'),
    iosParameters: const IOSParameters(bundleId: 'com.iteeha.app'),
    socialMetaTagParameters: const SocialMetaTagParameters(
      title: 'Iteeha Cafe',
      description: 'Click to checkout this cafe!',
    ),
  );

  final ShortDynamicLink shortLink =
      await FirebaseDynamicLinks.instance.buildShortLink(
    dynamicLinkParameters,
    shortLinkType: ShortDynamicLinkType.unguessable,
  );

  final RenderBox? box =
      navigatorKey.currentContext!.findRenderObject() as RenderBox?;

  await Share.share(
    '${shortLink.shortUrl}',
    subject: '',
    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
  );
}
