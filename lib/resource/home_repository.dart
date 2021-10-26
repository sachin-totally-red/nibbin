// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:nibbin_app/model/category.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/view/home_page.dart';
import 'api_handler.dart';

class HomeRepository {
  APIHandler _apiHandler = APIHandler();

  Future fetchAllPosts(int pageNumber,
      {List<Category> selectedCategories}) async {
    try {
      String categoryIds = "";
      selectedCategories.forEach((element) {
        categoryIds += element.id.toString() + ",";
      });

      print("News request start : $pageNumber");
      Map response = await _apiHandler.getAPICall(
          "news?page=$pageNumber&categories=$categoryIds&html=true");

      print("News request end : $pageNumber");
      if (response != null && response["rows"] != null) {
        List<Post> postList =
            response["rows"].map<Post>((i) => Post.fromJson(i)).toList();

        /*totalNews = totalNews ?? response['total'];*/

        if (postList.length > 0) {
          for (int i = 0; i < postList.length - 2; i++) {
            if (postList[i].type != "graphics") {
              if ((DateFormat.yMMMMd()
                          .format(DateTime.parse(postList[i].storyDate)) ==
                      DateFormat.yMMMMd().format(DateTime.now())) &&
                  ((DateTime.parse(postList[i].storyDate)
                              .difference(
                                  (DateTime.parse(postList[i + 1].storyDate)))
                              .inDays >
                          0) ||
                      (DateTime.parse(postList[i].storyDate).day -
                              DateTime.parse(postList[i + 1].storyDate).day >
                          0))) {
                postList.insert(i + 1, Post(type: "newsConsumed"));
                break;
              }
            }
          }
        } else {
          allNewsFetched = true;
          postList.add(Post(type: "newsFinish"));
        }
        /*for (Post post in postList) {
        if (post.imageSrc != null) {
          var fetchedFile =
              await DefaultCacheManager().getSingleFile(post.imageSrc);
          post.imageSrc = fetchedFile.path;
        }
      }*/
        return postList;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchSingleNews(int newsId) async {
    Map response = await _apiHandler.getAPICall("news/$newsId");
    Post news = Post.fromJson(response);
    /*var fetchedFile = await DefaultCacheManager().getSingleFile(news.imageSrc);
    news.imageSrc = fetchedFile.path;*/
    return news;
  }

  /*Future fetchAllGraphicsCards({List<Category> selectedCategories}) async {
    try {
      String categoryIds = "";
      selectedCategories.forEach((element) {
        categoryIds += element.id.toString() + ",";
      });

      Map response =
          await _apiHandler.getAPICall("graphics?categories=$categoryIds");
      List<Post> postList =
          response["rows"].map<Post>((i) => Post.fromJson(i)).toList();

      if (response["settings"] != null) {
        newsCardCount = response["settings"]["newsCount"];
        graphicsCardCount = response["settings"]["graphicsCount"];
      }

      */ /*for (Post post in postList) {
        if (post.imageSrc != null) {
          var fetchedFile =
              await DefaultCacheManager().getSingleFile(post.imageSrc);
          post.imageSrc = fetchedFile.path;
        }
      }*/ /*
      return postList;
    } catch (e) {
      print(e.toString());
    }
  }

  Future mixGraphicCardsWithNews(postList) async {
    try {
      int count = 0;
      while (
          (((postList.length + remainingNewsCount) - (newsCardCount * count)) >=
                  newsCardCount) &&
              (graphicsCardList.length >= graphicAddingCounter)) {
        postCompleteList.insert(
            graphicAddingCounter * newsCardCount -
                remainingNewsCount +
                graphicAddingCounter -
                1,
            graphicsCardList[graphicAddingCounter - 1]);

        graphicAddingCounter++;
        count++;
      }
      return postList;
    } catch (e) {
      print(e.toString());
      return postList;
    }
  }*/
}
