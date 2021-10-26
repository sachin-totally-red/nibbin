/*import 'package:nibbin_app/common/shared_preference.dart';
import 'package:nibbin_app/resource/api_handler.dart';*/
import 'package:nibbin_app/model/track_user_behavior.dart';

List<TrackedData> trackedNewsDataList = List<TrackedData>();

class TrackDataRepository {
  /*APIHandler _apiHandler = APIHandler();*/

  /*Future saveTrackedData(List<TrackedData> trackedData) async {
    String userID = await getStringValuesSF("UserID");
    if (userID != null) {
      trackedData.forEach((data) {
        data.userID = int.parse(userID);
      });
    }
    Map response = await _apiHandler.postAPICall(
        apiInputParameters: trackedData, endPointURL: "category");

    return response;
  }*/

  /*startTracking(int newsID) {
    try {
      int dataIndex =
          trackedNewsDataList.indexWhere((data) => data.newsID == newsID);
      if (dataIndex != -1) {
        trackedNewsDataList[dataIndex]
            .readingTiming
            .add(ReadingTiming(startTime: DateTime.now().toUtc().toString()));
      } else {
        List<ReadingTiming> readingTimingList = List<ReadingTiming>();
        List<ReadingTiming> emptyReadingFullNewsTimingList =
            List<ReadingTiming>();
        List<String> emptyElapsedTimeList = List<String>();
        readingTimingList
            .add(ReadingTiming(startTime: DateTime.now().toUtc().toString()));
        trackedNewsDataList.add(TrackedData(
          newsID: newsID,
          elapsedTime: emptyElapsedTimeList,
          readingTiming: readingTimingList,
          readingFullNewsTiming: emptyReadingFullNewsTimingList,
          fullNewsViewCount: 0,
          newsSharingConversionCount: 0,
          newsSharingCount: 0,
        ));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  stopTracking(int newsID) {
    try {
      int dataIndex =
          trackedNewsDataList.indexWhere((data) => data.newsID == newsID);
      if (dataIndex != -1) {
        int itemIndex = trackedNewsDataList[dataIndex]
            .readingTiming
            .indexWhere((element) => element.endTime == null);
        if (itemIndex != -1) {
          //Saving stop time
          trackedNewsDataList[dataIndex]
              .readingTiming
              .firstWhere((element) => element.endTime == null)
              .endTime = DateTime.now().toUtc().toString();
          //Saving Elapsed time
          String elapsedTime = DateTime.parse(
                  trackedNewsDataList[dataIndex].readingTiming.last.endTime)
              .difference(DateTime.parse(
                  trackedNewsDataList[dataIndex].readingTiming.last.startTime))
              .inSeconds
              .toString();
          trackedNewsDataList[dataIndex].elapsedTime.add(elapsedTime);
          print("elapsedTime $elapsedTime");
          //Save Sum of elapsed times
          trackedNewsDataList[dataIndex].totalElapsedTime =
              (trackedNewsDataList[dataIndex].totalElapsedTime ?? 0) +
                  int.parse(elapsedTime);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }*/

  /*startTrackingFullViewArticle(int newsID) {
    try {
      int dataIndex =
          trackedNewsDataList.indexWhere((data) => data.newsID == newsID);
      if (dataIndex != -1) {
        trackedNewsDataList[dataIndex]
            .readingFullNewsTiming
            .add(ReadingTiming(startTime: DateTime.now().toUtc().toString()));
        trackedNewsDataList[dataIndex].fullNewsViewCount =
            (trackedNewsDataList[dataIndex].fullNewsViewCount ?? 0) + 1;
      } else {
        List<ReadingTiming> readingTimingList = List<ReadingTiming>();
        readingTimingList
            .add(ReadingTiming(startTime: DateTime.now().toUtc().toString()));
        trackedNewsDataList.add(TrackedData(
          newsID: newsID,
          readingFullNewsTiming: readingTimingList,
          fullNewsViewCount: 1,
        ));
      }
    } catch (e) {
      print(e.toString());
    }
  }*/

  /*stopTrackingFullViewArticle(int newsID) {
    try {
      int dataIndex =
          trackedNewsDataList.indexWhere((data) => data.newsID == newsID);
      if (dataIndex != -1) {
        int itemIndex = trackedNewsDataList[dataIndex]
            .readingFullNewsTiming
            .indexWhere((element) => element.endTime == null);
        if (itemIndex != -1) {
          //Saving stop time
          trackedNewsDataList[dataIndex]
              .readingFullNewsTiming
              .firstWhere((element) => element.endTime == null)
              .endTime = DateTime.now().toUtc().toString();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }*/

  /*trackNewsSharingRecord(int newsID) {
    try {
      int dataIndex =
          trackedNewsDataList.indexWhere((data) => data.newsID == newsID);
      if (dataIndex != -1) {
        trackedNewsDataList[dataIndex].newsSharingCount =
            (trackedNewsDataList[dataIndex].newsSharingCount ?? 0) + 1;
      } else {
        trackedNewsDataList.add(TrackedData(
          newsID: newsID,
          newsSharingCount: 1,
        ));
      }
    } catch (e) {
      print(e.toString());
    }
  }*/

  /*trackNewsSharingConversionRecord(int newsID) {
    try {
      int dataIndex =
          trackedNewsDataList.indexWhere((data) => data.newsID == newsID);
      if (dataIndex != -1) {
        trackedNewsDataList[dataIndex].newsSharingConversionCount =
            (trackedNewsDataList[dataIndex].newsSharingCount ?? 0) + 1;
      } else {
        List<ReadingTiming> emptyReadingTimingList = List<ReadingTiming>();
        List<String> emptyElapsedTimeList = List<String>();
        trackedNewsDataList.add(TrackedData(
          newsID: newsID,
          newsSharingConversionCount: 1,
          elapsedTime: emptyElapsedTimeList,
          readingTiming: emptyReadingTimingList,
          readingFullNewsTiming: emptyReadingTimingList,
          fullNewsViewCount: 0,
          newsSharingCount: 0,
        ));
      }
    } catch (e) {
      print(e.toString());
    }
  }*/
}
