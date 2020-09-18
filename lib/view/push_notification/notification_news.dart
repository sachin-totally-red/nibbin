import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/view/home_page.dart';

class NotificationNewsPage extends StatelessWidget {
  final Post news;

  NotificationNewsPage({
    this.news,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      color: Color(0xFF000000),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Color(0xFF1A101F),
          appBar: AppBar(
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
          body: Container(
            color: Color(0xFF1A101F),
            child: SingleChildScrollView(
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
                              child: Image.network(
                                news.imageSrc ??
                                    "https://i.picsum.photos/id/352/500/500.jpg?hmac=-E0Zo7evjUyTTEVC4YJW-pUDmGC2dMDxBvGZjWR7yv4",
                                height: screenSize.height * 177 / 640,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              height: screenSize.height * 177 / 640,
                              padding: EdgeInsets.only(right: 23, bottom: 11),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  news.id.toString(),
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
                              Text(
                                news.title,
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
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 14,
                              ),
                              Text(
                                news.shortDesc,
                                style: TextStyle(
                                  fontSize: ScreenUtil()
                                      .setSp(12, allowFontScalingSelf: true),
                                  letterSpacing: 0.14,
                                  wordSpacing: 1.2,
                                  height: 1.4,
                                  color: Color(0xFF1A101F),
                                ),
                              ),
                              SizedBox(
                                height: 13,
                              ),
                              Text(
                                DateFormat.yMMMMd()
                                    .format(DateTime.parse(news.storyDate))
                                    .toString(),
                                style: TextStyle(
                                    color: Color(0xFFBDBDBD),
                                    fontSize: ScreenUtil()
                                        .setSp(10, allowFontScalingSelf: true),
                                    letterSpacing: 0.12,
                                    height: 1.4),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                color: Color(0xFFBDBDBD),
                                height: 0.5,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "${news.headline} at ${DateFormat.jm().format(DateTime.parse(news.storyDate))}",
                                style: TextStyle(
                                    color: Color(0xFF1A101F),
                                    fontSize: ScreenUtil()
                                        .setSp(12, allowFontScalingSelf: true),
                                    letterSpacing: 0.14,
                                    height: 1.4),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              InkWell(
                                onTap: () {
                                  openWebView(context, news.link);
                                },
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
                              SizedBox(
                                height: 8,
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
                                      /*reportModalBottomSheet(
                                          context,
                                          widget.post.id,
                                          widget.homePageScaffoldKey);*/
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
                                    onTap: () async {
                                      //TODO: Sachin
/*
//                        var data = await FirebaseDynamicLinks.instance.getInitialLink();

                                      var parameters = DynamicLinkParameters(
                                        uriPrefix: 'https://bluone.page.link',
                                        link: Uri.parse(
                                            'https://test/welcome?newsID=${widget.post.id.toString()}'),
                                        androidParameters: AndroidParameters(
                                          packageName: "in.bluone.app.nibbin",
                                        ),
                                        iosParameters: IosParameters(
                                          bundleId: "in.bluone.app.nibbin",
                                          appStoreId: '1498909115',
                                        ),
                                      );
                                      var dynamicUrl =
                                          await parameters.buildUrl();
//                        var shortLink = await parameters.buildShortLink();
//                        var shortUrl = shortLink.shortUrl;

                                      print(dynamicUrl.toString());

                                      SharingRepository.shareOnTap(context,
                                          content:
                                              "Shared using Nibbin App $dynamicUrl");*/
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
                                      /* String alreadyLoggedIn =
                                          await getStringValuesSF("googleID");

                                      if (alreadyLoggedIn == null ||
                                          alreadyLoggedIn.isEmpty) {
                                        var response = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ),
                                        );
                                        widget.homePageState.bloc
                                            .fetchAllPosts();
                                      } else {
                                        BookmarkRepository _bookmarkRepository =
                                            BookmarkRepository();
                                        _bookmarkRepository
                                            .saveBookmark(widget.post);
                                        setState(() {
                                          widget.post.bookmarked = true;
                                        });
                                      }*/
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          news.bookmarked
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
