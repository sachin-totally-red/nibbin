import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/common/version_check.dart';
import 'package:nibbin_app/model/category.dart';
import 'package:nibbin_app/resource/category_repository.dart';
import 'package:nibbin_app/view/category_selection_page.dart';
import 'dart:async';
import 'package:nibbin_app/view/home_page.dart';
import 'package:nibbin_app/view/push_notification/push_notification.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime(context) async {
    //TODO: Below two lines are for push notification.
    PushNotificationsManager pushNotificationsManager =
        PushNotificationsManager();
    pushNotificationsManager.init(context);
    var _duration = Duration(seconds: 1);
    return Timer(_duration, navigationPage);
  }

  Future navigationPage() async {
    CategoryRepository _categoryRepository = CategoryRepository();
    List<SavedCategories> savedCategoriesList =
        await _categoryRepository.fetchAllSavedCategories();
    if (savedCategoriesList.length > 0) {
      List<Category> categoryList = List<Category>();
      savedCategoriesList.forEach((element) {
        categoryList.add(Category.convertToCategoryModel(element));
      });
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            screenSize: MediaQuery.of(context).size,
            selectedCategories: categoryList,
          ),
        ),
      );
    } else
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CategorySelectionPage(),
        ),
      );
  }

  @override
  void initState() {
    try {
      versionCheck(context).then((value) {
        if (value == "Success") {
          startTime(context);
        }
      });
    } catch (e) {
      print(e.toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: true);
    return Container(
      color: Color(0xFF000000),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/splash.gif',
                  height: MediaQuery.of(context).size.height * 77 / 640,
                  width: MediaQuery.of(context).size.width * 209 / 360,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
