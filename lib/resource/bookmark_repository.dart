import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/resource/api_handler.dart';

class BookmarkRepository {
  APIHandler _apiHandler = APIHandler();

  Future fetchAllSavedBookmarks() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    var maps = await helper.queryAllDataOnTableName(tableBookmarks);
    List<SavedBookmarks> savedBookmarks = List<SavedBookmarks>();
    if (maps.length > 0) {
      savedBookmarks =
          maps.map<SavedBookmarks>((i) => SavedBookmarks.fromMap(i)).toList();
    }
    return savedBookmarks;
  }

  Future saveBookmark(Post _post) async {
    try {
      Map response = await _apiHandler.postAPICall(
          endPointURL: "addbookmark", apiInputParameters: {"newsId": _post.id});
      if (response["message"] == "updated bookmarks successfully") {
        SavedBookmarks savedBookmarks = SavedBookmarks(
          postID: _post.id,
          imageSrc: _post.imageSrc ??
              "https://i.picsum.photos/id/352/500/500.jpg?hmac=-E0Zo7evjUyTTEVC4YJW-pUDmGC2dMDxBvGZjWR7yv4",
          title: _post.title,
          story: _post.shortDesc,
          link: _post.link,
          type: _post.type ?? "news",
          storyDate: _post.storyDate,
        );

        DatabaseHelper helper = DatabaseHelper.instance;
        int id = await helper.insert(
            tableName: tableBookmarks, tableData: savedBookmarks);
        print('inserted row ID : $id');
      }
    } catch (e) {
      if (e.toString().contains("UNIQUE constraint failed")) {
        print("Already add kar liya hai bhai");
      }
    }
  }

  Future deleteBookmark(int id) async {
    Map response = await _apiHandler.deleteAPICall("removebookmark/$id");
    if (response["message"] == "removed bookmarks successfully") {
      DatabaseHelper helper = DatabaseHelper.instance;
      int result = await helper.deleteBookmarks(
          id: id, tableName: tableBookmarks, columnName: columnPostID);
      return result;
    }
  }

  Future restoreBookmark(SavedBookmarks savedBookmarks) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int result = await helper.insert(
        tableName: tableBookmarks, tableData: savedBookmarks);
    return result;
  }
}
