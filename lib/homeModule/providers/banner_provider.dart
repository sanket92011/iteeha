// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../../api.dart';
import '../../http_helper.dart';
import '../models/banner_model.dart';

class BannerProvider with ChangeNotifier {
  List<BannerModel> _banners = [];
  List<BannerModel> get banners => [..._banners];

  fetchAllBanner({
    required String accessToken,
  }) async {
    try {
      final url = '${webApi['domain']}${endPoint['fetchAllBanner']}';
      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
      );

      if (response['success']) {
        List<BannerModel> fetchedBanners = [];

        response['result'].forEach((e) {
          fetchedBanners.add(BannerModel.jsonToBanner(e));
        });
        _banners = fetchedBanners;
        notifyListeners();
      }
      return response;
    } catch (e) {
      print(e);
      return {
        'success': false,
        'message': 'Failed to get banners',
      };
    }
  }
}
