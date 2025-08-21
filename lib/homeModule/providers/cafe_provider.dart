import 'package:flutter/material.dart';
import 'package:iteeha_app/api.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/homeModule/models/cafe_model.dart';
import 'package:iteeha_app/http_helper.dart';

class CafeProvider with ChangeNotifier {
  List<Cafe> _cafes = [];

  List<Cafe> get cafes => [..._cafes];

  List<Cafe> _likedCafes = [];

  List<Cafe> get likedCafes => [..._likedCafes];
  Cafe? selectedCafe;

  selectCafe(Cafe cafe) {
    selectedCafe = cafe;
    notifyListeners();
  }

  fetchCafe({
    required String accessToken,
    required String query,
  }) async {
    try {
      final url =
          '${webApi['domain']}${endPoint['fetchCafe']}?guest=${isGuest.toString()}&$query';

      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: url,
        accessToken: accessToken,
      );

      if (response['success']) {
        if (query.contains('coordinates') &&
            !query.contains('fetchNearby') &&
            (response['result'] as List).isNotEmpty) {
          selectedCafe = Cafe.jsonToCafe(response['result'][0]);
        } else {
          List<Cafe> fetchedCafes = (response['result'] as List)
              .map((cafe) => Cafe.jsonToCafe(cafe))
              .toList();

          if (query.contains('fetchLiked')) {
            _likedCafes = fetchedCafes;
          } else {
            _cafes = fetchedCafes;
          }
        }

        notifyListeners();
      }

      return response;
    } catch (error) {
      return {
        'success': false,
        'message': 'failedGetCafe',
      };
    }
  }

  likeUnlike({required Map body, required String accessToken}) async {
    try {
      final url = '${webApi['domain']}${endPoint['likeUnlike']}';
      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: body,
        accessToken: accessToken,
      );
      if (response['success']) {
        if (body['like'] == false) {
          int i =
              _likedCafes.indexWhere((element) => element.id == body['cafe']);
          if (i != -1) {
            _likedCafes.removeAt(i);
          }
          int j = _cafes.indexWhere((element) => element.id == body['cafe']);
          if (j != -1) {
            _cafes[j].isLiked = body['like'];
          }
        }
      }
      notifyListeners();
      return response;
    } catch (e) {
      return {
        'success': false,
      };
    }
  }

  fetchCafeById(
      {required String accessToken,
      required String query,
      required String cafeType}) async {
    try {
      final url = '${webApi['domain']}${endPoint['fetchSingleCafeById']}$query';
      final response = await RemoteServices.httpRequest(
          method: 'GET', url: url, accessToken: accessToken);

      if (response['success']) {
        if (cafeType == 'cafe') {
          Cafe fetchedCafe = Cafe.jsonToCafe(response['result']);
          response['cafe'] = fetchedCafe;
        }
        notifyListeners();
      }
      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to get cafe',
      };
    }
  }
}
