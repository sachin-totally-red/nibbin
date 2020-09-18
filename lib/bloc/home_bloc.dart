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

  Stream<List<Post>> get allPosts => _postsFetcher.stream;

  fetchAllPosts({int pageNumber = 1, bool bookmarkRemoved = false}) async {
    try {
      if (pageNumber == 1) postCompleteList = List<Post>();
      String alreadyLoggedIn = await getStringValuesSF("googleID");
      if (!bookmarkRemoved) {
        List<Post> postModel = await _repository.fetchAllPosts(pageNumber,
            selectedCategories: selectedCategoriesList);
        List<SavedBookmarks> bookmarkModel =
            await _bookmarkRepository.fetchAllSavedBookmarks();
        if (alreadyLoggedIn != null)
          postModel.forEach((post) {
            bookmarkModel.forEach((savedBookmark) {
              if (savedBookmark.postID == post.id) {
                post.bookmarked = true;
              }
            });
          });
        else
          postModel.forEach((post) {
            post.bookmarked = false;
          });
        postCompleteList.addAll(postModel);
      } else {
        List<SavedBookmarks> bookmarkModel =
            await _bookmarkRepository.fetchAllSavedBookmarks();
        if (alreadyLoggedIn != null)
          postCompleteList.forEach((post) {
            bookmarkModel.forEach((savedBookmark) {
              if (savedBookmark.postID == post.id) {
                post.bookmarked = true;
              } else
                post.bookmarked = false;
            });
          });
        else
          postCompleteList.forEach((post) {
            post.bookmarked = false;
          });
      }
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