// import 'dart:convert';
// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';

// String? fCMToken = '';
// Future<void> handleBackgroundMesssage(RemoteMessage message) async {
//   print('Title: ${message.notification?.title}');
//   print('Body: ${message.notification?.body}');
//   print('Payload: ${message.data}');
// }

// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   final _androidChannel = const AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: 'This channel is used for important notifications',
//     importance: Importance.defaultImportance,
//     playSound: true,
//     // sound: RawResourceAndroidNotificationSound('noti'),
//   );

//   final _localNotifications = FlutterLocalNotificationsPlugin();

//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;

//     // navigatorKey.currentState?.pushNamed(
//     //   // Event.route,
//     //   // NotificationScreen.route,
//     //   arguments: message,
//     // );
//   }

//   Future initLocalNotifications() async {
//     const iOS = DarwinInitializationSettings();
//     const android = AndroidInitializationSettings('@drawable/ic_launcher');
//     const settings = InitializationSettings(android: android, iOS: iOS);

//     await _localNotifications.initialize(
//       settings,
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) {
//         final message =
//             RemoteMessage.fromMap(jsonDecode(notificationResponse.payload!));
//         handleMessage(message);
//       },
//       // onSelectNotification: (payload) {
//       //   final message = RemoteMessage.fromMap(jsonDecode(payload!));
//       //   handleMessage(message);
//       // },
//     );

//     final platform = _localNotifications.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//     await platform?.createNotificationChannel(_androidChannel);
//   }

//   Future initPushNotifications() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMesssage);
//     FirebaseMessaging.onMessage.listen((message) async {
//       final notification = message.notification;
//       if (notification == null) return;
//       print("notificatioafn: ${notification}");
//       print("imageurl;: ${notification.android!.imageUrl}");

//       //
//       String? imageUrl;
//       if (notification.android!.imageUrl != null) {
//         imageUrl = notification.android!.imageUrl;
//       }

//       AndroidNotificationDetails androidDetails;

//       if (imageUrl != null && imageUrl.isNotEmpty) {
//         // Download the image and show it in the notification
//         final bigPicture = await _downloadAndSaveImage(imageUrl, 'bigPicture');

//         androidDetails = AndroidNotificationDetails(
//           _androidChannel.id,
//           _androidChannel.name,
//           channelDescription: _androidChannel.description,
//           icon: '@drawable/ic_launcher',
//           playSound: true,
//           // sound: RawResourceAndroidNotificationSound('noti'),
//           styleInformation: BigPictureStyleInformation(
//             FilePathAndroidBitmap(bigPicture),
//             largeIcon: FilePathAndroidBitmap(bigPicture),
//             hideExpandedLargeIcon: true,
//             // contentTitle: notification.title,
//             // summaryText: notification.body,
//           ),
//         );
//       } else {
//         androidDetails = AndroidNotificationDetails(
//           _androidChannel.id,
//           _androidChannel.name,
//           channelDescription: _androidChannel.description,
//           icon: '@drawable/ic_launcher',
//           playSound: true,
//           styleInformation: BigTextStyleInformation(''),
//         );
//       }
//       //

//       _localNotifications.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: androidDetails,
//           // android: AndroidNotificationDetails(
//           //   _androidChannel.id,
//           //   _androidChannel.name,
//           //   channelDescription: _androidChannel.description,
//           //   icon: '@drawable/ic_launcher',
//           //   styleInformation: BigPictureStyleInformation(FilePathAndroidBitmap("${notification.android!.imageUrl}"))
//           //   // styleInformation: BigTextStyleInformation(''),
//           // ),
//         ),
//         payload: jsonEncode(message.toMap()),
//       );
//     });
//   }

//   Future<void> initNotifications() async {
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // in real world application we neeed to save this token somewhere in your database alongside your user entity to use it later on
//     try {
//       fCMToken = await _firebaseMessaging.getToken();
//       print('FCM Token: $fCMToken');
//     } catch (e) {
//       print('Error fetching FCM token: $e');
//       if (Platform.isIOS || Platform.isAndroid) {
//         fCMToken = 'dummy token assigned';
//       }
//     }

//     // await updateFcmToken(fCMToken, auth.token);
//     // print('TOken: $fCMToken');
//     // FirebaseMessaging.onBackgroundMessage(handleBackgroundMesssage);
//     initPushNotifications();
//     initLocalNotifications();
//   }

//   //
//   Future<String> _downloadAndSaveImage(String url, String fileName) async {
//     final response = await http.get(Uri.parse(url));
//     final directory = await getApplicationDocumentsDirectory();
//     print(
//         "directory.path: ${directory.path}"); // Correct usage of path_provider
//     final filePath = '${directory.path}/$fileName';
//     final file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes); // Save the image to the file
//     return filePath;
//   }
//   //
// }
