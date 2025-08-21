class Faq {
  String topic;
  String question;
  String answer;
  bool isActive;
  bool isDeleted;

  Faq({
    required this.topic,
    required this.question,
    required this.answer,
    required this.isActive,
    required this.isDeleted,
  });

  static Faq jsonToFaq(Map faq) {
    return Faq(
      topic: faq['topic'] ?? '',
      question: faq['question'] ?? '',
      answer: faq['answer'] ?? '',
      isActive: faq['isActive'] ?? false,
      isDeleted: faq['isDeleted'] ?? false,
    );
  }
}
