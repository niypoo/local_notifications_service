import 'package:awesome_notifications/awesome_notifications.dart';

abstract class LocalNotificationServiceHandler {
  void onBackgroundAction(ReceivedAction receivedAction);
  void onForegroundAction(ReceivedAction receivedAction);
}
