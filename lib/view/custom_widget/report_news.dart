import 'package:flutter/material.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/model/report_news.dart';
import 'package:nibbin_app/resource/report_news_repository.dart';
import 'package:nibbin_app/view/custom_widget/extra_info_reporting_tile.dart';

int selectedSubTypeID = -1;

Future reportModalBottomSheet(
    context, int newsID, GlobalKey<ScaffoldState> homePageScaffoldKey) async {
  ReportNewsRepository _reportNewsRepository = ReportNewsRepository();

  var response = await _reportNewsRepository.fetchReportingType();

  List<Widget> widgetList = prepareReportNewsWidgetList(
      response, context, newsID, homePageScaffoldKey);

  return await showModalBottomSheet(
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
    GlobalKey<ScaffoldState> homePageScaffoldKey) {
  List<Widget> widgetList = List<Widget>();

  widgetList.add(ListTile(
    contentPadding: EdgeInsets.all(0),
    leading: Text(
      'Why are you reporting this?',
      style: TextStyle(
          fontSize: 14,
          color: Color(0xFF111111),
          letterSpacing: 0.14,
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
        homePageScaffoldKey: homePageScaffoldKey));
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
  ReportTypeTile({this.reportType, this.newsID, this.homePageScaffoldKey});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: Text(
        reportType.typeTitle,
        style: TextStyle(
            fontSize: 14,
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
        _detailedReportModalBottomSheet(
            context, reportType.subTypes, newsID, homePageScaffoldKey);
      },
    );
  }
}

Future _detailedReportModalBottomSheet(
    BuildContext context,
    List<ReportSubType> reportSubTypeList,
    int newsID,
    GlobalKey<ScaffoldState> homePageScaffoldKey) async {
  return await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext bc) {
      return DetailedReportNewsPage(
          reportSubTypeList: reportSubTypeList,
          newsID: newsID,
          homePageScaffoldKey: homePageScaffoldKey);
    },
  );
}

class DetailedReportNewsPage extends StatefulWidget {
  final List<ReportSubType> reportSubTypeList;
  final int newsID;
  final GlobalKey<ScaffoldState> homePageScaffoldKey;
  DetailedReportNewsPage(
      {this.reportSubTypeList, this.newsID, this.homePageScaffoldKey});

  @override
  DetailedReportNewsPageState createState() => DetailedReportNewsPageState();
}

String groupID;
DetailedReportNewsPageState detailedReportNewsPageState;

class DetailedReportNewsPageState extends State<DetailedReportNewsPage> {
  @override
  Widget build(BuildContext context) {
    detailedReportNewsPageState = this;
    List<Widget> widgetList = prepareDetailedReportWidgetList(context,
        widget.reportSubTypeList, widget.newsID, widget.homePageScaffoldKey);
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 30, top: 16),
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
    );
  }
}

prepareDetailedReportWidgetList(
  BuildContext context,
  List<ReportSubType> reportSubTypeList,
  int newsID,
  GlobalKey<ScaffoldState> homePageScaffoldKey,
) {
  List<Widget> widgetList = List<Widget>();
  widgetList.add(
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tell us a little more',
          style: TextStyle(
              fontSize: 14,
              color: Color(0xFF111111),
              letterSpacing: 0.14,
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
      height: 31,
    ),
  );
  widgetList.add(
    Center(
      child: ButtonTheme(
        height: 35,
        minWidth: 72,
        child: RaisedButton(
          child: Text(
            "Done",
          ),
          textColor: Color(0xFFFFFFFF),
          onPressed: () async {
            ReportNewsRepository _reportNewsRepository = ReportNewsRepository();
            var response = await _reportNewsRepository.reportSelectedNews(
                newsID,
                reportSubTypeList
                    .firstWhere(
                        (element) => element.subTypeID == selectedSubTypeID)
                    .typeID,
                selectedSubTypeID);
            if ((response as Map)["message"] == null) {
              print(response);
              Navigator.pop(context);
              homePageScaffoldKey.currentState
                  .showSnackBar(Constants.showReportSuccessSnackBar());
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
  return widgetList;
}
