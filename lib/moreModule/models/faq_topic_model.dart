class FaqTopic {
  String id;
  String name;
  bool isActive;
  bool isDeleted;

  FaqTopic({
    required this.id,
    required this.name,
    required this.isActive,
    required this.isDeleted,
  });

  static FaqTopic jsonToFaqTopic(Map faqTopic) {
    return FaqTopic(
      id: faqTopic['_id'],
      name: faqTopic['name'] ?? '',
      isActive: faqTopic['isActive'] ?? false,
      isDeleted: faqTopic['isDeleted'] ?? false,
    );
  }
}
