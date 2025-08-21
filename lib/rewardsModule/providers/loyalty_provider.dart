import 'package:flutter/material.dart';
import 'package:iteeha_app/api.dart';
import 'package:iteeha_app/rewardsModule/models/loyalty_level_model.dart';
import 'package:iteeha_app/http_helper.dart';

class LoyaltyProvider with ChangeNotifier {
  Map loyaltyTransactionCounts = {
    'loyalty1': 0,
    'loyalty2': 0,
    'loyalty3': 0,
  };

  List<LoyaltyLevel> _loyaltyLevels = [];

  List<LoyaltyLevel> get loyaltyLevels => [..._loyaltyLevels];
  List<String> loyaltyProgramNotes = [
    'To maintain each level you need to make the specified transactions within the mentioned days.',
    'If you don’t complete the streak, your level will automatically reset.'
  ];

  fetchLoyaltyLevels({
    required String accessToken,
  }) async {
    try {
      final url = '${webApi['domain']}${endPoint['fetchLoyaltyLevels']}';
      final response = await RemoteServices.httpRequest(
          method: 'GET', url: url, accessToken: accessToken);

      if (response['success']) {
        List<LoyaltyLevel> fetchedloyaltyLevels = [];
        fetchedloyaltyLevels = (response['result'] as List)
            .map((loyaltyLevels) =>
                LoyaltyLevel.jsonToLoyaltyLevel(loyaltyLevels))
            .toList();
        _loyaltyLevels = fetchedloyaltyLevels;
        notifyListeners();
      }

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'failedGetLoyaltyLevels',
      };
    }
  }

  fetchTransactionCountsForLoyalty({required String accessToken}) async {
    try {
      final url =
          '${webApi['domain']}${endPoint['fetchTransactionCountsForLoyalty']}';
      final response = await RemoteServices.httpRequest(
          method: 'GET', url: url, accessToken: accessToken);

      if (response['success']) {
        loyaltyTransactionCounts = response['result'];
        notifyListeners();
      }

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'failedToGetTransactionCount',
      };
    }
  }

  LoyaltyLevel currentLoyaltyLevel() {
    LoyaltyLevel? toReturn;

    for (var element in _loyaltyLevels.reversed.toList()) {
      if (loyaltyTransactionCounts['loyalty${element.level.toString()}'] >=
          element.transactionCount) {
        toReturn = element;
        break;
      }
    }

    return toReturn ?? _loyaltyLevels[0];
  }

  LoyaltyLevel? nextLoyaltyLevel(cli) {
    if (_loyaltyLevels.length > cli) {
      return _loyaltyLevels[cli];
    } else {
      return null;
    }
  }
}
