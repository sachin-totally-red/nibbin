import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/view/bookmarks.dart';
import 'package:nibbin_app/view/custom_widget/custom_snackbar.dart';
import 'package:nibbin_app/view/home_page.dart';
import 'package:rate_my_app/rate_my_app.dart';

class Constants {
  /* static final String playStoreUrl =
      "https://play.google.com/store/apps/details?id=com.mirra.healthcare.compliance";
  static final String appStoreUrl =
      "https://apps.apple.com/us/app/facebook/id284882215";*/

  // Create the instance for Amplitude
  static final Amplitude analytics =
      Amplitude.getInstance(/*instanceName: "project"*/);

  static final String appStoreLink =
      'https://itunes.apple.com/us/app/nibbin/id1532244186';
  static final String playStoreLink =
      'https://play.google.com/store/apps/details?id=in.bluone.app.nibbin';

  static String apiUrl =
      /*"https://8e228a39690c.ngrok.io/" */ "https://console-api.bluone.in/";

  //ToDo: New App Changes start
  static const String connectionError =
      "Oops. Seems like we are working on something while we shouldn’t be. BRB!"
      /*"Services are not reachable. Please try later"*/;
  static const String appStoreUrl =
      "Download Nibbin for short, crisp, and updated healthcare news https://bluone.page.link/download";
  static const String playStoreUrl =
      "Download Nibbin for short, crisp, and updated healthcare news https://bluone.page.link/downloadApp";
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
    minDays: 0,
    minLaunches: 0,
    remindDays: 0,
    remindLaunches: 0,
    googlePlayIdentifier: 'in.bluone.app.nibbin',
    appStoreIdentifier: '1532244186',
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
      backgroundColor: Color(0xFF40343c),
      margin: EdgeInsets.only(bottom: 40, left: 8, right: 8),
      content: Text(
        'Selected news reported successfully!\nThanks for your feedback!',
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          letterSpacing: 0.14,
          fontSize: 14,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
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
      margin: EdgeInsets.only(bottom: 40, left: 8, right: 8),
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
        textColor: Colors.white,
        onPressed: () {
          // Some code to undo the change.
          bookmarksPageState.bookmarkBloc
              .restoreDeletedBookmark(bookmarksPageState, savedBookmarks);
          homePageState.bloc.fetchAllPosts();
        },
      ),
    );
  }

  /*static showUndoGraphicsSnackBar(BookmarksPageState bookmarksPageState,
      SavedBookmarks savedBookmarks, HomePageState homePageState) {
    return SnackBar(
      margin: EdgeInsets.only(bottom: 40, left: 8, right: 8),
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
        textColor: Colors.white,
        onPressed: () async {
          final _bookmarkRepository = BookmarkRepository();
          int result =
              await _bookmarkRepository.restoreBookmark(savedBookmarks);
          await bookmarksPageState.bookmarkBloc
              .fetchAllSavedGraphicsBookmarks(cardType: 'graphics');
          homePageState.bloc.fetchAllPosts();
        },
      ),
    );
  }*/

  static showCategorySelectionLimitError() {
    return SnackBar(
      backgroundColor: Color(0xFF40343c),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      content: Text(
        'Minimum 3 groups are required to be selected before proceeding further.',
        style: TextStyle(
          color: Color(0xFFE03B30),
          letterSpacing: 0.14,
          fontSize: 14,
        ),
      ),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
  }

  static showNewNewsSnackBar({int newStoryCount, Function onPressed}) {
    return MySnack(
      backgroundColor: Color(0xFF3b313f),
      duration: Duration(seconds: 10),
      action: CustomSnackBarAction(
        label: '$newStoryCount unread stories',
        textColor: Color(0xFFFFFFFF),
        onPressed: onPressed,
      ),
    );
  }

  static showSuccessfulLogin() {
    return SnackBar(
      backgroundColor: Color(0xFF40343c),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      content: Text(
        'Log in successful! :)',
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 0.14,
          fontSize: 14,
        ),
      ),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
  }

  static showSuccessfulAddBookmarked() {
    return SnackBar(
      backgroundColor: Color(0xFF40343c),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      content: Text(
        'Saved to Bookmarks :)',
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 0.14,
          fontSize: 14,
        ),
      ),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
  }

  static showSuccessfulRemoveBookmarked() {
    return SnackBar(
      backgroundColor: Color(0xFF40343c),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      content: Text(
        'Bookmark removed. :/',
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 0.14,
          fontSize: 14,
        ),
      ),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
  }

  static showCustomSnackBar({String errorText, bool error = false}) {
    return SnackBar(
      backgroundColor: Color(0xFF40343c),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      content: Text(
        errorText,
        style: TextStyle(
          color: error ? Color(0xFFE03B30) : Color(0xFF63A375),
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
  }
}
