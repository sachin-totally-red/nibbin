import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nibbin_app/bloc/category_bloc.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/model/category.dart';
import 'package:nibbin_app/resource/category_repository.dart';
import 'package:nibbin_app/view/custom_widget/progress_indicator.dart';
import 'package:nibbin_app/view/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nibbin_app/resource/amplitude_repository.dart';

List<Category> selectedCategoryList = List<Category>();

class CategorySelectionPage extends StatefulWidget {
  final String appBarTitle;
  final bool userAlreadyLoggedIn;
  CategorySelectionPage(
      {@required this.appBarTitle, this.userAlreadyLoggedIn = false});
  @override
  CategorySelectionPageState createState() => CategorySelectionPageState();
}

class CategorySelectionPageState extends State<CategorySelectionPage> {
  final categoryBloc = CategoryBloc();
  final categoryPageScaffoldKey = GlobalKey<ScaffoldState>();
  /*final _amplitudeRepository = AmplitudeRepository();*/
  bool showLoader = false;
  CategorySelectionPageState _categorySelectionPageState;

  @override
  void initState() {
    selectedCategoryList = List<Category>();
    categoryBloc.fetchAllCategories();
    /*if (widget.appBarTitle == null) _amplitudeRepository.trackNewUser();*/
    super.initState();
  }

  @override
  void dispose() {
    categoryBloc.dispose();
    super.dispose();
  }

