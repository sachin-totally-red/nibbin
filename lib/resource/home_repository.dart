import 'package:nibbin_app/model/category.dart';
import 'package:nibbin_app/model/post.dart';
import 'api_handler.dart';

class HomeRepository {
  APIHandler _apiHandler = APIHandler();

  Future fetchAllPosts(int pageNumber,
      {List<Category> selectedCategories}) async {
    Map response = await _apiHandler
        .getAPICall("news?page=$pageNumber?categories=$selectedCategories");
    List<Post> postList =
        response["rows"].map<Post>((i) => Post.fromJson(i)).toList();
    for (int i = 1; i < postList.length - 1; i++) {
      if ((DateTime.parse(postList[i].storyDate) == DateTime.now()) &&
          (DateTime.parse(postList[i].storyDate)
                  .difference((DateTime.parse(postList[i - 1].storyDate)))
                  .inDays ==
              1)) {
        postList.insert(i, Post(type: "newsConsumed"));
        return;
      }
    }
    return postList;
  }

  Future fetchSingleNews(int newsId) async {
    Map response = await _apiHandler.getAPICall("news/$newsId");
    Post news = Post.fromJson(response);
    return news;
  }
}
