class LoyaltyLevel {
  final String name;

  num level;
  String badge;
  num transactionCount;
  num days;
  num freeBeveragePurchaseCount;
  num foodDiscount;
  num loyaltyPoints;
  bool birthdayBeverage;
  bool isActive;
  bool isDeleted;

  LoyaltyLevel({
    required this.name,
    required this.level,
    required this.badge,
    required this.transactionCount,
    required this.days,
    required this.freeBeveragePurchaseCount,
    required this.foodDiscount,
    required this.loyaltyPoints,
    required this.birthdayBeverage,
    required this.isActive,
    required this.isDeleted,
  });

  static LoyaltyLevel jsonToLoyaltyLevel(Map loyalty) => LoyaltyLevel(
        name: loyalty['name'] ?? '',
        level: loyalty['level'] ?? 0,
        badge: loyalty['badge'] ?? '',
        transactionCount: loyalty['transactionCount'] ?? 0,
        days: loyalty['days'] ?? 0,
        freeBeveragePurchaseCount: loyalty['freeBeveragePurchaseCount'] ?? 0,
        foodDiscount: loyalty['foodDiscount'] ?? 0,
        loyaltyPoints: loyalty['loyaltyPoints'] ?? 0,
        birthdayBeverage: loyalty['birthdayBeverage'] ?? false,
        isActive: loyalty['isActive'] ?? false,
        isDeleted: loyalty['isDeleted'] ?? false,
      );
}
