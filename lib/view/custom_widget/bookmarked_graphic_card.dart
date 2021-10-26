import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nibbin_app/bloc/bookmark_bloc.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/common/shared_preference.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/resource/bookmark_repository.dart';
import 'package:nibbin_app/resource/sharing.dart';
import 'package:nibbin_app/view/bookmarks.dart';
import 'package:nibbin_app/view/custom_widget/report_news.dart';
import 'package:nibbin_app/view/home_page.dart';
import 'package:nibbin_app/view/login_page.dart';
import 'package:nibbin_app/view/search_content/search_news.dart';

class BookmarkedGraphicsCard extends StatefulWidget {
  final SavedBookmarks bookmark;
  final HomePageState homePageState;
  final BookmarksPageState bookmarksPageState;
  final SavedBookmarks post;
  final SearchedWidget searchedWidget;
  final HomePage homePage;
  final GlobalKey<ScaffoldState> homePageScaffoldKey;
  final bool homePageWidget;

  BookmarkedGraphicsCard(
      {this.post,
      this.searchedWidget,
      this.homePage,
      this.homePageState,
      this.homePageScaffoldKey,
      this.homePageWidget,
      this.bookmark,
      this.bookmarksPageState});

  @override
  _BookmarkedGraphicsCardState createState() => _BookmarkedGraphicsCardState();
}

class _BookmarkedGraphicsCardState extends State<BookmarkedGraphicsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(
            width: 0.5,
            color: Color(0xFFED3029),
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Container(
                width: double.infinity,
                child: Image.network(
                  //TODO: Update this hardcoded image
                  widget.post.imageSrc ??
                      "https://i.picsum.photos/id/42/200/300.jpg?hmac=RFAv_ervDAXQ4uM8dhocFa6_hkOkoBLeRR35gF8OHgs",
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  frameBuilder: (BuildContext context, Widget child, int frame,
                      bool wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) {
                      return child;
                    }
                    return AnimatedOpacity(
                      child: child,
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeOut,
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: /*(widget.post.shortDesc != null) ? 17 :*/ 0,
                left: 17,
                right: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  /*Text(
                    widget.post.shortDesc ?? "",
                    style: TextStyle(
                      fontSize:
                      ScreenUtil().setSp(13.5, allowFontScalingSelf: true),
                      letterSpacing: 0.15,
                      height: 1.4,
                      color: Color(0xFF1A101F),
                    ),
                  ),
                  if (widget.post.shortDesc != null)
                    SizedBox(
                      height: 13,
                    ),*/
                  Container(
                    color: Color(0xFFBDBDBD),
                    height: 0.5,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      /*InkWell(
                        onTap: () {
                          //Reporting functionality
                          reportModalBottomSheet(context, widget.post.id,
                              widget.homePageScaffoldKey,
                              homePageWidget: true);
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
                                fontSize: ScreenUtil()
                                    .setSp(10, allowFontScalingSelf: true),
                                height: 1.3,
                                color: Color(0xFFBDBDBD),
                              ),
                            ),
                          ],
                        ),
                      ),*/
                      InkWell(
                        onTap: () {
                          Post _post = Post(
                              id: widget.post.postID,
                              type: widget.post.type,
                              shortDesc: "",
                              storyDate: widget.post.storyDate,
                              headline: "",
                              title: "",
                              imageSrc: widget.post.imageSrc,
                              newsCategories: List<NewsCategory>());

                          SharingRepository.shareNewsEvent(_post, context);
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
                                fontSize: ScreenUtil()
                                    .setSp(10, allowFontScalingSelf: true),
                                height: 1.3,
                                color: Color(0xFFBDBDBD),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          widget.bookmarksPageState.setState(() {
                            widget.bookmarksPageState.showLoader = true;
                          });
                          int result = await widget
                              .bookmarksPageState.bookmarkBloc
                              .deleteSelectedBookmark(
                                  id: widget.bookmark.postID);
                          widget.bookmarksPageState.setState(() {
                            widget.bookmarksPageState.showLoader = false;
                          });
                          if (result == 1) {
                            widget.bookmarksPageState.scaffoldKey.currentState
                                .showSnackBar(Constants.showUndoSnackBar(
                                    widget.bookmarksPageState,
                                    widget.bookmark,
                                    homePageState));
                          }
                          await widget.bookmarksPageState.bookmarkBloc
                              .fetchAllSavedBookmarks(
                                  /*cardType: "graphics"*/);
                          homePageState.bloc
                              .fetchAllPosts(bookmarkRemoved: true);
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              /*widget.post.bookmarked
                                  ? */
                              "assets/images/bookmarked_story.png"
                              /*: 'assets/images/ribbon_icon.png'*/,
                              height: 14.67,
                              width: 11,
                            ),
                            SizedBox(
                              height: 6.33,
                            ),
                            Text(
                              "Bookmark",
                              style: TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(10, allowFontScalingSelf: true),
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
            /*SizedBox(
              height: 16,
            ),*/
          ],
        ),
      ),
    );
  }
}
