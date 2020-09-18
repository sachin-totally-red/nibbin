import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nibbin_app/common/shared_preference.dart';
import 'package:nibbin_app/resource/api_handler.dart';

class NotificationRepository {
  APIHandler _apiHandler = APIHandler();
  Future updateFirebaseNotificationStatus(String userResponse) async {
    try {
      await addStringToSF("pushNotification", userResponse);

      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
      String token = await _firebaseMessaging.getToken();

      final fireStoreDBRef = FirebaseFirestore.instance;

      await fireStoreDBRef
          .collection("pushtokens")
          .where('devtoken', isEqualTo: token)
          .get()
          .then((value) async {
        if (value.size > 0)
          await fireStoreDBRef
              .collection("pushtokens")
              .doc(value.docs.first.id)
              .update({"notificationEnabled": userResponse});
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateApiNotificationStatus(bool userResponse) async {
    Map response = await _apiHandler.putAPICall(
        endPointURL: "user/profile",
        apiInputParameters: {'notification': userResponse});
    print(response);
  }
}
