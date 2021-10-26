import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/resource/home_repository.dart';
import 'package:nibbin_app/view/bookmarks.dart';
import 'package:nibbin_app/view/home_page.dart';
import 'package:nibbin_app/view/push_notification/notification_news.dart';

class BookmarkWidget extends StatelessWidget {
  final SavedBookmarks bookmark;
  final BookmarksPageState bookmarksPageState;
  final HomePageState homePageState;

  BookmarkWidget({
    @required this.bookmark,
    @required this.bookmarksPageState,
    @required this.homePageState,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        bookmarksPageState.setState(() {
          bookmarksPageState.showLoader = true;
        });
        HomeRepository _homeRepository = HomeRepository();
        Post response = await _homeRepository.fetchSingleNews(bookmark.postID);
        response.bookmarked = true;
        bookmarksPageState.setState(() {
          bookmarksPageState.showLoader = false;
        });
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationNewsPage(
                news: response,
                homePageState: homePageState,
                bookmarksPageState: bookmarksPageState),
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(
          minHeight: ScreenUtil().setSp(80, allowFontScalingSelf: true),
        ),
        decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(11.0))),
        margin: EdgeInsets.all(15),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(11),
                bottomLeft: Radius.circular(11),
              ),
              child: Container(
                  width: ScreenUtil().setSp(80, allowFontScalingSelf: true),
                  height: ScreenUtil().setSp(80, allowFontScalingSelf: true),
                  child: Image.network(
                    bookmark.imageSrc,
                    fit: BoxFit.cover,
                    frameBuilder: (BuildContext context, Widget child,
                        int frame, bool wasSynchronouslyLoaded) {
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
                  )),
            ),
            SizedBox(
              width: ScreenUtil().setSp(12, allowFontScalingSelf: true),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookmark.title,
                    style: TextStyle(
                        color: Color(0xFF111111),
                        fontSize:
                            ScreenUtil().setSp(14, allowFontScalingSelf: true),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.14,
                        height: 1.4,
                        wordSpacing: 1),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(
                    height: ScreenUtil().setSp(6, allowFontScalingSelf: true),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat.yMMMMd()
                            .format(DateTime.parse(bookmark.storyDate))
                            .toString(),
                        style: TextStyle(
                            color: Color(0xFFBDBDBD),
                            fontSize: ScreenUtil()
                                .setSp(10, allowFontScalingSelf: true),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.12,
                            height: 1.4),
                      ),
                      InkWell(
                        onTap: () async {
                          bookmarksPageState.setState(() {
                            bookmarksPageState.showLoader = true;
                          });
                          int result = await bookmarksPageState.bookmarkBloc
                              .deleteSelectedBookmark(id: bookmark.postID);
                          bookmarksPageState.setState(() {
                            bookmarksPageState.showLoader = false;
                          });
                          if (result == 1) {
                            bookmarksPageState.scaffoldKey.currentState
                                .showSnackBar(Constants.showUndoSnackBar(
                                    bookmarksPageState,
                                    bookmark,
                                    homePageState));
                          }
                          await bookmarksPageState.bookmarkBloc
                              .fetchAllSavedBookmarks();
                          homePageState.bloc
                              .fetchAllPosts(bookmarkRemoved: true);
                        },
                        child: Image.asset(
                          'assets/images/delete_icon.png',
                          height: ScreenUtil()
                              .setSp(28, allowFontScalingSelf: true),
                          width: ScreenUtil()
                              .setSp(28, allowFontScalingSelf: true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: ScreenUtil().setSp(8, allowFontScalingSelf: true),
            ),
          ],
        ),
      ),
    );
  }
}
