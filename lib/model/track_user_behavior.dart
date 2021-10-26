class TrackedData {
  int userID;
  int newsID;
  List<String> elapsedTime;
  int totalElapsedTime;
  List<ReadingTiming> readingTiming;
  int fullNewsViewCount;
  List<ReadingTiming> readingFullNewsTiming;
  int newsSharingCount;
  int newsSharingConversionCount;

  Map<String, dynamic> toJson() => {
        if (userID != null) 'userID': userID,
        if (newsID != null) 'newsID': newsID,
        if (elapsedTime != null) 'elapsedTime': elapsedTime,
        if (totalElapsedTime != null) 'totalElapsedTime': totalElapsedTime,
        if (readingTiming != null) 'readingTiming': readingTiming,
        if (fullNewsViewCount != null) 'fullNewsViewCount': fullNewsViewCount,
        if (readingFullNewsTiming != null)
          'readingFullNewsTiming': readingFullNewsTiming,
        if (newsSharingCount != null) 'newsSharingCount': newsSharingCount,
        if (newsSharingConversionCount != null)
          'newsSharingConversion': newsSharingConversionCount,
      };

  TrackedData({
    this.userID,
    this.newsID,
    this.elapsedTime,
    this.totalElapsedTime,
    this.readingTiming,
    this.fullNewsViewCount,
    this.readingFullNewsTiming,
    this.newsSharingCount,
    this.newsSharingConversionCount,
  });
}

class ReadingTiming {
  String startTime;
  String endTime;

  ReadingTiming({
    this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toJson() => {
        if (startTime != null) 'startTime': startTime,
        if (endTime != null) 'endTime': endTime,
      };
}
