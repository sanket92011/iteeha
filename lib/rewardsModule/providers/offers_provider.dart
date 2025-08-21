import 'package:flutter/material.dart';
import 'package:iteeha_app/api.dart';
import 'package:iteeha_app/rewardsModule/models/offer_model.dart';
import 'package:iteeha_app/http_helper.dart';

class OffersProvider with ChangeNotifier {
  List<Offer> _offers = [];

  List<Offer> get offers => [..._offers];

  fetchOffers({
    required String accessToken,
  }) async {
    try {
      final url = '${webApi['domain']}${endPoint['fetchOffers']}';
      final response = await RemoteServices.httpRequest(
          method: 'GET', url: url, accessToken: accessToken);

      if (response['success']) {
        List<Offer> fetchedOffers = [];
        fetchedOffers = (response['result'] as List)
            .map((offers) => Offer.jsonToOffer(offers))
            .toList();
        _offers = fetchedOffers;
        notifyListeners();
      }

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'failedGetOffers',
      };
    }
  }

  List<Offer> get alignedOffers {
    List<Offer> alignedOffers = [];
    List<Offer> referOffers = [];

    for (var offer in _offers) {
      if (offer.type == 'Normal') {
        alignedOffers.add(offer);
      }

      if (offer.type == 'Refer') {
        referOffers.add(offer);
      }
    }

    alignedOffers.addAll(referOffers);

    return alignedOffers;
  }
}
