import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:get/get.dart';
import 'package:app_settings/app_settings.dart';
import 'package:lifesync_capstone_project/guru_pages/guru_home_pages/guru_notif_page.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      Get.snackbar(
        'Notification Permission',
        'User declined or has not accepted permission',
        snackPosition: SnackPosition.BOTTOM,
      );
      Future.delayed(const Duration(seconds: 3), () {
        AppSettings.openAppSettings(
          type: AppSettingsType.notification,
        ); // Open app settings for notification
      });
      // Open app settings for notific
    }
  }

  Future<String> getDeviceToken() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    String? token = await messaging.getToken();
    print('FCM Token: $token');
    if (token != null) {
      return token;
    } else {
      throw Exception('Failed to get FCM token');
    }
  }

  void initLocalNotification(
    BuildContext context,
    RemoteMessage message,
  ) async {
    var androidInitSetting = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var initializationSettings = InitializationSettings(
      android: androidInitSetting,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        print('Notification payload: ${details.payload}');
        // Handle the notification payload here
        handleMessage(context, message);
      },
    );

    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('app_icon');

    // const InitializationSettings initializationSettings =
    //     InitializationSettings(android: initializationSettingsAndroid);

    // _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print('Notification title: ${notification!.title}');
        print('Notification title: ${notification!.body}');
      }
      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        // handleMessage(context, message);

        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      showBadge: true,
      playSound: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channel.id.toString(),
          channel.name.toString(),
          channelDescription: 'channel desc',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          // showWhen: true,
          // enableVibration: true,
          // enableLights: true,
          // color: Colors.blue,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(context, message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null && message.data.isNotEmpty) {
        handleMessage(context, message);
      }
    });
  }

  Future<void> handleMessage(
    BuildContext context,
    RemoteMessage message,
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GuruNotificationPage(classId: ''),
      ),
    );
  }
}

// class NotificationService {
//   static Future<String> getAccessToken() async {
//     final file = File('assets/service_account.json');
//     final jsonContent = json.decode(await file.readAsString());
//     final credentials = auth.ServiceAccountCredentials.fromJson(jsonContent);

//     final scopes = [
//       'https://www.googleapis.com/auth/firebase.messaging',
//       'https://www.googleapis.com/auth/cloud-platform',
//     ];

//     final client = await auth.clientViaServiceAccount(credentials, scopes);
//     final token = client.credentials.accessToken.data;
//     client.close();

//     return token;
//   }

//   static Future<void> sendNotificationToSelectedUser(
//     String title,
//     String body,
//     String token,
//     String imageUrl,
//     String classId,
//     String userId,
//   ) async {
//     final String serverAccessToken = await getAccessToken();

//     const String endpointFirebase =
//         'https://fcm.googleapis.com/v1/projects/lifesync-capstone/messages:send';

//     final Map<String, dynamic> notification = {
//       'message': {
//         'token': token,
//         'notification': {'title': title, 'body': body, 'image': imageUrl},
//         'data': {'classId': classId, 'userId': userId},
//       },
//     };

//     try {
//       final response = await http.post(
//         Uri.parse(endpointFirebase),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $serverAccessToken',
//         },
//         body: jsonEncode(notification),
//       );

//       if (response.statusCode == 200) {
//         print('Notification sent successfully');
//       } else {
//         print('Failed to send notification: ${response.body}');
//       }
//     } catch (e) {
//       print('Error sending notification: $e');
//     }
//   }
// }
