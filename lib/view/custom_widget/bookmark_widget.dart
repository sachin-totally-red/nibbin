import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/view/bookmarks.dart';
import 'package:nibbin_app/view/home_page.dart';

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
    return Container(
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
                fit: BoxFit.fill,
              ),
            ),
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
                        int result = await bookmarksPageState.bookmarkBloc
                            .deleteSelectedBookmark(id: bookmark.postID);
                        if (result == 1) {
                          bookmarksPageState.scaffoldKey.currentState
                              .showSnackBar(Constants.showUndoSnackBar(
                                  bookmarksPageState, bookmark, homePageState));
                        }
                        await bookmarksPageState.bookmarkBloc
                            .fetchAllSavedBookmarks();
                        homePageState.bloc.fetchAllPosts(bookmarkRemoved: true);
                      },
                      child: Image.asset(
                        'assets/images/trash_icon.png',
                        height:
                            ScreenUtil().setSp(20, allowFontScalingSelf: true),
                        width:
                            ScreenUtil().setSp(20, allowFontScalingSelf: true),
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
    );
  }
}
