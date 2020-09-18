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
      String tokenSaved = await getStringValuesSF("tokenAlreadySaved");
      if (tokenSaved == null) {
        String token = await _firebaseMessaging.getToken();
        if (token != null) await addStringToSF("tokenAlreadySaved", "Yes");

        final fireStoreDBRef = FirebaseFirestore.instance;
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
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  Future<void> handleNotificationOnTapEvent(context) {
    HomeRepository _homeRepository = HomeRepository();
    try {
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          var tag = message['notification']['title'];
          if (tag == 'puppy') {
            // go to puppy page
          } else if (tag == 'catty') {
            // go to catty page
          }
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          Post response = await _homeRepository
              .fetchSingleNews(int.parse(message["data"]["newsID"]));

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationNewsPage(
                news: response,
              ),
            ),
          );
          // TODO optional
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          Post response = await _homeRepository
              .fetchSingleNews(int.parse(message["data"]["newsID"]));
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationNewsPage(
                news: response,
              ),
            ),
          );
          // TODO optional
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
