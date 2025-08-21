class NotificationModel {
  String avatar;
  String title;
  String subTitle;
  DateTime date;
  bool isRead;

  NotificationModel(
      {required this.avatar,
      required this.title,
      required this.subTitle,
      this.isRead = false,
      required this.date});
}
