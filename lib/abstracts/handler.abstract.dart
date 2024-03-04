// import 'package:awesome_notifications/awesome_notifications.dart';

// abstract class LocalNotificationServiceHandler {
//   void onBackgroundAction(ReceivedAction receivedAction);
//   void onForegroundAction(ReceivedAction receivedAction);
// }



// import 'package:add_diabetic_logs_module/routes/routes.dart';
// import 'package:diabetes_enums/reminderType.enum.dart';
// import 'package:diabetes_models/payload/reminderNotificationPayload.model.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:get/get.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';

// class LocalNotificationHandler {
//   ///  *********************************************
//   ///     NOTIFICATION EVENTS
//   ///  *********************************************
//   ///
//   @pragma('vm:entry-point')
//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     if (receivedAction.actionType == ActionType.SilentAction ||
//         receivedAction.actionType == ActionType.SilentBackgroundAction) {
//       // Trigger silent action
//       onBackgroundAction(receivedAction);
//     } else {
//       // Trigger  action
//       onForegroundAction(receivedAction);
//     }
//   }

//   static void onBackgroundAction(ReceivedAction receivedAction) async {
//     await Firebase.initializeApp();
//     print("on Silent Action Received Fun ");
//     print('Received  Action ${receivedAction}');
//   }

//   static void onForegroundAction(ReceivedAction receivedAction) {
//     try {
//       //Define Payload of notification
//       final ReminderNotificationPayLoad payload =
//           ReminderNotificationPayLoad.fromData(receivedAction.payload!);

//       // GLUCOSE MEASURMENT
//       if (payload.type == ReminderType.Measurement)
//         Get.toNamed(AddDiabeticLogsNames.addGlucose);

//       // INSULINE DOSE
//       else if (payload.type == ReminderType.Insulin)
//         Get.toNamed(AddDiabeticLogsNames.addInsulin);
//     } catch (e, z) {
//       print('Error $e $z');
//     }
//   }
// }
