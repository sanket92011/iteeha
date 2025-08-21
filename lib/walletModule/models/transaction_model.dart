import 'package:iteeha_app/common_functions.dart';

class Transaction {
  // final String name;
  // final bool isDebited;
  // final String area;
  // final String date;
  // final String amount;
  // final String coinsEarned;

  // String? cafe;
  String ppOrderId;
  String id;
  String title;

  String transactionType;
  String transactionFor;
  String transactionStatus;
  DateTime createdAt;
  String offerApplied;
  num coinsEarned;
  num totalAmount;
  num walletAmount;
  num cashAmount;
  List<String> purchasedItems;
  bool isActive;
  bool isDeleted;

  Transaction(
      {
      // this.cafe,
      required this.ppOrderId,
      required this.id,
      required this.title,
      required this.transactionType,
      required this.transactionFor,
      required this.transactionStatus,
      required this.createdAt,
      required this.offerApplied,
      required this.coinsEarned,
      required this.totalAmount,
      required this.walletAmount,
      required this.cashAmount,
      required this.purchasedItems,
      required this.isActive,
      required this.isDeleted});

  static Transaction jsonToTransaction(Map transaction) {
    return Transaction(
      coinsEarned: transaction['coinsEarned'] ?? 0,

      // cafe: Cafe.jsonToCafe(transaction['cafe'] ?? {}),
      // cafe: transaction['cafe'] ?? '',
      ppOrderId: transaction['orderId'] ?? '',
      id: transaction['_id'],
      title: transaction['title'] ?? '',
      transactionType: transaction['transactionType'] ?? '',
      transactionFor: transaction['transactionFor'] ?? '',
      transactionStatus: transaction['transactionStatus'] ?? '',
      createdAt: getParseDate(transaction['createdAt'])!,
      offerApplied: transaction['offerApplied'] ?? '',
      totalAmount: transaction['totalAmount'] ?? 0,
      walletAmount: transaction['walletAmount'] ?? 0,
      cashAmount: transaction['cashAmount'] ?? 0,
      purchasedItems: List<String>.from(transaction['purchasedItems'] ?? []),
      isActive: transaction['isActive'] ?? false,
      isDeleted: transaction['isDeleted'] ?? false,
    );
  }
}
