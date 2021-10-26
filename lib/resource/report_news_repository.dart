import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/common/shared_preference.dart';
import 'package:nibbin_app/model/report_news.dart';
import 'api_handler.dart';

class ReportNewsRepository {
  APIHandler _apiHandler = APIHandler();

  Future fetchReportingType() async {
    String getReportDate = await getStringValuesSF("ReportDate");

    //TODO: Sachin : We can optimize this code after release first release.
    if (getReportDate == null) {
      //Save Date
      await addStringToSF("ReportDate", DateTime.now().toString());
      deleteAllSavedReportData();
      List<ReportType> reportTypeList = List<ReportType>();
      var response = await _apiHandler.getAPICall("report/types");
      (response as List).forEach((reportType) {
        reportTypeList.add(ReportType.fromJson(reportType as Map));
      });
      //Save Data to local
      var savingResult = await saveReportTypeAndSubType(reportTypeList);
      return reportTypeList;
    } else {
      DateTime formattedDate = DateTime.parse(getReportDate);
      DateTime currentDate = DateTime.now();
      int differenceInHours = currentDate.difference(formattedDate).inHours;
      if (differenceInHours > 24) {
        //Save Date
        await addStringToSF("ReportDate", DateTime.now().toString());
        deleteAllSavedReportData();
        List<ReportType> reportTypeList = List<ReportType>();
        var response = await _apiHandler.getAPICall("report/types");
        (response as List).forEach((reportType) {
          reportTypeList.add(ReportType.fromJson(reportType as Map));
        });
        //Save Data to local
        var savingResult = await saveReportTypeAndSubType(reportTypeList);
        return reportTypeList;
      } else {
        List<ReportType> reportTypeResult = await fetchSavedReportType();
        List<ReportSubType> reportSubTypeResult =
            await fetchSavedReportSubType();
        reportTypeResult.forEach((reportType) {
          reportSubTypeResult.forEach((subType) {
            if (reportType.typeID == subType.typeID) {
              if (reportType.subTypes == null) {
                reportType.subTypes = List<ReportSubType>();
              }
              reportType.subTypes.add(subType);
            }
          });
        });
        return reportTypeResult;
      }
    }

    /*List<ReportType> reportTypeResult = await fetchSavedReportType();
    if (reportTypeResult.length == 0) {
      List<ReportType> reportTypeList = List<ReportType>();
      var response = await _apiHandler.getAPICall("report/types");
      (response as List).forEach((reportType) {
        reportTypeList.add(ReportType.fromJson(reportType as Map));
      });
      //Save Data to local
      var savingResult = await saveReportTypeAndSubType(reportTypeList);
      return reportTypeList;
    } else {
      List<ReportSubType> reportSubTypeResult = await fetchSavedReportSubType();
      reportTypeResult.forEach((reportType) {
        reportSubTypeResult.forEach((subType) {
          if (reportType.typeID == subType.typeID) {
            if (reportType.subTypes == null) {
              reportType.subTypes = List<ReportSubType>();
            }
            reportType.subTypes.add(subType);
          }
        });
      });
      return reportTypeResult;
    }*/
  }

  Future reportSelectedNews(int newsID, int typeID, int subTypeID) async {
    Map<String, String> requestParam = {
      'typeId': typeID.toString(),
      'subTypeId': subTypeID.toString(),
      'app': "nibbin",
    };

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (iosInfo != null) {
        requestParam["platform"] = "ios";
        requestParam["deviceName"] = iosInfo.name ?? "";
        requestParam["deviceVersion"] = iosInfo.systemVersion ?? "";
        requestParam["deviceModel"] = iosInfo.model ?? "";
      }
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo != null) {
        requestParam["platform"] = "android";
        requestParam["deviceName"] = androidInfo.device ?? "";
        requestParam["deviceVersion"] = (androidInfo.version == null)
            ? ""
            : (androidInfo.version.release ?? "");
        requestParam["deviceModel"] = androidInfo.model ?? "";
      }
    }

    var response = await _apiHandler.postAPICall(
        endPointURL: "news/$newsID/report", apiInputParameters: requestParam);
    return response;
  }

  Future fetchSavedReportType() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    var maps = await helper.queryAllDataOnTableName(tableReportType);
    List<ReportType> savedReportType = List<ReportType>();
    if (maps.length > 0) {
      savedReportType =
          maps.map<ReportType>((i) => ReportType.fromJson(i)).toList();
    }
    return savedReportType;
  }

  Future fetchSavedReportSubType() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    var maps = await helper.queryAllDataOnTableName(tableReportSubType);
    List<ReportSubType> savedReportSubType = List<ReportSubType>();
    if (maps.length > 0) {
      savedReportSubType =
          maps.map<ReportSubType>((i) => ReportSubType.fromJson(i)).toList();
    }
    return savedReportSubType;
  }

  Future saveReportTypeAndSubType(List<ReportType> _reportType) async {
    try {
      DatabaseHelper helper = DatabaseHelper.instance;
      _reportType.forEach((element) async {
        int reportID =
            await helper.insert(tableName: tableReportType, tableData: element);
        print('inserted report type row ID : $reportID');

        element.subTypes.forEach((subType) async {
          int reportSubID = await helper.insert(
              tableName: tableReportSubType, tableData: subType);
          print('inserted subType row ID : $reportSubID');
        });
      });
    } catch (e) {
      if (e.toString().contains("UNIQUE constraint failed")) {
        print("Already add kar liya hai bhai");
      }
    }
  }

  Future deleteAllSavedReportData() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteAllDataOnTableName(tableReportType);
    await helper.deleteAllDataOnTableName(tableReportSubType);
  }
}
