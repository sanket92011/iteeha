import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/homeModule/models/cafe_model.dart';

class Offer {
  String id;
  String name;
  String type;
  String image;
  String couponCode;
  String description;
  List terms;
  DateTime? endDate;
  List<Cafe> cafes;
  bool isActive;
  bool isDeleted;

  Offer({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    required this.couponCode,
    required this.description,
    required this.terms,
    required this.endDate,
    required this.isActive,
    required this.isDeleted,
    this.cafes = const [],
  });

  static Offer jsonToOffer(Map offer) => Offer(
        id: offer['_id'] ?? '',
        name: offer['name'] ?? '',
        type: offer['type'] ?? '',
        image: offer['image'] ?? '',
        couponCode: offer['couponCode'] ?? '',
        description: offer['description'] ?? '',
        terms: offer['terms'] ?? [],
        endDate: getParseDate(offer['endDate']),
        isActive: offer['isActive'] ?? false,
        isDeleted: offer['isDeleted'] ?? false,

        // cafes: (offer['cafes'] as List)
        //     .map((cafes) => Cafe.jsonToCafe(cafes))
        //     .toList(),
      );
}
