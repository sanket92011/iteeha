import 'package:flutter/material.dart';
import 'package:iteeha_app/homeModule/models/notification_model.dart';

class NotificationsProvider extends ChangeNotifier {
  final List<NotificationModel> _notifications = [
    // NotificationModel(
    //     avatar: 'Avatar1',
    //     date: DateTime(2023, 9, 27),
    //     title: 'A New Cup for a New Day',
    //     subTitle: 'Get Special Price only at Iteeha'),
    // NotificationModel(
    //   avatar: 'Avatar2',
    //   date: DateTime(2023, 9, 28),
    //   title: 'Monsoon Offer',
    //   subTitle: 'Get Special Price only at Iteeha',
    // ),
    // NotificationModel(
    //   avatar: 'Avatar3',
    //   title: 'New coffee',
    //   date: DateTime(2023, 9, 28),
    //   subTitle: 'Get Special Price only at Iteeha',
    // ),
  ];
  List<NotificationModel> get notifications => [..._notifications];
  String get newNotifications => numberOfNotificationsFromFirstDateToNow;

  void fetchNotifications() {
    _notifications.clear();
    // _notifications.addAll([
    //   NotificationModel(
    //     avatar: 'Avatar1',
    //     date: DateTime(2023, 9, 27),
    //     title: 'A New Cup for a New Day',
    //     subTitle: 'Get Special Price only at Iteeha',
    //   ),
    //   NotificationModel(
    //     avatar: 'Avatar2',
    //     date: DateTime(2023, 9, 27),
    //     title: 'Monsoon Offer',
    //     subTitle: 'Get Special Price only at Iteeha',
    //   ),
    //   NotificationModel(
    //     avatar: 'Avatar3',
    //     title: 'New coffee',
    //     date: DateTime(2023, 9, 27),
    //     subTitle: 'Get Special Price only at Iteeha',
    //   ),
    // ]);

    // notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  String get numberOfNotificationsFromFirstDateToNow {
    DateTime currentDate = DateTime.now();
    int numberOfNotifications = _notifications.where((notification) {
      return notification.date.isBefore(currentDate);
    }).length;

    return numberOfNotifications.toString().padLeft(2, '0');
  }
}
