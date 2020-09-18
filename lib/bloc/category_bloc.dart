import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/model/category.dart';
import 'package:nibbin_app/resource/category_repository.dart';
import 'package:nibbin_app/view/category_selection_page.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc {
  final _categoryRepository = CategoryRepository();
  final _categoriesFetcher = PublishSubject<List<Category>>();

  Stream<List<Category>> get allCategories => _categoriesFetcher.stream;

  fetchAllCategories() async {
    try {
      List<Category> categoryModel =
          await _categoryRepository.fetchAllCategories();

      List<SavedCategories> savedBookmarks =
          await _categoryRepository.fetchAllSavedCategories();
      categoryModel.forEach((fetchedCategory) {
        int _categoryIndex = savedBookmarks.indexWhere((savedBookmark) =>
            (fetchedCategory.id == savedBookmark.categoryID));
        if (_categoryIndex != -1) {
          fetchedCategory.alreadySelected = true;
          selectedCategoryList.add(fetchedCategory);
        }
        ;
      });

      _categoriesFetcher.sink.add(categoryModel);
    } catch (e) {
      print(e.toString());
      _categoriesFetcher.sink.addError(Constants.connectionError);
    }
  }

  dispose() {
    _categoriesFetcher.close();
  }
}
