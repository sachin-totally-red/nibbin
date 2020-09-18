import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/view/bookmarks.dart';
import 'package:nibbin_app/view/home_page.dart';
import 'package:rate_my_app/rate_my_app.dart';

class Constants {
  /* static final String playStoreUrl =
      "https://play.google.com/store/apps/details?id=com.mirra.healthcare.compliance";
  static final String appStoreUrl =
      "https://apps.apple.com/us/app/facebook/id284882215";*/

  static String apiUrl = "https://console-api.bluone.in/";

  //ToDo: New App Changes start
  static const String connectionError =
      "Services are not reachable. Please try later";
  static const String appStoreUrl =
      "Install Nibbin app by clicking on https://bluone.page.link/download";
  static const String playStoreUrl =
      "Install Nibbin app by clicking on https://bluone.page.link/downloadApp";
  static const String termsConditionUrl =
      "https://nibb.in/terms-and-conditions";
  static const String privacyPolicyUrl = "https://nibb.in/privacy-policy";
  static final TextStyle privacyContextStyle = TextStyle(
      fontFamily: GoogleFonts.roboto().fontFamily,
      fontSize: 12,
      color: Color(0xFF1A101F),
      fontWeight: FontWeight.w400,
      height: 1.8,
      letterSpacing: 0.12,
      wordSpacing: 0.18);

  static final RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 3,
    minLaunches: 7,
    remindDays: 2,
    remindLaunches: 5,
/*    googlePlayIdentifier: 'fr.skyost.example',
    appStoreIdentifier: '1491556149',*/
  );
  //ToDo: New App Changes end

  static final sendReportFieldOutline = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
      color: Color(0xFFBDBDBD),
      width: 0.5,
    ),
  );
  static final sendErrorReportFieldOutline = sendReportFieldOutline.copyWith(
      borderSide: BorderSide(color: Color(0xFFE03B30)));

  static showSnackBar() {
    return SnackBar(
      backgroundColor: Color(0xFF101C66),
      content: Text('Oops! Something went wrong. Please try again.'),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }

  static showReportSuccessSnackBar() {
    return SnackBar(
      backgroundColor: Color(0xFF101C66),
      content: Text(
          'Selected news reported successfully!\nThanks for your feedback!'),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }

  static showUndoSnackBar(BookmarksPageState bookmarksPageState,
      SavedBookmarks savedBookmarks, HomePageState homePageState) {
    return SnackBar(
      backgroundColor: Color(0xFF40343c),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      content: Text(
        'Bookmark removed',
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          letterSpacing: 0.14,
          fontSize: 14,
        ),
      ),
      action: SnackBarAction(
        label: 'UNDO',
        textColor: Color(0xFFFFBA08),
        onPressed: () {
          // Some code to undo the change.
          bookmarksPageState.bookmarkBloc
              .restoreDeletedBookmark(bookmarksPageState, savedBookmarks);
          homePageState.bloc.fetchAllPosts();
        },
      ),
    );
  }

  /*static showCategorySelectionLimitError() {
    return SnackBar(
      backgroundColor: Color(0xFF40343c),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      content: Text(
        'Please choose minimum 3 categories to continue.',
        style: TextStyle(
          color: Color(0xFFE03B30),
          letterSpacing: 0.14,
          fontSize: 14,
        ),
      ),
      action: SnackBarAction(
        label: 'Close',
        textColor: Color(0xFFFFBA08),
        onPressed: () {},
      ),
    );
  }*/
}
