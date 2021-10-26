import 'dart:convert';
import 'package:amplitude_flutter/identify.dart';
import 'package:nibbin_app/common/constants.dart' as appConst;
import 'package:nibbin_app/common/shared_preference.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/resource/track_data_repository.dart';

class AmplitudeRepository {
  /*Future<void> initializeAmplitude() async {
    const _apiKey = "629ef898b76c6b3896ffbdc7e051f17e";
    const _secretKey = "1e21e9dd33454fb279b7d132f6e73ec0";
    const projectID = "297235";

    String userID = await getStringValuesSF("UserID");

    // Initialize SDK
    appConst.Constants.analytics.init(_apiKey);

    // Enable COPPA privacy guard. This is useful when you choose not to report sensitive user information.
    appConst.Constants.analytics.enableCoppaControl();

    // Set user Id
    appConst.Constants.analytics.setUserId(userID ?? "test_user");

    // Turn on automatic session events
    appConst.Constants.analytics.trackingSessionEvents(true);

    // Log an event
    */ /*appConst.Constants.analytics.logEvent('MyApp startup',
        eventProperties: {'friend_num': 10, 'is_heavy_user': true});*/ /*

    // Identify
    final Identify identify1 = Identify()
      ..set('identify_test',
          'identify sent at ${DateTime.now().millisecondsSinceEpoch}')
      ..add('identify_count', 1);
    appConst.Constants.analytics.identify(identify1);

    // Set group
    appConst.Constants.analytics.setGroup('orgId', 15);

    // Group identify
    final Identify identify2 = Identify()..set('identify_count', 1);
    appConst.Constants.analytics.groupIdentify('orgId', '15', identify2);
  }

  viewFullArticleEvent(
      int newsID, int elapsedTimeInSec, List<NewsCategory> newCategories) {
    String _newsUrl = createHashedURL(newsID);
    newCategories.forEach((category) {
      appConst.Constants.analytics
          .logEvent('Viewed Full Article', eventProperties: {
        'news_id': newsID,
        'total_time_spent': elapsedTimeInSec,
        'news_url': _newsUrl,
        'categories': category,
      });
    });
  }

  Future setUserIDForAmplitude() async {
    String userID = await getStringValuesSF("UserID");
    appConst.Constants.analytics.setUserId(userID ?? "test_user");
  }

  trackNewsCardReadSession(
      int newsID, String deviceToken, List<NewsCategory> newCategories) async {
    try {
      int dataIndex =
          trackedNewsDataList.indexWhere((data) => data.newsID == newsID);
      if (dataIndex != -1) {
        if (double.parse(trackedNewsDataList[dataIndex].elapsedTime.last) >
            3.0) {
          String userID = await getStringValuesSF("UserID");
          String _newsUrl = createHashedURL(newsID);
          newCategories.forEach((category) {
            appConst.Constants.analytics.logEvent(
              'News Read Session',
              eventProperties: {
                'user_id': userID,
                'news_id': newsID,
                'elapsed_time': trackedNewsDataList[dataIndex].elapsedTime.last,
                'start_reading_timing':
                    trackedNewsDataList[dataIndex].readingTiming.last.startTime,
                'end_reading_timing':
                    trackedNewsDataList[dataIndex].readingTiming.last.endTime,
                'device_token': deviceToken,
                'news_url': _newsUrl,
                'categories': category,
              },
            );
          });
          print("This news has read by the user");
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  trackNewUser() async {
    String deviceToken = await getStringValuesSF("DeviceToken");
    appConst.Constants.analytics.logEvent('Group Selection Screen',
        eventProperties: {'device_id': deviceToken});
  }

  trackNewsSharingEvent(int newsID, List<NewsCategory> newCategories) async {
    String _deviceToken = await getStringValuesSF("DeviceToken");
    String _userID = await getStringValuesSF("UserID");
    String _newsUrl = createHashedURL(newsID);
    newCategories.forEach((category) {
      appConst.Constants.analytics.logEvent('News Sharing', eventProperties: {
        'user_id': _userID,
        'device_id': _deviceToken,
        'news_id': newsID,
        'news_url': _newsUrl,
        'categories': category,
      });
    });
  }

  createHashedURL(int newsID) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return ("https://nibb.in/news?id=" +
        stringToBase64.encode(newsID.toString()));
  }*/
}
