import 'package:flutter/material.dart';
import 'package:iteeha_app/api.dart';
import 'package:iteeha_app/moreModule/models/faq_model.dart';
import 'package:iteeha_app/http_helper.dart';

class FaqProvider with ChangeNotifier {
  List<Faq> _faq = [];

  List<Faq> get faqs => [..._faq];

  fetchFaqs({required String accessToken, required String query}) async {
    try {
      final url = '${webApi['domain']}${endPoint['fetchFaqs']}$query';
      final response = await RemoteServices.httpRequest(
          method: 'GET', url: url, accessToken: accessToken);

      if (response['success']) {
        List<Faq> fetchedFaqs = [];
        fetchedFaqs = (response['result'] as List)
            .map((faqs) => Faq.jsonToFaq(faqs))
            .toList();

        // List<Faq> filteredFaqs =
        //     fetchedFaqs.where((faq) => faq.topic == objectId).toList();

        _faq = fetchedFaqs;
        notifyListeners();
      }

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'failedGetFaqs',
      };
    }
  }
}
