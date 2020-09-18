import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nibbin_app/bloc/bookmark_bloc.dart';
import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/view/custom_widget/bookmark_widget.dart';
import 'package:nibbin_app/view/home_page.dart';

class BookmarksPage extends StatefulWidget {
  final HomePageState homePageState;

  BookmarksPage({this.homePageState});

  @override
  BookmarksPageState createState() => BookmarksPageState();
}

class BookmarksPageState extends State<BookmarksPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BookmarksPageState bookmarksPageState;
  final bookmarkBloc = BookmarkBloc();

  @override
  void initState() {
    bookmarkBloc.fetchAllSavedBookmarks();
    super.initState();
  }

  @override
  void dispose() {
    bookmarkBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bookmarksPageState = this;

    return Container(
      color: Color(0xFF000000),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Color(0xFF1A101F),
          appBar: AppBar(
            centerTitle: false,
            elevation: 0,
            title: Text(
              "Bookmarks",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
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
          ),
          body: StreamBuilder(
            stream: bookmarkBloc.allBookmarks,
            builder: (context, AsyncSnapshot<List<SavedBookmarks>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0)
                  return new ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, int index) {
                        return BookmarkWidget(
                            bookmark: snapshot.data[index],
                            bookmarksPageState: bookmarksPageState,
                            homePageState: widget.homePageState);
                      });
                else
                  return noSavedBookmarkWidget(context);
              } else if (snapshot.hasError) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: TextStyle(color: Color(0xFFFFFFFF)),
                    ),
                  ),
                );
              }
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

noSavedBookmarkWidget(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).size.height * 145 / 640,
      left: MediaQuery.of(context).size.width * 33 / 360,
    ),
    child: Container(
      child: Column(
        children: [
          Image.asset(
            'assets/images/no_saved_bookmark_icon.png',
            height: MediaQuery.of(context).size.height * 216 / 640,
            width: MediaQuery.of(context).size.width * 302 / 360,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Oh no! you don't have any bookmarks saved yet",
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 14,
              letterSpacing: 0.14,
            ),
          )
        ],
      ),
    ),
  );
}
