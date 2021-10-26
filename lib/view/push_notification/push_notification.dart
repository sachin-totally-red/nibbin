import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nibbin_app/common/shared_preference.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/resource/home_repository.dart';
import 'package:nibbin_app/view/push_notification/notification_news.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init(context) async {
    try {
      if (!_initialized) {
        // For iOS request permission first.
        _firebaseMessaging.requestNotificationPermissions();
//        _firebaseMessaging.configure();

        // For testing purposes print the Firebase Messaging token
        String token = await _firebaseMessaging.getToken();
        print("FirebaseMessaging token: $token");

        _initialized = true;
      }

      await Firebase.initializeApp();
      //Saving Device Token to the FireStore.
      /*String deviceToken = await getStringValuesSF("DeviceToken");*/
      final fireStoreDBRef = FirebaseFirestore.instance;
      /*if (deviceToken == null) {*/
      String token = await _firebaseMessaging.getToken();
      /*if (token != null) */ await addStringToSF("DeviceToken", token);
      await fireStoreDBRef
          .collection("pushtokens")
          .where('devtoken', isEqualTo: token)
          .get()
          .then((value) async {
        if (value.size == 0) {
          String notificationEnabled =
              await getStringValuesSF("pushNotification");
          DocumentReference ref =
              await fireStoreDBRef.collection("pushtokens").add({
            'devtoken': token,
            "notificationEnabled": notificationEnabled ?? "YES",
            "categories": []
          });
          print("FireStore ref : $ref");
        }
      });
      /*} else {
        //Check if device token has changed
        */ /*await fireStoreDBRef
            .collection("pushtokens").where('devtoken', isEqualTo: deviceToken).get().*/ /*
      }*/
    } catch (ex) {
      print(ex.toString());
    }
  }

  Future<void> handleNotificationOnTapEvent(context) {
    try {
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          /*print("onMessage: $message");
          await redirectToNotificationPage(message, context);*/
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          await redirectToNotificationPage(message, context);
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          await redirectToNotificationPage(message, context);
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }
}

Future redirectToNotificationPage(
    Map<String, dynamic> message, BuildContext context) async {
  HomeRepository _homeRepository = HomeRepository();
  String newsID =
      message["data"] != null ? (message["data"]["newsID"]) : message["newsID"];
  Post response = await _homeRepository.fetchSingleNews(int.parse(newsID));

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NotificationNewsPage(
        news: response,
      ),
    ),
  );
}
