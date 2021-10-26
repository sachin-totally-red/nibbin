import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nibbin_app/bloc/bookmark_bloc.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/shared_preference.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/resource/bookmark_repository.dart';
import 'package:nibbin_app/resource/sharing.dart';
import 'package:nibbin_app/view/bookmarks.dart';
import 'package:nibbin_app/view/custom_widget/report_news.dart';
import 'package:nibbin_app/view/home_page.dart';
import 'package:nibbin_app/view/login_page.dart';

class NotificationNewsPage extends StatefulWidget {
  final Post news;
  final HomePageState homePageState;
  final BookmarksPageState bookmarksPageState;

  NotificationNewsPage(
      {this.news, this.homePageState, this.bookmarksPageState});

  @override
  _NotificationNewsPageState createState() => _NotificationNewsPageState();
}

class _NotificationNewsPageState extends State<NotificationNewsPage> {
  final _singleStoryPageScaffoldKey = GlobalKey<ScaffoldState>();

  fetchWidgets() {}

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      color: Color(0xFF000000),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          key: _singleStoryPageScaffoldKey,
          backgroundColor: Color(0xFF1A101F),
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: ImageIcon(
                AssetImage(
                  "assets/images/back_arrow.png",
                ),
                size: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Image.asset(
              "assets/images/nibbin_logo_white.png",
              width: screenSize.width * 117 / 360,
              height: screenSize.height * 42 / 640,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: (widget.bookmarksPageState == null)
              ? Container(
                  height: ScreenUtil().setSp(35, allowFontScalingSelf: true),
                  width: ScreenUtil().setSp(108, allowFontScalingSelf: true),
                  child: FloatingActionButton.extended(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(150.0))),
                    backgroundColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text(
                      "News Feed",
                      style: TextStyle(
                        fontSize:
                            ScreenUtil().setSp(14, allowFontScalingSelf: true),
                        color: Color(0xFF1A101F),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.16,
                      ),
                    ),
                    foregroundColor: Colors.black87,
                  ),
                )
              : null,
          body: Container(
            color: Color(0xFF1A101F),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 60),
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child:
                                  /*Container(
                                height: screenSize.height * 177 / 640,
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                  color: Colors.black87,
                                  image: new DecorationImage(
                                      image: new NetworkImage(
                                        news.imageSrc,
                                      ),
                                      fit: BoxFit.fill),
                                ),
                                child: Stack(
                                  children: [
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 3.0, sigmaY: 3.0),
                                      child: new Container(
                                        //you can change opacity with color here(I used black) for background.
                                        decoration: new BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.2)),
                                      ),
                                    ),*/
                                  (widget.news.type == "news")
                                      ? Image.network(
                                          widget.news.imageSrc ??
                                              "https://i.picsum.photos/id/42/200/300.jpg?hmac=RFAv_ervDAXQ4uM8dhocFa6_hkOkoBLeRR35gF8OHgs",
                                          height: screenSize.height * 177 / 640,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          frameBuilder: (BuildContext context,
                                              Widget child,
                                              int frame,
                                              bool wasSynchronouslyLoaded) {
                                            if (wasSynchronouslyLoaded) {
                                              return child;
                                            }
                                            return AnimatedOpacity(
                                              child: child,
                                              opacity: frame == null ? 0 : 1,
                                              duration:
                                                  const Duration(seconds: 1),
                                              curve: Curves.easeOut,
                                            );
                                          },
                                        )
                                      : Container(
                                          constraints:
                                              BoxConstraints(minHeight: 200),
                                          child: Image.network(
                                            //TODO: Update this hardcoded image
                                            widget.news.imageSrc ??
                                                "https://i.picsum.photos/id/42/200/300.jpg?hmac=RFAv_ervDAXQ4uM8dhocFa6_hkOkoBLeRR35gF8OHgs",
                                            width: double.infinity,
                                            fit: BoxFit.fitWidth,
                                            frameBuilder: (BuildContext context,
                                                Widget child,
                                                int frame,
                                                bool wasSynchronouslyLoaded) {
                                              if (wasSynchronouslyLoaded) {
                                                return child;
                                              }
                                              return AnimatedOpacity(
                                                child: child,
                                                opacity: frame == null ? 0 : 1,
                                                duration:
                                                    const Duration(seconds: 1),
                                                curve: Curves.easeOut,
                                              );
                                            },
                                          ),
                                        ),
                              /*],
                                ),
                              ),*/
                            ),
                            if (widget.news.type == "news")
                              Container(
                                height: screenSize.height * 177 / 640,
                                padding: EdgeInsets.only(right: 23, bottom: 11),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    widget.news.imageSourceName,
                                    style: TextStyle(
                                        color: Color(0xFFBDBDBD),
                                        fontSize: ScreenUtil().setSp(10,
                                            allowFontScalingSelf: true),
                                        letterSpacing: 0.12,
                                        height: 1.4),
                                  ),
                                ),
                              )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 17,
                            left: 17,
                            right: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (widget.news.type == "news")
                                Text(
                                  widget.news.headline,
                                  style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setSp(14, allowFontScalingSelf: true),
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                    letterSpacing: 0.16,
                                    wordSpacing: 1,
                                    color: Color(0xFF111111),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 7,
                                ),
                              if (widget.news.type == "news")
                                SizedBox(
                                  height: 14,
                                ),
                              if (widget.news.type == "news")
                                Text(
                                  widget.news.shortDesc,
                                  style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setSp(12, allowFontScalingSelf: true),
                                    letterSpacing: 0.14,
                                    wordSpacing: 1.2,
                                    height: 1.4,
                                    color: Color(0xFF1A101F),
                                  ),
                                ),
                              if (widget.news.type == "news")
                                SizedBox(
                                  height: 13,
                                ),
                              if (widget.news.type == "news")
                                Text(
                                  DateFormat.yMMMMd()
                                      .format(
                                          DateTime.parse(widget.news.storyDate))
                                      .toString(),
                                  style: TextStyle(
                                      color: Color(0xFFBDBDBD),
                                      fontSize: ScreenUtil().setSp(10,
                                          allowFontScalingSelf: true),
                                      letterSpacing: 0.12,
                                      height: 1.4),
                                ),
                              if (widget.news.type == "news")
                                SizedBox(
                                  height: 16,
                                ),
                              if (widget.news.type == "news")
                                Container(
                                  color: Color(0xFFBDBDBD),
                                  height: 0.5,
                                ),
                              if (widget.news.type == "news")
                                SizedBox(
                                  height: 8,
                                ),
                              if (widget.news.type == "news")
                                Text(
                                  "${widget.news.title}",
                                  style: TextStyle(
                                      color: Color(0xFF1A101F),
                                      fontSize: ScreenUtil().setSp(12,
                                          allowFontScalingSelf: true),
                                      letterSpacing: 0.14,
                                      height: 1.4),
                                ),
                              if (widget.news.type == "news")
                                SizedBox(
                                  height: 4,
                                ),
                              if (widget.news.type == "news")
                                InkWell(
                                  onTap: () {
                                    openWebView(context, widget.news.link);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 4.0, bottom: 4.0, top: 4.0),
                                    child: Text(
                                      "View Full Article",
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(12,
                                              allowFontScalingSelf: true),
                                          color: Color(0xFF63A375),
                                          letterSpacing: 0.14,
                                          height: 1.4),
                                    ),
                                  ),
                                ),
                              if (widget.news.type == "news")
                                SizedBox(
                                  height: 4,
                                ),
                              Container(
                                color: Color(0xFFBDBDBD),
                                height: 0.5,
                              ),
                              SizedBox(
                                height: 19,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      //Reporting functionality
                                      reportModalBottomSheet(
                                          context,
                                          widget.news.id,
                                          _singleStoryPageScaffoldKey);
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/flag_icon.png',
                                          height: 14.67,
                                          width: 11,
                                        ),
                                        SizedBox(
                                          height: 6.33,
                                        ),
                                        Text(
                                          "Report",
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(10,
                                                allowFontScalingSelf: true),
                                            height: 1.3,
                                            color: Color(0xFFBDBDBD),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      SharingRepository.shareNewsEvent(
                                          widget.news, context);
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/share_icon.png',
                                          height: 13,
                                          width: 13,
                                        ),
                                        SizedBox(
                                          height: 6.33,
                                        ),
                                        Text(
                                          "Share",
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(10,
                                                allowFontScalingSelf: true),
                                            height: 1.3,
                                            color: Color(0xFFBDBDBD),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      String alreadyLoggedIn =
                                          await getStringValuesSF("googleID") ??
                                              await getStringValuesSF(
                                                  "UserIDFirebaseAppleIdLogin");

                                      if (alreadyLoggedIn == null ||
                                          alreadyLoggedIn.isEmpty) {
                                        var response = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(
                                              pageScaffoldKey:
                                                  _singleStoryPageScaffoldKey,
                                            ),
                                          ),
                                        );
                                        widget.homePageState.bloc
                                            .fetchAllPosts();
                                      } else {
                                        if (!widget.news.bookmarked) {
                                          BookmarkRepository
                                              _bookmarkRepository =
                                              BookmarkRepository();
                                          await _bookmarkRepository
                                              .saveBookmark(widget.news);
                                          setState(() {
                                            widget.news.bookmarked = true;
                                          });
                                          widget.homePageState.bloc
                                              .fetchAllPosts(
                                                  bookmarkRemoved: true);
                                          _singleStoryPageScaffoldKey
                                              .currentState
                                              .showSnackBar(Constants
                                                  .showSuccessfulAddBookmarked());
                                        } else {
                                          //Remove saved bookmark
                                          final bookmarkBloc = BookmarkBloc();
                                          int result = await bookmarkBloc
                                              .deleteSelectedBookmark(
                                                  id: widget.news.id);
                                          widget.homePageState.bloc
                                              .fetchAllPosts(
                                                  bookmarkRemoved: true);
                                          setState(() {
                                            widget.news.bookmarked = false;
                                          });
                                          _singleStoryPageScaffoldKey
                                              .currentState
                                              .showSnackBar(Constants
                                                  .showSuccessfulRemoveBookmarked());
                                        }
                                      }
                                      widget.bookmarksPageState.bookmarkBloc
                                          .fetchAllSavedBookmarks();
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          widget.news.bookmarked
                                              ? "assets/images/bookmarked_story.png"
                                              : 'assets/images/ribbon_icon.png',
                                          height: 14.67,
                                          width: 11,
                                        ),
                                        SizedBox(
                                          height: 6.33,
                                        ),
                                        Text(
                                          "Bookmark",
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(10,
                                                allowFontScalingSelf: true),
                                            height: 1.3,
                                            color: Color(0xFFBDBDBD),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 9,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
