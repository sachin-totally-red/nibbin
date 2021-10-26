import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/resource/bookmark_repository.dart';
import 'package:nibbin_app/view/bookmarks.dart';
import 'package:rxdart/rxdart.dart';

class BookmarkBloc {
  final _bookmarkRepository = BookmarkRepository();
  final _bookmarkFetcher = PublishSubject<List<SavedBookmarks>>();
  final _graphicsBookmarkFetcher = PublishSubject<List<SavedBookmarks>>();
  final _bookmarkDeleter = PublishSubject<int>();

  Stream<List<SavedBookmarks>> get allBookmarks => _bookmarkFetcher.stream;
  Stream<List<SavedBookmarks>> get allGraphicsBookmarks =>
      _graphicsBookmarkFetcher.stream;
  Stream<int> get deleteBookmark => _bookmarkDeleter.stream;

  fetchAllSavedBookmarks(
      {BookmarksPageState
          bookmarksPageState /*, String cardType = "news"*/}) async {
    try {
      List<SavedBookmarks> bookmarkModel = await _bookmarkRepository
          .fetchAllSavedBookmarks(/*cardType: cardType*/);
      _bookmarkFetcher.sink.add(bookmarkModel);
      if (bookmarksPageState != null) {
        bookmarksPageState.setState(() {});
      }
    } catch (e) {
      print(e.toString());
      _bookmarkFetcher.sink.addError(Constants.connectionError);
    }
  }

  /*fetchAllSavedGraphicsBookmarks(
      {BookmarksPageState bookmarksPageState, String cardType = "news"}) async {
    try {
      List<SavedBookmarks> bookmarkModel =
          await _bookmarkRepository.fetchAllSavedBookmarks(cardType: cardType);
      _graphicsBookmarkFetcher.sink.add(bookmarkModel);
      if (bookmarksPageState != null) {
        bookmarksPageState.setState(() {});
      }
    } catch (e) {
      print(e.toString());
      _graphicsBookmarkFetcher.sink.addError(Constants.connectionError);
    }
  }*/

  deleteSelectedBookmark({int id}) async {
    try {
      int result = await _bookmarkRepository.deleteBookmark(id);
      _bookmarkDeleter.sink.add(result);
      return result;
    } catch (e) {
      print(e.toString());
      _bookmarkDeleter.sink.addError(Constants.connectionError);
    }
  }

  restoreDeletedBookmark(BookmarksPageState bookmarksPageState,
      SavedBookmarks savedBookmarks) async {
    try {
      int result = await _bookmarkRepository.restoreBookmark(savedBookmarks);
      fetchAllSavedBookmarks();
    } catch (e) {
      print(e.toString());
    }
  }

  dispose() {
    _bookmarkFetcher.close();
    _bookmarkDeleter.close();
    _graphicsBookmarkFetcher.close();
  }
}
