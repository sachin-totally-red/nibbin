import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/resource/bookmark_repository.dart';
import 'package:nibbin_app/view/bookmarks.dart';
import 'package:rxdart/rxdart.dart';

class BookmarkBloc {
  final _bookmarkRepository = BookmarkRepository();
  final _bookmarkFetcher = PublishSubject<List<SavedBookmarks>>();
  final _bookmarkDeleter = PublishSubject<int>();
  /*BehaviorSubject<List<SavedBookmarks>> _bookmarkFetcher =
      BehaviorSubject.seeded(List<SavedBookmarks>());*/

  Stream<List<SavedBookmarks>> get allBookmarks => _bookmarkFetcher.stream;
  Stream<int> get deleteBookmark => _bookmarkDeleter.stream;

  fetchAllSavedBookmarks() async {
    try {
      List<SavedBookmarks> bookmarkModel =
          await _bookmarkRepository.fetchAllSavedBookmarks();
      _bookmarkFetcher.sink.add(bookmarkModel);
    } catch (e) {
      print(e.toString());
      _bookmarkFetcher.sink.addError(Constants.connectionError);
    }
  }

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
//      _bookmarkDeleter.sink.addError(Constants.connectionError);
    }
  }

  dispose() {
    _bookmarkFetcher.close();
    _bookmarkDeleter.close();
  }
}
