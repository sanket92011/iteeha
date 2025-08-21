import 'package:flutter/material.dart';
import 'package:iteeha_app/api.dart';
import 'package:iteeha_app/walletModule/models/transaction_model.dart';
import 'package:iteeha_app/http_helper.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  fetchTransactions({
    required String accessToken,
  }) async {
    try {
      final url = '${webApi['domain']}${endPoint['fetchTransactions']}';
      final response = await RemoteServices.httpRequest(
          method: 'GET', url: url, accessToken: accessToken);

      if (response['success']) {
        List<Transaction> fetchedTransactions = [];
        fetchedTransactions = (response['result'] as List)
            .map((transactions) => Transaction.jsonToTransaction(transactions))
            .toList();
        _transactions = fetchedTransactions;
        notifyListeners();
      }

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'failedGetTransactions',
      };
    }
  }

  walletRecharge({required String accessToken, required Map body}) async {
    try {
      final url = '${webApi['domain']}${endPoint['walletRecharge']}';

      final response = await RemoteServices.httpRequest(
          method: 'POST', url: url, accessToken: accessToken, body: body);

      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'failedGetTransactions',
      };
    }
  }
}
