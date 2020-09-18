import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/resource/search_repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  final _searchRepository = SearchRepository();
  final _postsFetcher = PublishSubject<List<Post>>();

  Stream<List<Post>> get searchedNews => _postsFetcher.stream;

  fetchAllSearchedNews({String searchedText = ""}) async {
    try {
      List<Post> postModel =
          await _searchRepository.fetchSearchedNews(searchedText);
      _postsFetcher.sink.add(postModel);
    } catch (e) {
      print(e.toString());
      _postsFetcher.sink.addError(Constants.connectionError);
    }
  }

  dispose() {
    _postsFetcher.close();
  }
}
