import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:nibbin_app/bloc/home_bloc.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/model/category.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/resource/home_repository.dart';
import 'package:nibbin_app/view/app_drawer.dart';
import 'package:nibbin_app/view/custom_widget/post_card_widget.dart';
import 'package:nibbin_app/view/custom_widget/post_finish_card.dart';
import 'package:nibbin_app/view/custom_widget/rate_us_card.dart';
import 'package:nibbin_app/view/custom_widget/web_view_page.dart';
import 'package:nibbin_app/view/push_notification/push_notification.dart';
import 'package:nibbin_app/view/search_content/custom_search_delegate.dart';
import 'package:nibbin_app/view/search_result.dart';

List<Post> postCompleteList = List<Post>();
int currentPageNumber = 1;
List<Category> selectedCategoriesList = List<Category>();

class HomePage extends StatefulWidget {
  final Size screenSize;
  final List<Category> selectedCategories;

  HomePage({@required this.screenSize, @required this.selectedCategories});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  HomePageState homePageState;
  final _homePageScaffoldKey = GlobalKey<ScaffoldState>();
  final bloc = HomeBloc();
  ScrollController controller;
  ScrollController _scrollController = ScrollController();

  void _scrollListener() async {
    print(controller.position.extentAfter);
    if (controller.position.extentAfter < 1000 &&
        controller.position.extentAfter > 500) {
      await bloc.fetchAllPosts(pageNumber: currentPageNumber++);
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
    PushNotificationsManager pushNotificationsManager =
        PushNotificationsManager();
    pushNotificationsManager.handleNotificationOnTapEvent(context);

    //Initializing App sharing package
    Constants.rateMyApp.init();
    //Assigning selected Categories to global level variable.
    selectedCategoriesList = widget.selectedCategories;

    controller = new ScrollController()..addListener(_scrollListener);
    bloc.fetchAllPosts();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    homePageState = this;

    return Container(
      color: Color(0xFF000000),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          key: _homePageScaffoldKey,
          drawer: AppDrawer(
              widget: widget,
              homePageScaffoldKey: _homePageScaffoldKey,
              homePageState: homePageState),
          body: NestedScrollView(
//            controller: controller,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  pinned: false,
                  floating: true,
                  snap: true,
                  centerTitle: true,
                  forceElevated: innerBoxIsScrolled,
                  title: Image.asset(
                    "assets/images/nibbin_logo_white.png",
                    width: widget.screenSize.width * 117 / 360,
                    height: widget.screenSize.height * 42 / 640,
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: ImageIcon(
                        AssetImage(
                          "assets/images/search_icon.png",
                        ),
                      ),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(
                              homePage: widget, homePageState: homePageState),
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
              child: StreamBuilder(
                stream: bloc.allPosts,
                builder: (context, AsyncSnapshot<List<Post>> snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      controller: controller,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length + 1,
                          itemBuilder: (context, int index) {
                            if (index < snapshot.data.length) {
                              if (snapshot.data[index].type == "news") {
                                return PostCard(
                                    homePage: widget,
                                    post: snapshot.data[index],
                                    homePageState: homePageState,
                                    homePageScaffoldKey: _homePageScaffoldKey);
                              } else if (snapshot.data[index].type ==
                                  "newsConsumed") {
                                return NoPostLeftCard(widget: widget);
                              }
                              return RateUsCard(widget: widget);
                            } else {
                              return Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
                          }),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      height: widget.screenSize.height * 0.8,
                      child: Center(
                        child: Text(
                          snapshot.error.toString(),
                          style: TextStyle(color: Color(0xFFFFFFFF)),
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
    );
  }
}

void openWebView(BuildContext context, String link) {
  showModalBottomSheet(
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
