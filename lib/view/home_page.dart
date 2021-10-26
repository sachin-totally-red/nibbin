import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nibbin_app/bloc/home_bloc.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/common/shared_preference.dart';
import 'package:nibbin_app/model/category.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/resource/bookmark_repository.dart';
import 'package:nibbin_app/resource/home_repository.dart';
import 'package:nibbin_app/view/app_drawer.dart';
import 'package:nibbin_app/view/custom_widget/graphics_card.dart';
import 'package:nibbin_app/view/custom_widget/post_card_widget.dart';
import 'package:nibbin_app/view/custom_widget/post_finish_card.dart';
import 'package:nibbin_app/view/custom_widget/progress_indicator.dart';
import 'package:nibbin_app/view/custom_widget/rate_us_card.dart';
import 'package:nibbin_app/view/custom_widget/web_view_page.dart';
import 'package:nibbin_app/view/push_notification/push_notification.dart';
import 'package:nibbin_app/view/search_content/search_news.dart';
import 'package:nibbin_app/view/search_result.dart';

List<Post> postCompleteList = List<Post>();
int currentPageNumber = 1;
List<Category> selectedCategoriesList = List<Category>();
HomePageState homePageState;
bool showLoader = false;
/*int totalNews;*/
bool allNewsFetched = false;
/*List<Post> graphicsCardList = List<Post>();
int graphicsCardCount = 0;
int newsCardCount = 0;
int remainingNewsCount = 0;
int graphicAddingCounter = 1;*/

class HomePage extends StatefulWidget {
  final Size screenSize;
  final List<Category> selectedCategories;

  HomePage({@required this.screenSize, @required this.selectedCategories});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _homePageScaffoldKey = GlobalKey<ScaffoldState>();
  final bloc = HomeBloc();
  ScrollController controller;
  ScrollController _scrollController = ScrollController();
  bool fetchNewData = true;
  String deviceToken = "";

  void fetchDeviceToken() async {
    deviceToken = await getStringValuesSF("DeviceToken");
  }

