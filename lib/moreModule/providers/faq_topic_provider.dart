import 'package:flutter/material.dart';
import 'package:iteeha_app/api.dart';
import 'package:iteeha_app/http_helper.dart';
import 'package:iteeha_app/moreModule/models/faq_topic_model.dart';

class FaqTopicProvider with ChangeNotifier {
  List<FaqTopic> _faqTopic = [];

  List<FaqTopic> get faqTopics => [..._faqTopic];

  fetchFaqTopics({
    required String accessToken,
  }) async {
    try {
      final url = '${webApi['domain']}${endPoint['fetchFaqTopics']}';
      final response = await RemoteServices.httpRequest(
          method: 'GET', url: url, accessToken: accessToken);

      if (response['success']) {
        List<FaqTopic> fetchedFaqTopics = [];
        fetchedFaqTopics = (response['result'] as List)
            .map((faqTopics) => FaqTopic.jsonToFaqTopic(faqTopics))
            .toList();
        _faqTopic = fetchedFaqTopics;
        notifyListeners();
      }

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'failedGetFaqTopics',
      };
    }
  }
}
