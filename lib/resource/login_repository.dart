import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/common/shared_preference.dart';
import 'package:nibbin_app/model/category.dart';
import 'package:nibbin_app/resource/api_handler.dart';
import 'package:nibbin_app/resource/bookmark_repository.dart';
import 'package:nibbin_app/resource/category_repository.dart';

class LoginRepository {
  static Future signIn(
      {@required BuildContext context,
      @required Size screenSize,
      @required GlobalKey<ScaffoldState> scaffoldKey}) async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'profile',
          'email',
          /*'https://www.googleapis.com/auth/user.phonenumbers.read',
                            'https://www.googleapis.com/auth/user.birthday.read',
                            'https://www.googleapis.com/auth/user.gender.read',
                            'https://www.googleapis.com/auth/contacts.readonly'*/
        ],
      );
      _googleSignIn.signOut();
      final GoogleSignInAccount profile = await _googleSignIn.signIn();

      if (profile != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await profile.authentication;

        await addStringToSF("googleID", profile.id);

        APIHandler _apiHandler = APIHandler();
        Map response = await _apiHandler.postAPICall(
            endPointURL:
                "verify-token/${googleSignInAuthentication.idToken}?os=${Platform.isAndroid ? "android" : "ios"}");

        CategoryRepository _categoryRepository = CategoryRepository();
        if (response["token"] != null) {
          await addStringToSF('JWTToken', response["token"]);
          var result = await _apiHandler.getAPICall("user/profile");
          if (result != null) {
            if ((result[0] as Map)["categories"].length == 0) {
              CategoryRepository _categoryBloc = CategoryRepository();
              List<SavedCategories> savedBookmarks =
                  await _categoryBloc.fetchAllSavedCategories();
              //TODO: Sachin -- Saving Categories to API DB
              var response = await _categoryRepository.saveCategoriesToApi(
                  savedCategories: savedBookmarks);
              //TODO: Sachin -- Saved bookmarks to local DB received from (result[0] as Map)["bookmarks"]
              if (response["message"] != "set categories successfully")
                return false;
              DatabaseHelper helper = DatabaseHelper.instance;
              //Deleting already saved bookmarks
              int id = await helper.deleteAllDataOnTableName("bookmarks");
              BookmarkRepository bookmarkRepository = BookmarkRepository();
              ((result[0] as Map)["bookmarks"] as List).forEach((post) async {
                await bookmarkRepository.saveBookmark(post);
              });
            } else {
              //Update categories on local DB
              List<Category> categoriesList = ((result[0] as Map)["categories"])
                  .map<Category>((i) => Category.fromJson(i))
                  .toList();
              var response = await _categoryRepository
                  .saveSelectedCategories(categoriesList);
              print(response);
            }
            print(result);
          }
          return true;
        } else {
          scaffoldKey.currentState.showSnackBar(Constants.showSnackBar());
          return false;
        }
        Navigator.pop(context);
      } else
        return false;
    } catch (e) {
      scaffoldKey.currentState.showSnackBar(Constants.showSnackBar());
      print(e.toString());
      return false;
    }
  }
}
