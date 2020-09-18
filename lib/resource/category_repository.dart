import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/model/category.dart';

import 'api_handler.dart';

class CategoryRepository {
  APIHandler _apiHandler = APIHandler();

  Future fetchAllCategories() async {
    Map response = await _apiHandler.getAPICall("categories");
    List<Category> categoriesList =
        response["rows"].map<Category>((i) => Category.fromJson(i)).toList();
    return categoriesList;
  }

  Future<List<SavedCategories>> fetchAllSavedCategories() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    var maps = await helper.queryAllDataOnTableName(tableCategories);
    List<SavedCategories> savedCategories = List<SavedCategories>();
    if (maps.length > 0) {
      savedCategories =
          maps.map<SavedCategories>((i) => SavedCategories.fromMap(i)).toList();
    }
    return savedCategories;
  }

  Future saveSelectedCategories(List<Category> categoryList) async {
    try {
      DatabaseHelper helper = DatabaseHelper.instance;
      //Deleting already saved data
      var maps = await helper.deleteAllDataOnTableName(tableCategories);
      categoryList.forEach((category) async {
        SavedCategories savedCategories = SavedCategories(
            categoryID: category.id,
            categoryName: category.name,
            categoryDescription: category.description);
        int id = await helper.insert(
            tableName: tableCategories, tableData: savedCategories);
        print('inserted row ID : $id');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future saveCategoriesToApi(
      {List<SavedCategories> savedCategories,
      List<Category> categoryList}) async {
    //TODO: Sachin -- Convert this to List<Categories> and Save these categories to API DB.

    List<int> categoryIds = List<int>();
    if (categoryList == null)
      savedCategories.forEach((category) {
        categoryIds.add(category.categoryID);
      });
    else
      categoryList.forEach((category) {
        categoryIds.add(category.id);
      });
    Map response = await _apiHandler.postAPICall(
        endPointURL: "users/categories",
        apiInputParameters: {"categoryIds": categoryIds});

    return response;
  }
}
