import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bottom_sheet_helper/services/conformationSheet.helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_notifications_service/abstracts/handler.abstract.dart';

class LocalNotificationsService extends GetxService {
  // defined
  static LocalNotificationsService get to => Get.find();

  // channel key
  static late String _channelKey;

  // initialization
  Future<LocalNotificationsService> init({
    required String channelKey,
    required channelName,
    required channelDescription,
    required LocalNotificationServiceHandler handler,
    String notificationIcon = 'resource://mipmap/notification_icon',
    String soundSource = 'resource://raw/notification_sound',
    Color? notificationColor,
    bool playSound = true,
    bool onlyAlertOnce = true,
    GroupAlertBehavior groupAlertBehavior = GroupAlertBehavior.Children,
    NotificationImportance importance = NotificationImportance.High,
    NotificationPrivacy defaultPrivacy = NotificationPrivacy.Private,
  }) async {
    _channelKey = channelKey;

    // initialize
    await AwesomeNotifications().initialize(
      notificationIcon,
      [
        NotificationChannel(
          channelKey: channelKey,
          channelName: channelName,
          channelDescription: channelDescription,
          playSound: playSound,
          onlyAlertOnce: onlyAlertOnce,
          groupAlertBehavior: groupAlertBehavior,
          importance: importance,
          defaultPrivacy: defaultPrivacy,
          defaultColor: notificationColor ?? Get.theme.primaryColor,
          ledColor: notificationColor ?? Get.theme.primaryColor,
          soundSource: soundSource,
        )
      ],
      debug: true,
    );

    ///  *********************************************
    ///     NOTIFICATION EVENTS LISTENER
    ///  *********************************************
    ///  Notifications events are only delivered after call this method
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction receivedAction) =>
          onActionReceivedMethod(receivedAction, handler),
    );

    return this;
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction,
      LocalNotificationServiceHandler handler) async {
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // Trigger silent action
      handler.onBackgroundAction(receivedAction);
    } else {
      // Trigger  action
      handler.onForegroundAction(receivedAction);
    }
  }

  // request allowed show notifications
  Future<bool> isNotificationAllowed() async {
    return await AwesomeNotifications().isNotificationAllowed();
  }

  // request allowed show notifications
  Future<bool> requestNotificationPermission() async {
    return await AwesomeNotifications().requestPermissionToSendNotifications();
  }

// request allowed show notifications
  Future<bool> askPermissionBottomSheet({
    required String title,
    required String body,
    IconData? icon,
  }) async {
    // check if user has give us the permission
    if (await isNotificationAllowed()) return true;

    // Insert here your friendly dialog box before call the request method
    // This is very important to not harm the user experience
    final dynamic confirm = await ConformationSheetHelper.show(
      title: title,
      subTitle: body,
      yesTitle: 'Allow'.tr,
      noTitle: "Don't allow".tr,
      icon: icon,
    );

    // show permission
    if (confirm != null && confirm) {
      return await requestNotificationPermission();
    } else {
      return false;
    }
  }

  // // Declared as global, outside of any class
  Future<void> createNotificationFromJsonData(dynamic message) async {
    // Use this method to automatically convert the push data, in case you gonna use our data standard
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  }

  //show instantly
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? bigPicture,
    String? icon,
    String? largeIcon,
    Map<String, String?>? payload,
    List<NotificationActionButton>? actionButtons,
    NotificationLayout notificationLayout = NotificationLayout.BigText,
  }) async {
    // skip
    if (!await isNotificationAllowed()) return;

    // trigger notification
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: _channelKey,
        title: title,
        body: body,
        notificationLayout: notificationLayout,
        bigPicture: bigPicture,
        icon: icon,
        largeIcon: largeIcon,
        payload: payload,
      ),
      actionButtons: actionButtons,
    );
  }

  //show Scheduled
  Future<void> showAsScheduled({
    required int id,
    required String title,
    required String body,
    required DateTime date,
    String? bigPicture,
    String? icon,
    String? largeIcon,
    Map<String, String?>? payload,
    List<NotificationActionButton>? actionButtons,
    NotificationLayout notificationLayout = NotificationLayout.Default,
  }) async {
    // skip
    if (!await isNotificationAllowed()) return;

    // trigger notification
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: _channelKey,
        title: title,
        body: body,
        notificationLayout: notificationLayout,
        bigPicture: bigPicture,
        icon: icon,
        largeIcon: largeIcon,
        payload: payload,
      ),
      actionButtons: actionButtons,
      schedule: NotificationCalendar.fromDate(date: date, repeats: false),
    );
  }

  //show Period
  Future<void> showAsPeriod({
    required int id,
    required String title,
    required String body,
    required DateTime date,
    Map<String, String?>? payload,
    String? bigPicture,
    String? icon,
    String? largeIcon,
    List<NotificationActionButton>? actionButtons,
    NotificationLayout notificationLayout = NotificationLayout.Default,
  }) async {
    // skip
    if (!await isNotificationAllowed()) return;

    // trigger notification
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: _channelKey,
        title: title,
        body: body,
        notificationLayout: notificationLayout,
        bigPicture: bigPicture,
        icon: icon,
        largeIcon: largeIcon,
        payload: payload,
      ),
      actionButtons: actionButtons,
      schedule: NotificationCalendar.fromDate(date: date, repeats: true),
    );
  }

  // Cancel notification by id
  Future<void> cancel(int id) async => await AwesomeNotifications().cancel(id);
  // Cancel all notification
  Future<void> cancelAll() async => await AwesomeNotifications().cancelAll();
  // Cancel all notification
  Future<void> cancelAllSchedules() async =>
      await AwesomeNotifications().cancelAllSchedules();
  // Cancel all notification
  Future<void> cancelSchedule(int id) async =>
      await AwesomeNotifications().cancelSchedule(id);
}
