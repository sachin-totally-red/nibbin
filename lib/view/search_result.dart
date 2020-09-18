import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/view/custom_widget/post_card_widget.dart';
import 'package:nibbin_app/view/home_page.dart';
import 'package:nibbin_app/view/search_content/custom_search_delegate.dart';

class SearchResultPage extends StatelessWidget {
  final SearchedWidget searchedWidget;
  final HomePage homePage;
  final HomePageState homePageState;
  final Post news;

  SearchResultPage({
    this.searchedWidget,
    this.homePage,
    this.homePageState,
    this.news,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF000000),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Color(0xFF1A101F),
          appBar: AppBar(
            centerTitle: true,
            title: Image.asset(
              "assets/images/nibbin_logo_white.png",
              width: ((homePage != null)
                      ? homePage.screenSize.width
                      : (searchedWidget
                          .customSearchDelegate.homePage.screenSize.width)) *
                  117 /
                  360,
              height: ((homePage != null)
                      ? homePage.screenSize.height
                      : (searchedWidget
                          .customSearchDelegate.homePage.screenSize.height)) *
                  42 /
                  640,
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
          body: Container(
            color: Color(0xFF1A101F),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PostCard(
                    homePage: homePage ??
                        searchedWidget.customSearchDelegate.homePage,
                    post: news ?? searchedWidget.searchedNews,
                    homePageState: homePageState ??
                        searchedWidget.customSearchDelegate.homePageState,
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
