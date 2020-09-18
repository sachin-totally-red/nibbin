import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nibbin_app/bloc/category_bloc.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/model/category.dart';
import 'package:nibbin_app/resource/category_repository.dart';
import 'package:nibbin_app/view/home_page.dart';

List<Category> selectedCategoryList = List<Category>();

class CategorySelectionPage extends StatefulWidget {
  final String appBarTitle;
  final bool userAlreadyLoggedIn;
  CategorySelectionPage(
      {@required this.appBarTitle, this.userAlreadyLoggedIn = false});
  @override
  _CategorySelectionPageState createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  final categoryBloc = CategoryBloc();
  final categoryPageScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    selectedCategoryList = List<Category>();
    categoryBloc.fetchAllCategories();
    super.initState();
  }

  @override
  void dispose() {
    categoryBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      color: Color(0xFF000000),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          key: categoryPageScaffoldKey,
          backgroundColor: Color(0xFF1A101F),
          appBar: (widget.appBarTitle != null)
              ? AppBar(
                  centerTitle: false,
                  elevation: 0,
                  title: Text(
                    widget.appBarTitle,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                )
              : null,
          body: Container(
            padding: const EdgeInsets.only(bottom: 35.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (widget.appBarTitle != null)
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
                        : Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              top: 21,
                              bottom: 21,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "What are your Interests?",
                                  style: TextStyle(
                                    color: Color(0xFFF8F8F8),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "Select a few things you like",
                                  style: TextStyle(
                                    color: Color(0xFFF8F8F8),
                                    fontSize: 14,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    StreamBuilder(
                        stream: categoryBloc.allCategories,
                        builder:
                            (context, AsyncSnapshot<List<Category>> snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              height: screenSize.height * 0.65,
                              child: GridView.count(
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                crossAxisCount: 2,
                                childAspectRatio: 1.2,
                                children: List.generate(snapshot.data.length,
                                    (index) {
                                  return CategoryCard(
                                      category: snapshot.data[index]);
                                }),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Container(
                              height: screenSize.height * 0.65,
                              child: Center(
                                child: Text(
                                  snapshot.error.toString(),
                                  style: TextStyle(color: Color(0xFFFFFFFF)),
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
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ButtonTheme(
                      height: 35,
                      minWidth: 72,
                      child: RaisedButton(
                        child: Text(
                          "Done",
                        ),
                        textColor: Color(0xFF1A101F),
                        onPressed: () async {
                          /*if (selectedCategoryList.length > 2) {*/
                          CategoryRepository _categoryRepository =
                              CategoryRepository();
                          await _categoryRepository
                              .saveSelectedCategories(selectedCategoryList);
                          if (widget.userAlreadyLoggedIn)
                            await _categoryRepository.saveCategoriesToApi(
                                categoryList: selectedCategoryList);

                          //Update firebase with selected categories
                          final fireStoreDBRef = FirebaseFirestore.instance;
                          final FirebaseMessaging _firebaseMessaging =
                              FirebaseMessaging();
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

                          await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                screenSize: MediaQuery.of(context).size,
                                selectedCategories: selectedCategoryList,
                              ),
                            ),
                          );
                          /* } else {
                            categoryPageScaffoldKey.currentState.showSnackBar(
                                Constants.showCategorySelectionLimitError());
                          }*/
                        },
                        color: Color(0xFFFFFFFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatefulWidget {
  final Category category;

  CategoryCard({this.category});

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
      },
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
            color: backgroundColor,
            child: SingleChildScrollView(
              child: Container(
                margin:
                    EdgeInsets.only(top: 12, left: 16, bottom: 12, right: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.category.name,
                      style: TextStyle(
                        color: titleColor,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      widget.category.description,
                      style: Constants.privacyContextStyle
                          .copyWith(color: descColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.category.alreadySelected)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.only(top: 4, right: 4),
                child: Image.asset(
                  'assets/images/category_rectangle_corner.png',
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
