import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nibbin_app/bloc/search_bloc.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/view/custom_widget/avatar_glow.dart';
import 'package:nibbin_app/view/home_page.dart';
import 'package:nibbin_app/view/search_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SearchNewsPage extends StatefulWidget {
  final HomePage homePage;
  final HomePageState homePageState;
  SearchNewsPage({this.homePage, this.homePageState});

  @override
  SearchNewsPageState createState() => SearchNewsPageState();
}

class SearchNewsPageState extends State<SearchNewsPage> {
  final searchBloc = SearchBloc();
  final textFormFieldController = TextEditingController();
  bool showSearchLoader = false;
  SearchNewsPageState _searchNewsPageState;
  //Speech to text
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  bool available = false;

  void _listen() async {
    try {
      if (!_isListening) {
        if (available) {
          setState(() {
            _isListening = true;
          });

          _speech.listen(
            onResult: (val) {
              setState(
                () {
                  _text = val.recognizedWords;
                  textFormFieldController.text = _text;
                  showSearchLoader = true;
                  print(_text);
                },
              );
              Future.delayed(Duration(seconds: 1), () {
                _speech.stop();
                searchBloc.fetchAllSearchedNews(
                  searchedText: _text,
                  searchNewsPageState: _searchNewsPageState,
                );
                setState(() {
                  _isListening = false;
                });
              });
            },
          );
        }
      } else {
        setState(() {
          _isListening = false;
        });
        _speech.stop();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _buildVoiceInput({VoidCallback onPressed}) => AvatarGlow(
        animate: _isListening,
        glowColor: _isListening ? Color(0xFF1A101F) : Colors.white,
        endRadius: 16.0,
        duration: const Duration(seconds: 2),
        repeatPauseDuration: const Duration(milliseconds: 200),
        repeat: true,
        child: IconButton(
          icon: ImageIcon(
            AssetImage("assets/images/mic.png"),
            size: ScreenUtil().setSp(16, allowFontScalingSelf: true),
            color: Color(0xFF707070),
          ),
          onPressed: onPressed,
        ),
      );

  initializeSpeechToText() async {
    available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
        debugLogging: true);
  }

  @override
  void initState() {
    _speech = stt.SpeechToText();
    initializeSpeechToText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _searchNewsPageState = this;
    return Container(
      color: Color(0xFF000000),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Color(0xFFFFFFFF),
          body: Column(
            children: [
              Container(
                height: ScreenUtil().setSp(38, allowFontScalingSelf: true),
                margin: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 6,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.all(Radius.circular(22.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/images/arrow_left_icon.png',
                        width: 8,
                        height: 15,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Container(
                        height:
                            ScreenUtil().setSp(38, allowFontScalingSelf: true),
                        child: TextFormField(
                          autocorrect: false,
                          controller: textFormFieldController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Search",
                            contentPadding:
                                EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 5.0),
                            hintStyle: TextStyle(
                              color: Color(0xFF707070),
                              fontSize: ScreenUtil()
                                  .setSp(12, allowFontScalingSelf: true),
                              letterSpacing: 0.14,
                            ),
                          ),
                          onChanged: (value) {
                            Future.delayed(Duration(milliseconds: 1000), () {
                              if (textFormFieldController.text == value) {
                                searchBloc.fetchAllSearchedNews(
                                  searchedText: value,
                                  searchNewsPageState: _searchNewsPageState,
                                );
                                setState(() {
                                  showSearchLoader = true;
                                });
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    _buildVoiceInput(
                      onPressed: _listen,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: StreamBuilder(
                  stream: searchBloc.searchedNews,
                  builder: (context, AsyncSnapshot<List<Post>> snapshot) {
                    if (textFormFieldController.text.length < 3)
                      return Container(
                        child: predefinedSuggestions(),
                      );
                    if (!showSearchLoader) {
                      if (snapshot.hasData) {
                        if (snapshot.data.length > 0) {
                          return ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 15),
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
                                searchNewsPage: this,
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "No Result Found",
                                style: TextStyle(
                                  fontSize: ScreenUtil()
                                      .setSp(14, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.14,
                                  height: 1.5,
                                  wordSpacing: 2,
                                  color: Color(0xFF333333),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Center(
                              child: Column(
                                children: [
                                  Image(
                                    image: AssetImage(
                                        "assets/images/maintenance_error_icon.png"),
                                  ),
                                  Text(
                                    Constants.connectionError,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Color(0xFFFFFFFF)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  predefinedSuggestions() {
    return Container(
      padding: EdgeInsets.only(
        left: ScreenUtil().setSp(26, allowFontScalingSelf: true),
        top: ScreenUtil().setSp(16, allowFontScalingSelf: true),
      ),
      child: Container(
        alignment: Alignment.topLeft,
        child: Wrap(
          direction: Axis.vertical,
          spacing: 18,
          children: [
            Text(
              "Explore topics",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                color: Color(0xFF111111),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.16,
              ),
            ),
            suggestionItem("Health IT"),
            suggestionItem("Research"),
            suggestionItem("Regulations"),
            suggestionItem("Technology"),
            suggestionItem("Tax"),
            suggestionItem("IT"),
          ],
        ),
      ),
    );
  }

  InkWell suggestionItem(String suggestion) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(top: 2, right: 4, bottom: 2),
        child: Text(
          suggestion,
          style: TextStyle(
            letterSpacing: 0.14,
            fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
          ),
        ),
      ),
      onTap: () {
        textFormFieldController.text = suggestion;
        searchBloc.fetchAllSearchedNews(
          searchedText: suggestion,
          searchNewsPageState: _searchNewsPageState,
        );
        setState(() {
          showSearchLoader = true;
        });
      },
    );
  }
}

class SearchedWidget extends StatelessWidget {
  final Post searchedNews;
  final SearchNewsPageState searchNewsPage;
  SearchedWidget({this.searchedNews, this.searchNewsPage});

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
                  searchedNews.imageSrc,
                  fit: BoxFit.cover,
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
            SizedBox(
              width: ScreenUtil().setSp(12, allowFontScalingSelf: true),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    searchedNews.headline,
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
