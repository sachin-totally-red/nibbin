import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nibbin_app/bloc/search_bloc.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:flutter/material.dart';
import 'package:nibbin_app/view/home_page.dart';
import 'package:nibbin_app/view/search_result.dart';

class CustomSearchDelegate extends SearchDelegate<Post> {
  final HomePage homePage;
  final HomePageState homePageState;
  CustomSearchDelegate({this.homePage, this.homePageState});

  final searchBloc = SearchBloc();
  final textFormFieldController = TextEditingController();
  final TextStyle suggestionTextStyle = TextStyle(
    letterSpacing: 0.14,
  );

  @override
  TextStyle get searchFieldStyle => TextStyle(
        color: Color(0xFF707070),
        fontSize: 12,
        letterSpacing: 0.14,
      );

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return super.appBarTheme(context).copyWith(
          cursorColor: Color(0xFF111111),
          appBarTheme: super
              .appBarTheme(context)
              .appBarTheme
              .copyWith(color: Colors.black12, elevation: 0.0),
          inputDecorationTheme:
              super.appBarTheme(context).inputDecorationTheme.copyWith(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        gapPadding: 10),
                  ),
        );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Container(
        margin: EdgeInsets.only(right: 18, bottom: 5),
        padding: EdgeInsets.only(left: 18, right: 18),
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        width: homePage.screenSize.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: homePage.screenSize.width * 0.1,
              child: IconButton(
                icon: Image.asset(
                  'assets/images/arrow_left_icon.png',
                  width: 8,
                  height: 15,
                ),
                onPressed: () {
                  close(context, null);
                },
              ),
            ),
            Container(
              width: homePage.screenSize.width * 0.45,
              child: TextFormField(
                autocorrect: false,
                controller: textFormFieldController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefix: SizedBox(
                    width: 12,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: Color(0xFF707070),
                    fontSize:
                        ScreenUtil().setSp(12, allowFontScalingSelf: true),
                    letterSpacing: 0.14,
                  ),
                ),
                onChanged: (value) {
                  query = value;
                },
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                query = '';
                textFormFieldController.text = "";
              },
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Container(
        /*color: Colors.white,
      width: double.infinity,
      child: IconButton(
        icon: Image.asset(
          'assets/images/arrow_left_icon.png',
          width: 8,
          height: 15,
        ),
        onPressed: () {
          close(context, null);
        },
      ),*/
        );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return predefinedSuggestions();
      /*return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );*/
    }

    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    //This is the equivalent of submitting the search term to whatever search service you are using
//    searchBloc.fetchAllSearchedNews(searchedText: query);

    else
      return prepareSearchResult();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    if (query == "") {
      return predefinedSuggestions();
    } else if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    } else {
      return prepareSearchResult();
    }
  }

  prepareSearchResult() {
    searchBloc.fetchAllSearchedNews(searchedText: query);
    print(query);
    return StreamBuilder(
      stream: searchBloc.searchedNews,
      builder: (context, AsyncSnapshot<List<Post>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              itemCount: snapshot.data.length,
              separatorBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                  ),
                  color: Color(0xFFBDBDBD),
                  child: SizedBox(
                    height: 0.5,
                  ),
                );
              },
              itemBuilder: (context, index) {
                return SearchedWidget(
                  searchedNews: snapshot.data[index],
                  customSearchDelegate: this,
                );
              },
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "No Search Result Found.\nTry with some other keywords!",
                  style: TextStyle(fontSize: 20, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Center(
            child: Text("No Data"),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  predefinedSuggestions() {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 21),
      child: ListView(
        children: [
          Text(
            "Explore topics",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF111111),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.16,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 18,
              left: 13,
            ),
            child: Wrap(
              direction: Axis.vertical,
              spacing: 22,
              children: [
                suggestionItem("Health IT"),
                suggestionItem("Research"),
                suggestionItem("Regulations"),
                suggestionItem("Technology"),
                suggestionItem("COVID-19"),
                suggestionItem("Tax"),
                suggestionItem("IT"),
              ],
            ),
          )
        ],
      ),
    );
  }

  InkWell suggestionItem(String suggestion) {
    return InkWell(
      child: Text(
        suggestion,
        style: suggestionTextStyle,
      ),
      onTap: () {
        query = suggestion;
        textFormFieldController.text = suggestion;
      },
    );
  }
}

class SearchedWidget extends StatelessWidget {
  final Post searchedNews;
  final CustomSearchDelegate customSearchDelegate;
  SearchedWidget({this.searchedNews, this.customSearchDelegate});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultPage(
              searchedWidget: this,
            ),
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(
            minHeight: ScreenUtil().setSp(80, allowFontScalingSelf: true)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(11.0))),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(11),
              ),
              child: Container(
                width: ScreenUtil().setSp(80, allowFontScalingSelf: true),
                height: ScreenUtil().setSp(80, allowFontScalingSelf: true),
                child: Image.network(
                  searchedNews.imageSrc ??
                      "https://i.picsum.photos/id/352/500/500.jpg?hmac=-E0Zo7evjUyTTEVC4YJW-pUDmGC2dMDxBvGZjWR7yv4",
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
                    searchedNews.title,
                    style: TextStyle(
                        color: Color(0xFF111111),
                        fontSize:
                            ScreenUtil().setSp(14, allowFontScalingSelf: true),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.14,
                        height: 1.5,
                        wordSpacing: 2),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(
                    height: ScreenUtil().setSp(6, allowFontScalingSelf: true),
                  ),
                  Text(
                    DateFormat.yMMMMd()
                        .format(DateTime.parse(searchedNews.storyDate))
                        .toString(),
                    style: TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontSize:
                            ScreenUtil().setSp(10, allowFontScalingSelf: true),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.12,
                        height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
