import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/common/shared_preference.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/resource/bookmark_repository.dart';
import 'package:nibbin_app/resource/home_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:nibbin_app/view/home_page.dart';

class HomeBloc {
  final _repository = HomeRepository();
  final _postsFetcher = PublishSubject<List<Post>>();
  final _bookmarkRepository = BookmarkRepository();
  int newNewsCount = 0;

  Stream<List<Post>> get allPosts => _postsFetcher.stream;

  fetchAllPosts({
    int pageNumber = 1,
    bool bookmarkRemoved = false,
  }) async {
    try {
      String alreadyLoggedIn = await getStringValuesSF("googleID") ??
          await getStringValuesSF("UserIDFirebaseAppleIdLogin");
      if (!bookmarkRemoved) {
        if (pageNumber == 1) {
          currentPageNumber = 1;
          allNewsFetched = false;
          postCompleteList = List<Post>();
        }
        List<Post> postModel = await _repository.fetchAllPosts(pageNumber,
            selectedCategories: selectedCategoriesList);
        List<SavedBookmarks> bookmarkModel =
            await _bookmarkRepository.fetchAllSavedBookmarks();
        if (postModel != null && postModel.length > 0) {
          if (alreadyLoggedIn != null)
            postModel.forEach((post) {
              int index = bookmarkModel
                  .indexWhere((element) => element.postID == post.id);
              if (index != -1) post.bookmarked = true;
              /*bookmarkModel.forEach((savedBookmark) {
              if (savedBookmark.postID == post.id) {
                post.bookmarked = true;
              }
            });*/
            });
          else
            postModel.forEach((post) {
              post.bookmarked = false;
            });
          //TODO: Checking if some news added in this session
          if (postCompleteList
                  .indexWhere((post) => (post.id == postModel[0].id)) !=
              -1) {
            newNewsCount = 1;
            for (int i = 1; i <= postModel.length - 1; i--) {
              if (postCompleteList
                      .indexWhere((post) => (post.id == postModel[0].id)) !=
                  -1) {
                newNewsCount++;
              } else
                return;
            }
          }
        }

        if (newNewsCount > 0) {
          List<Post> newPosts = await _repository.fetchAllPosts(1,
              selectedCategories: selectedCategoriesList);
          newPosts.removeRange(newNewsCount, newPosts.length);
          postCompleteList.insertAll(0, newPosts);
        }
        postCompleteList.addAll(postModel);
      } else {
        List<SavedBookmarks> bookmarkModel =
            await _bookmarkRepository.fetchAllSavedBookmarks();
        if (alreadyLoggedIn != null) {
          postCompleteList.forEach((post) {
            int index = bookmarkModel
                .indexWhere((element) => element.postID == post.id);
            if (index != -1)
              post.bookmarked = true;
            else
              post.bookmarked = false;
//            bookmarkModel.forEach((savedBookmark) {
//              if (savedBookmark.postID == post.id) {
//                post.bookmarked = true;
//              } else
//                post.bookmarked = false;
//            });
          });
        } else
          postCompleteList.forEach((post) {
            post.bookmarked = false;
          });
      }

      //Add Graphics cards now....
      /*if (!bookmarkRemoved)
        postCompleteList =
            await _repository.mixGraphicCardsWithNews(postCompleteList);*/

      _postsFetcher.sink.add(postCompleteList);
    } catch (e) {
      print(e.toString());
      _postsFetcher.sink.addError(Constants.connectionError);
    }
  }

  dispose() {
    _postsFetcher.close();
  }
}
