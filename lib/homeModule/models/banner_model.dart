class BannerModel {
  final String id;
  final String link;
  final String image;
  final List level;

  BannerModel({
    required this.id,
    required this.link,
    required this.image,
    required this.level,
  });

  static BannerModel jsonToBanner(banner) => BannerModel(
        id: banner['_id'],
        link: banner['link'] ?? '',
        image: banner['image'] ?? '',
        level: banner['level'] ?? [],
      );
}
