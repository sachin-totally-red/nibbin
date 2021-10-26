import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/resource/search_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:nibbin_app/view/search_content/search_news.dart';

class SearchBloc {
  final _searchRepository = SearchRepository();
  final _postsFetcher = PublishSubject<List<Post>>();

  Stream<List<Post>> get searchedNews => _postsFetcher.stream;

  fetchAllSearchedNews(
      {String searchedText = "",
      SearchNewsPageState searchNewsPageState}) async {
    try {
      List<Post> postModel = List<Post>();
      if (searchedText.length > 2) {
        postModel = await _searchRepository.fetchSearchedNews(searchedText);
      }
      if (searchNewsPageState != null) {
        searchNewsPageState.setState(() {
          searchNewsPageState.showSearchLoader = false;
        });
      }
      _postsFetcher.sink.add(postModel);
    } catch (e) {
      print(e.toString());
      _postsFetcher.sink.addError(Constants.connectionError);
    }
  }

  dispose() {
    _postsFetcher.close();
  }

  /*Future fetchSearchedNews(
      {String searchedText = "",
      SearchNewsPageState searchNewsPageState}) async {
    try {
      List<Post> _postModel = List<Post>();
      _postModel = await _searchRepository.fetchSearchedNews(searchedText);
      return _postModel;
    } catch (e) {
      print(e.toString());
      return "Error";
    }
  }*/
}
