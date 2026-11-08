// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';



// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Make sure Firebase is initialized in background
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   log("Handling a background message: ${message.messageId}");
// }

// TextEditingController fCMToken = TextEditingController();

// class NotificationService {
//   factory NotificationService() => _instance;
//   NotificationService._internal();
//   static final NotificationService _instance = NotificationService._internal();

//   final _firebaseMessaging = FirebaseMessaging.instance;

//   final _androidChannel = const AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: "This is notification description",
//     importance: Importance.max,
//   );

//   final _localNotification = FlutterLocalNotificationsPlugin();

//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;
//     // Log or navigate based on message
//     log("Message handled: ${message.messageId}");
//   }

//   Future initLocalNotification() async {
//     const ios = DarwinInitializationSettings();
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const settings = InitializationSettings(android: android, iOS: ios);

//     await _localNotification.initialize(
//       settings: settings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         if (response.payload != null) {
//           try {
//             final data = jsonDecode(response.payload!);
//             final message = RemoteMessage(data: Map<String, String>.from(data));
//             handleMessage(message);
//           } catch (e) {
//             log("Error decoding notification payload: $e");
//           }
//         }
//       },
//     );

//     final platform = _localNotification.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//     await platform?.createNotificationChannel(_androidChannel);
//   }

//   Future initPushNotification() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // Handle when app is launched initially via a notification
//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

//     // Handle when the app is opened via a notification
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

//     // Handle foreground notifications
//     FirebaseMessaging.onMessage.listen((message) {
//       final notification = message.notification;
//       if (notification != null) {
//         // Display local notification for foreground messages
//         _localNotification.show(
//           id: notification.hashCode,
//           title: notification.title,
//           body: notification.body,
//           notificationDetails: NotificationDetails(
//             android: AndroidNotificationDetails(
//               _androidChannel.id,
//               _androidChannel.name,
//               channelDescription: _androidChannel.description,
//               icon: '@mipmap/ic_launcher',
//               importance: Importance.max,
//               priority: Priority.high,
//             ),
//             iOS: const DarwinNotificationDetails(),
//           ),
//           payload: jsonEncode(message.data),
//         );
//       }
//     });
//   }

//   Future<void> initNotification() async {
//     try {
//       // Request permission for notifications
//       NotificationSettings settings =
//           await _firebaseMessaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );

//       log('User granted permission: ${settings.authorizationStatus}');

//       String? token;

//       // Platform-specific handling for token retrieval
//       if (Platform.isIOS) {
//         final apnsToken = await _firebaseMessaging.getAPNSToken();
//         if (apnsToken != null) {
//           token = await _firebaseMessaging.getToken();
//         } else {
//           log("Error: APNS token is not set.");
//         }
//       } else {
//         token = await _firebaseMessaging.getToken();
//       }

//       if (token != null) {
//         log("FCM Token: $token");
//         await SharedPreferencesClass.setValue(AppConstants.fcmToken, token);
//         fCMToken.text = token;
//       }

//       final deviceId =
//           await SharedPreferencesClass.getValue(AppConstants.deviceId);
//       if (deviceId != null) {
//         log("Stored Device ID: $deviceId");
//       }
//     } catch (e) {
//       log("Error initializing notifications: $e");
//     }

//     await initPushNotification();
//     await initLocalNotification();
//   }
// }
