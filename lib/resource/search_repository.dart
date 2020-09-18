import 'package:nibbin_app/model/post.dart';
import 'api_handler.dart';

class SearchRepository {
  APIHandler _apiHandler = APIHandler();

  Future fetchSearchedNews(String searchedText) async {
    Map response = await _apiHandler.getAPICall("news?query=$searchedText");
    List<Post> postList =
        response["rows"].map<Post>((i) => Post.fromJson(i)).toList();
    return postList;
  }
}
