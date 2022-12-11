import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final flutterNotificationService = FlutterLocalNotificationsPlugin();

  //Initialze
  static Future<void> intialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("mipmap/ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await flutterNotificationService.initialize(initializationSettings);
  }

  //Notification Details
  static Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('id', 'download',
            channelDescription: 'channel_description',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true);

    return const NotificationDetails(android: androidNotificationDetails);
  }

  //Show Notification
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    var details = await _notificationDetails();

    await flutterNotificationService.show(1, title, body, details);
  }

  //Show Progress Notification
  static Future<void> showProgressNotification({
    required int progrss,
    required int maxProgress,
    required String title,
    required String body,
  }) async {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('progress channel', 'progress channel',
            channelDescription: 'progress channel description',
            channelShowBadge: false,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: maxProgress,
            progress: progrss);
    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterNotificationService.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  //Cancel All Notifications
  static Future<void> cancelAllNotifications() async {
    try {
      await flutterNotificationService.cancelAll();
    } catch (e) {
      print("cancelAllNotifications Method Error ! = $e");
    }
  }

  //Cancel Custom Notification with ID
  static Future<void> cancelCustomNotification({int id = 0}) async {
    await flutterNotificationService.cancel(id);
  }
}