  void _scrollListener() async {
//    print(controller.position.extentAfter);

    if (((controller.position.extentAfter < 2500 &&
                controller.position.extentAfter > 2000) ||
            (controller.position.extentAfter == 0.0) ||
            (controller.position.maxScrollExtent < 2000 &&
                controller.position.extentAfter <
                    controller.position.maxScrollExtent * 0.5 &&
                controller.position.extentAfter >
                    controller.position.maxScrollExtent * 0.3)) &&
        fetchNewData) {
      if (!allNewsFetched) {
        fetchNewData = false;
        await bloc.fetchAllPosts(pageNumber: ++currentPageNumber);
        fetchNewData = true;
        print(currentPageNumber);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //Calling method of checking if request came via Deep linking
    if (state == AppLifecycleState.resumed) {
      initDynamicLinks(context, homePage: widget, homePageState: homePageState);
    }
  }

  @override
  void initState() {
    //Push Notification
    fetchDeviceToken();
    PushNotificationsManager pushNotificationsManager =
        PushNotificationsManager();
    pushNotificationsManager.handleNotificationOnTapEvent(context);

    //Initializing App sharing package
    Constants.rateMyApp.init();
    //Assigning selected Categories to global level variable.
    selectedCategoriesList = widget.selectedCategories;

    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    /*HomeRepository _homeRepository = HomeRepository();
    _homeRepository
        .fetchAllGraphicsCards(selectedCategories: selectedCategoriesList)
        .then((value) {
      graphicsCardList = value;*/
    bloc.fetchAllPosts();
    /*});*/
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    bloc.dispose();
    super.dispose();
  }

  Future<void> pullToRefreshHandling() async {
    postCompleteList = List<Post>();
    currentPageNumber = 1;
    showLoader = false;
    allNewsFetched = false;
    /*graphicsCardList = List<Post>();
    graphicsCardCount = 0;
    newsCardCount = 0;
    remainingNewsCount = 0;
    graphicAddingCounter = 1;*/

    /*HomeRepository _homeRepository = HomeRepository();*/
    /*return _homeRepository
        .fetchAllGraphicsCards(selectedCategories: selectedCategoriesList)
        .then((value) {
      graphicsCardList = value;*/
    await bloc.fetchAllPosts();
    /*});*/
  }

  @override
  Widget build(BuildContext context) {
    homePageState = this;

    return Container(
      color: Color(0xFF000000),
      child: SafeArea(
        bottom: false,
        child: CustomProgressIndicator(
          inAsyncCall: showLoader,
          child: Scaffold(
            key: _homePageScaffoldKey,
            drawer: AppDrawer(
                widget: widget,
                homePageScaffoldKey: _homePageScaffoldKey,
                homePageState: homePageState),
            body: NestedScrollView(
//              controller: controller,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    elevation: 0,
                    pinned: true, //Make it false for hiding
                    /*floating: false,
                    snap: false,*/

                    floating: true,
                    snap: true,
                    centerTitle: true,
                    forceElevated: innerBoxIsScrolled,
                    title: GestureDetector(
                      onTap: () {
                        controller.animateTo(
                          0.0,
                          curve: Curves.easeIn,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                      child: Image.asset(
                        "assets/images/nibbin_logo_white.png",
                        width: widget.screenSize.width * 117 / 360,
                        height: widget.screenSize.height * 42 / 640,
                      ),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: ImageIcon(
                          AssetImage(
                            "assets/images/search_icon.png",
                          ),
                          size: ScreenUtil()
                              .setSp(20, allowFontScalingSelf: true),
                        ),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchNewsPage(
                                  homePage: widget,
                                  homePageState: homePageState),
                            ),
                          );
                        },
                      )
                    ],
                    leading: Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: ImageIcon(
                            AssetImage("assets/images/menu.png"),
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          tooltip: MaterialLocalizations.of(context)
                              .openAppDrawerTooltip,
                        );
                      },
                    ),
                  ),
                ];
              },
              body: Container(
                color: Color(0xFF1A101F),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await pullToRefreshHandling();
                  },
                  child: StreamBuilder(
                    stream: bloc.allPosts,
                    builder: (context, AsyncSnapshot<List<Post>> snapshot) {
                      if (snapshot.hasData) {
                        if (bloc.newNewsCount > 0) {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) {
                              _homePageScaffoldKey.currentState.showSnackBar(
                                Constants.showNewNewsSnackBar(
                                  newStoryCount: bloc.newNewsCount,
                                  onPressed: () {
                                    controller.animateTo(
                                      0.0,
                                      curve: Curves.easeIn,
                                      duration:
                                          const Duration(milliseconds: 300),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }
                        return SingleChildScrollView(
                          controller: controller,
                          child: ListView /*PageView*/ .builder(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shrinkWrap: true,
//                      controller: controller,
//                          pageSnapping: false,
                              /*scrollDirection: Axis.horizontal,*/
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(top: 10),
                              /*physics: BouncingScrollPhysics(
                                        parent: AlwaysScrollableScrollPhysics()),*/
                              /*allowImplicitScrolling: true,
                              onPageChanged: (pageNumber) async {
                                if (pageNumber % 10 == 3) {
                                  await bloc.fetchAllPosts(
                                      pageNumber: ++currentPageNumber);
                                }
                              },*/
                              itemCount: snapshot.data.length +
                                  (allNewsFetched ? 0 : 1),
                              itemBuilder: (context, int index) {
                                if (index < snapshot.data.length) {
                                  if (snapshot.data[index].type == "news") {
                                    //TODO:SAchin- This need to remove
                                    return PostCard(
                                      homePage: widget,
                                      post: snapshot.data[index],
                                      homePageState: homePageState,
                                      homePageScaffoldKey: _homePageScaffoldKey,
                                      deviceToken: deviceToken,
                                      homePageWidget: true,
                                    );
                                  } else if (snapshot.data[index].type ==
                                      "newsConsumed") {
                                    return NoPostLeftCard(widget: widget);
                                  } else if (snapshot.data[index].type ==
                                      "graphics") {
                                    return GraphicsCard(
                                      homePage: widget,
                                      post: snapshot.data[index],
                                      homePageState: homePageState,
                                      homePageScaffoldKey: _homePageScaffoldKey,
                                      // deviceToken: deviceToken,  //This needs to be added if we want to track Graphics card data as well
                                      homePageWidget: true,
                                    );
                                    /*return GraphicsCard(
                                      post: snapshot.data[index],
                                    );*/
                                  } else if (snapshot.data[index].type ==
                                      "newsFinish") {
                                    return nibbinNewsFinishCard();
                                  }
                                  return RateUsCard(widget: widget);
                                } else {
                                  return Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }
                              }),
                        );
                      } else if (snapshot.hasError) {
                        return SingleChildScrollView(
                          child: Center(
                            child: Container(
                              height: widget.screenSize.height * 0.8,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Center(
                                child: Column(
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          "assets/images/maintenance_error_icon.png"),
                                    ),
                                    Text(
                                      snapshot.error.toString(),
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: Color(0xFFFFFFFF)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Container(
                        height: widget.screenSize.height * 0.8,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future openWebView(BuildContext context, String link) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (BuildContext bc) {
      return Container(
        color: Colors.transparent,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: WebViewPage(
          link: link,
        ),
      );
    },
  );
}

initDynamicLinks(BuildContext context,
    {HomePage homePage, HomePageState homePageState}) async {
  await Future.delayed(Duration(seconds: 3));
  var data = await FirebaseDynamicLinks.instance.getInitialLink();
  var deepLink = data?.link;
  if (deepLink != null) {
    final queryParams = deepLink.queryParameters;
    if (queryParams.length > 0) {
      var userName = queryParams['userId'];
    }
  }
  FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
    var deepLink = dynamicLink?.link;
    String newsID = deepLink.queryParameters["newsID"];
    if (newsID != null) {
      debugPrint('DynamicLinks onLink $deepLink');
      //Open that new news now..

      HomeRepository _homeRepository = HomeRepository();

      Post response = await _homeRepository.fetchSingleNews(int.parse(newsID));
      String alreadyLoggedIn = await getStringValuesSF("googleID") ??
          await getStringValuesSF("UserIDFirebaseAppleIdLogin");

      if (alreadyLoggedIn != null) {
        BookmarkRepository _bookmarkRepository = BookmarkRepository();
        List<SavedBookmarks> bookmarkModel =
            await _bookmarkRepository.fetchAllSavedBookmarks();
        int index = bookmarkModel
            .indexWhere((element) => element.postID == response.id);
        if (index != -1) {
          response.bookmarked = true;
        }
      }
      /*TrackDataRepository _trackDataRepository = TrackDataRepository();
      _trackDataRepository.trackNewsSharingConversionRecord(int.parse(newsID));*/

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultPage(
            homePage: homePage,
            homePageState: homePageState,
            news: response,
          ),
        ),
      );
    }
  }, onError: (e) async {
    debugPrint('DynamicLinks onError $e');
  });
}

nibbinNewsFinishCard() {
  return Container(
    height: 50,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    margin: EdgeInsets.only(bottom: 20),
    child: Center(
      child: Text(
        "Come back for more content soon!",
      ),
    ),
  );
}
