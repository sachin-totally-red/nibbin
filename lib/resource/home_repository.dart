import 'package:intl/intl.dart';
import 'package:nibbin_app/model/category.dart';
import 'package:nibbin_app/model/post.dart';
import 'api_handler.dart';

class HomeRepository {
  APIHandler _apiHandler = APIHandler();

  Future fetchAllPosts(int pageNumber,
      {List<Category> selectedCategories}) async {
    try {
      Map response = await _apiHandler
          .getAPICall("news?page=$pageNumber?categories=$selectedCategories");
      List<Post> postList =
          response["rows"].map<Post>((i) => Post.fromJson(i)).toList();
      for (int i = 0; i < postList.length - 2; i++) {
        if ((DateFormat.yMMMMd()
                    .format(DateTime.parse(postList[i].storyDate)) ==
                DateFormat.yMMMMd().format(DateTime.now())) &&
            ((DateTime.parse(postList[i].storyDate)
                        .difference((DateTime.parse(postList[i + 1].storyDate)))
                        .inDays >
                    0) ||
                (DateTime.parse(postList[i].storyDate).day -
                        DateTime.parse(postList[i + 1].storyDate).day >
                    0))) {
          postList.insert(i + 1, Post(type: "newsConsumed"));
          break;
        }
      }
      return postList;
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchSingleNews(int newsId) async {
    Map response = await _apiHandler.getAPICall("news/$newsId");
    Post news = Post.fromJson(response);
    return news;
  }
}
