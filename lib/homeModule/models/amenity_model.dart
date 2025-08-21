class Amenity {
  String name;
  String svg;

  Amenity({
    required this.name,
    required this.svg,
  });

  static Amenity jsonToAmenity(Map amenity) => Amenity(
        name: amenity["name"],
        svg: amenity["svg"],
      );
}
