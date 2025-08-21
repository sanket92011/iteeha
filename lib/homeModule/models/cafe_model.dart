import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iteeha_app/homeModule/models/amenity_model.dart';

class Cafe {
  final String id;
  String name;
  LatLng coordinates;
  List carouselphotos;
  List cafePhotos;
  List otherPhotos;
  List menu;
  List timings;
  String address;

  String area;
  bool isLiked;

  List<Amenity> amenities;

  Cafe({
    required this.id,
    required this.name,
    required this.coordinates,
    required this.carouselphotos,
    required this.cafePhotos,
    required this.otherPhotos,
    required this.address,
    required this.timings,
    required this.menu,
    required this.area,
    required this.amenities,
    this.isLiked = false,
  });

  static Cafe jsonToCafe(Map cafe) => Cafe(
        id: cafe['_id'],
        name: cafe['name'] ?? '',
        coordinates: LatLng(
            double.parse(cafe['location']['coordinates'][1].toString()),
            double.parse(cafe['location']['coordinates'][0].toString())),
        carouselphotos: cafe['carouselphotos'] ?? [],
        cafePhotos: cafe['cafePhotos'] ?? [],
        otherPhotos: cafe['otherPhotos'] ?? [],
        address: cafe['address'] ?? '',
        menu: cafe['menu'] ?? [],
        timings: cafe['timings'] ?? [],
        amenities: (cafe['amenities'] as List)
            .map((amenity) => Amenity.jsonToAmenity(amenity))
            .toList(),
        area: cafe['area'] ?? '',
        isLiked: cafe['isLiked'] ?? false,
      );
}