  onButtonPressed() async {
    try {
      if (selectedCategoryList.length > 2) {
        setState(() {
          showLoader = true;
        });
        CategoryRepository _categoryRepository = CategoryRepository();
        await _categoryRepository.saveSelectedCategories(selectedCategoryList);
        if (widget.userAlreadyLoggedIn)
          await _categoryRepository.saveCategoriesToApi(
              categoryList: selectedCategoryList);

        //Update firebase with selected categories
        await Firebase.initializeApp();
        final fireStoreDBRef = FirebaseFirestore.instance;
        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
        String token = await _firebaseMessaging.getToken();
        List<int> categoriesList = List<int>();
        selectedCategoryList.forEach((element) {
          categoriesList.add(element.id);
        });
        await fireStoreDBRef
            .collection("pushtokens")
            .where('devtoken', isEqualTo: token)
            .get()
            .then((value) async {
          if (value.size > 0)
            await fireStoreDBRef
                .collection("pushtokens")
                .doc(value.docs.first.id)
                .update({"categories": categoriesList});
        });

        setState(() {
          showLoader = false;
        });

        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              screenSize: MediaQuery.of(context).size,
              selectedCategories: selectedCategoryList,
            ),
          ),
        );
      }
      /*else {
        categoryPageScaffoldKey.currentState
            .showSnackBar(Constants.showCategorySelectionLimitError());
      }*/
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    _categorySelectionPageState = this;
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      color: Color(0xFF000000),
      child: SafeArea(
        bottom: false,
        child: CustomProgressIndicator(
          inAsyncCall: showLoader,
          child: Scaffold(
            key: categoryPageScaffoldKey,
            backgroundColor: Color(0xFF1A101F),
            appBar: (widget.appBarTitle != null)
                ? AppBar(
                    centerTitle: false,
                    elevation: 0,
                    title: Text(
                      widget.appBarTitle,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    leading: IconButton(
                      icon: ImageIcon(
                        AssetImage(
                          "assets/images/back_arrow.png",
                        ),
                        size:
                            ScreenUtil().setSp(14, allowFontScalingSelf: true),
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                : null,
            body: Container(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*(widget.appBarTitle != null)
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  left: 46,
                                  top: 6,
                                  bottom: 29,
                                ),
                                child: Text(
                                  "Select or remove topics",
                                  style: TextStyle(
                                    color: Color(0xFFF8F8F8),
                                  ),
                                ),
                              )
                            :*/
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 21,
                            bottom: 21,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "What would you like to read?",
                                style: TextStyle(
                                  color: Color(0xFFF8F8F8),
                                  fontSize: ScreenUtil()
                                      .setSp(16, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.14,
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil()
                                    .setSp(6, allowFontScalingSelf: true),
                              ),
                              Text(
                                "Select at least three News Groups to continue.",
                                style: TextStyle(
                                  color: Color(0xFFF8F8F8),
                                  fontSize: ScreenUtil()
                                      .setSp(14, allowFontScalingSelf: true),
                                  letterSpacing: 0.14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        StreamBuilder(
                            stream: categoryBloc.allCategories,
                            builder: (context,
                                AsyncSnapshot<List<Category>> snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  color: Color(0xFF1A101F),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  height: screenSize.height * 0.75,
                                  child: GridView.count(
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    crossAxisCount: 2,
                                    childAspectRatio: 1.1,
                                    children: List.generate(
                                        snapshot.data.length, (index) {
                                      return CategoryCard(
                                        category: snapshot.data[index],
                                        categorySelectionPageState:
                                            _categorySelectionPageState,
                                      );
                                    }),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Container(
                                  height: screenSize.height * 0.65,
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
                                          style: TextStyle(
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                height: screenSize.height * 0.65,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                  StreamBuilder(
                      stream: categoryBloc.allCategories,
                      builder:
                          (context, AsyncSnapshot<List<Category>> snapshot) {
                        if (snapshot.hasData) {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: ButtonTheme(
                              height: 35,
                              minWidth: 72,
                              child: RaisedButton(
                                child: Text(
                                  "Done",
                                  style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setSp(14, allowFontScalingSelf: true),
                                  ),
                                ),
                                textColor: Color(0xFF1A101F),
                                onPressed: () {
                                  onButtonPressed();
                                },
                                color: (selectedCategoryList.length > 2)
                                    ? Color(0xFFFFFFFF)
                                    : Colors.grey.withOpacity(0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                          );
                        }
                        return Container();
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatefulWidget {
  final Category category;
  final CategorySelectionPageState categorySelectionPageState;

  CategoryCard({this.category, this.categorySelectionPageState});

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  Color backgroundColor = Color(0xFFFFFFFF);
  Color titleColor = Color(0xFF111111);
  Color descColor = Color(0xFF707070);

  @override
  void initState() {
    if (widget.category.alreadySelected) {
      backgroundColor = Color(0xFFF35F5F);
      titleColor = Color(0xFFF8F8F8);
      descColor = Color(0xFFF8F8F8);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.category.alreadySelected) {
          selectedCategoryList
              .removeWhere((element) => (element.id == widget.category.id));
          setState(() {
            backgroundColor = Color(0xFFFFFFFF);
            titleColor = Color(0xFF111111);
            descColor = Color(0xFF707070);
            widget.category.alreadySelected = false;
          });
        } else {
          selectedCategoryList.add(widget.category);
          setState(() {
            backgroundColor = Color(0xFFF35F5F);
            titleColor = Color(0xFFF8F8F8);
            descColor = Color(0xFFF8F8F8);
            widget.category.alreadySelected = true;
          });
        }
        widget.categorySelectionPageState.setState(() {});
      },
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setSp(0.5, allowFontScalingSelf: true),
            ),
            child: Card(
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
              color: backgroundColor,
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight:
                        ScreenUtil().setSp(118, allowFontScalingSelf: true),
                  ),
                  margin:
                      EdgeInsets.only(top: 12, left: 16, bottom: 12, right: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.category.name,
                        style: TextStyle(
                          color: titleColor,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil()
                              .setSp(14, allowFontScalingSelf: true),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        widget.category.description,
                        style: Constants.privacyContextStyle.copyWith(
                          color: descColor,
                          height: 1.5,
                          fontSize: ScreenUtil().setSp(
                            12,
                            allowFontScalingSelf: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (widget.category.alreadySelected)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black87.withOpacity(0.5),
                      spreadRadius: 0.1,
                      blurRadius: 15,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/white.png',
                  height: 24,
                  width: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
