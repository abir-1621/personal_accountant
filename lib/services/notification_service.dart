import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../model/reminder_model.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService();

  init() async {
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    // IOSInitializationSettings iosInitializationSettings =
    //     IOSInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      // iOS: iosInitializationSettings,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  getAndroidNotificationDetails() {
    return AndroidNotificationDetails(
      'reminder',
      'Reminder Notification',
      channelDescription: 'Notification sent as reminder',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      icon: '@mipmap/launcher_icon',
      groupKey: 'com.varadgauthankar.simple_reminder.REMINDER',
    );
  }

  // getIosNotificationDetails() {
  //   return IOSNotificationDetails();
  // }

  getNotificationDetails() {
    return NotificationDetails(
      android: getAndroidNotificationDetails(),
      // iOS: getIosNotificationDetails(),
    );
  }

  Future scheduleNotification(Reminder reminder) async {
    if (reminder.dateTime != null) {
      flutterLocalNotificationsPlugin.zonedSchedule(
        reminder.key,
        reminder.title,
        reminder.description,
        notificationTime(reminder.dateTime!),
        getNotificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
      print('notification set at ${reminder.dateTime}');
    } else {
      return;
    }
  }

  Future<bool> reminderHasNotification(Reminder reminder) async {
    var pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications
        .any((notification) => notification.id == reminder.key);
  }

  void updateNotification(Reminder reminder) async {
    var hasNotification = await reminderHasNotification(reminder);
    if (hasNotification) {
      flutterLocalNotificationsPlugin.cancel(reminder.key);
    }

    scheduleNotification(reminder);
  }

  void cancelNotification(int id) {
    flutterLocalNotificationsPlugin.cancel(id);
    print('$id canceled');
  }

  tz.TZDateTime notificationTime(DateTime dateTime) {
    return tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );
  }
}
