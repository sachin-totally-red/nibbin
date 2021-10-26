import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/model/report_news.dart';
import 'package:nibbin_app/resource/report_news_repository.dart';
import 'package:nibbin_app/view/custom_widget/extra_info_reporting_tile.dart';
import 'package:nibbin_app/view/custom_widget/progress_indicator.dart';
import 'package:nibbin_app/view/home_page.dart';

int selectedSubTypeID = -1;

Future reportModalBottomSheet(
    context, int newsID, GlobalKey<ScaffoldState> homePageScaffoldKey,
    {bool homePageWidget = false}) async {
  ReportNewsRepository _reportNewsRepository = ReportNewsRepository();

  var response = await _reportNewsRepository.fetchReportingType();

  List<Widget> widgetList = prepareReportNewsWidgetList(
      response, context, newsID, homePageScaffoldKey, homePageWidget);

  return await showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
          decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(11),
                  topRight: const Radius.circular(11))),
          child: SafeArea(
            child: Wrap(children: widgetList),
          ),
        );
      });
}

prepareReportNewsWidgetList(
    List<ReportType> reportTypeList,
    BuildContext context,
    int newsID,
    GlobalKey<ScaffoldState> homePageScaffoldKey,
    bool homePageWidget) {
  List<Widget> widgetList = List<Widget>();

  widgetList.add(ListTile(
    contentPadding: EdgeInsets.all(0),
    leading: Text(
      'Why are you reporting this?',
      style: TextStyle(
          fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
          color: Color(0xFF111111),
          letterSpacing: 0.6,
          fontWeight: FontWeight.w600),
    ),
    trailing: Image.asset(
      'assets/images/close_circle_icon.png',
      height: 19.81,
      width: 19.81,
    ),
    onTap: () => Navigator.pop(context),
  ));

  reportTypeList.forEach((reportType) {
    widgetList.add(ReportTypeTile(
      reportType: reportType,
      newsID: newsID,
      homePageScaffoldKey: homePageScaffoldKey,
      homePageWidget: homePageWidget,
    ));
    widgetList.add(
      Container(
        color: Color(0xFFBDBDBD),
        height: 1,
      ),
    );
  });
  widgetList.removeLast();
  return widgetList;
}

class ReportTypeTile extends StatelessWidget {
  final ReportType reportType;
  final int newsID;
  final GlobalKey<ScaffoldState> homePageScaffoldKey;
  final bool homePageWidget;
  ReportTypeTile(
      {this.reportType,
      this.newsID,
      this.homePageScaffoldKey,
      this.homePageWidget});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: Text(
        reportType.typeTitle,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
            color: Color(0xFF1A101F),
            letterSpacing: 0.14,
            fontWeight: FontWeight.w400),
      ),
      trailing: Image.asset(
        'assets/images/arrow_right_icon.png',
        height: 14.22,
        width: 8,
      ),
      onTap: () {
        Navigator.pop(context);
        _detailedReportModalBottomSheet(context, reportType.subTypes, newsID,
            homePageScaffoldKey, homePageWidget);
      },
    );
  }
}

Future _detailedReportModalBottomSheet(
  BuildContext context,
  List<ReportSubType> reportSubTypeList,
  int newsID,
  GlobalKey<ScaffoldState> homePageScaffoldKey,
  homePageWidget,
) async {
  return await showModalBottomSheet<dynamic>(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext bc) {
      return DetailedReportNewsPage(
        reportSubTypeList: reportSubTypeList,
        newsID: newsID,
        homePageScaffoldKey: homePageScaffoldKey,
        homePageWidget: homePageWidget,
      );
    },
  );
}

class DetailedReportNewsPage extends StatefulWidget {
  final List<ReportSubType> reportSubTypeList;
  final int newsID;
  final GlobalKey<ScaffoldState> homePageScaffoldKey;
  final bool homePageWidget;
  DetailedReportNewsPage(
      {this.reportSubTypeList,
      this.newsID,
      this.homePageScaffoldKey,
      this.homePageWidget});

  @override
  DetailedReportNewsPageState createState() => DetailedReportNewsPageState();
}

String groupID;
DetailedReportNewsPageState detailedReportNewsPageState;
bool _showLoader = false;

class DetailedReportNewsPageState extends State<DetailedReportNewsPage> {
  @override
  Widget build(BuildContext context) {
    detailedReportNewsPageState = this;
    List<Widget> widgetList = prepareDetailedReportWidgetList(
        context,
        widget.reportSubTypeList,
        widget.newsID,
        widget.homePageScaffoldKey,
        widget.homePageWidget);
    return CustomProgressIndicator(
      inAsyncCall: _showLoader,
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 16),
        decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(11),
                topRight: const Radius.circular(11))),
        child: SafeArea(
          child: Wrap(
            children: widgetList,
          ),
        ),
      ),
    );
  }
}

prepareDetailedReportWidgetList(
  BuildContext context,
  List<ReportSubType> reportSubTypeList,
  int newsID,
  GlobalKey<ScaffoldState> homePageScaffoldKey,
  bool homePageWidget,
) {
  List<Widget> widgetList = List<Widget>();
  widgetList.add(
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tell us a little more',
          style: TextStyle(
              fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
              color: Color(0xFF111111),
              letterSpacing: 0.4,
              fontWeight: FontWeight.w600),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/images/close_circle_icon.png',
            height: 19.81,
            width: 19.81,
          ),
        ),
      ],
    ),
  );
  widgetList.add(
    SizedBox(
      height: 28,
    ),
  );
  reportSubTypeList.forEach((subType) {
    widgetList.add(
      MoreInfoReportingTile(
        title: subType.subTypeTitle,
        subTitle: subType.subTypeDescription,
        radioValue: subType.subTypeID.toString(),
      ),
    );
    widgetList.add(
      Container(
        color: Color(0xFFBDBDBD),
        height: 1,
      ),
    );
  });
  widgetList.removeLast();
  widgetList.add(
    SizedBox(
      height: ScreenUtil().setSp(31, allowFontScalingSelf: true),
    ),
  );
  widgetList.add(
    Center(
      child: ButtonTheme(
        height: ScreenUtil().setSp(35, allowFontScalingSelf: true),
        minWidth: ScreenUtil().setSp(72, allowFontScalingSelf: true),
        child: RaisedButton(
          child: Text(
            "Done",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
            ),
          ),
          textColor: Color(0xFFFFFFFF),
          onPressed: () async {
            try {
              if (selectedSubTypeID != -1) {
                Navigator.pop(context);
                if (homePageWidget) {
                  homePageState.setState(() {
                    showLoader = true;
                  });
                }
                ReportNewsRepository _reportNewsRepository =
                    ReportNewsRepository();

                var response = await _reportNewsRepository.reportSelectedNews(
                    newsID,
                    reportSubTypeList
                        .firstWhere(
                            (element) => element.subTypeID == selectedSubTypeID)
                        .typeID,
                    selectedSubTypeID);
                if (homePageWidget) {
                  homePageState.setState(() {
                    showLoader = false;
                  });
                }
                selectedSubTypeID = -1;
                if ((response as Map)["message"] == null) {
                  print(response);
                  homePageScaffoldKey.currentState
                      .showSnackBar(Constants.showReportSuccessSnackBar());
                }
              }
            } catch (e) {
              if (homePageWidget) {
                homePageState.setState(() {
                  showLoader = false;
                });
              }
              homePageScaffoldKey.currentState
                  .showSnackBar(Constants.showSnackBar());
            }
          },
          color: Color(0xFF1A101F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    ),
  );

  widgetList.add(
    SizedBox(
      height: 60,
    ),
  );
  return widgetList;
}
