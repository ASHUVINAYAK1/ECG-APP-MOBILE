import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission on iOS
    await _messaging.requestPermission();

    // Handle foreground messages.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // You can show a local notification here.
      print('Received a message: ${message.notification?.title}');
    });
  }

  Future<String?> getToken() async {
    return _messaging.getToken();
  }
}
