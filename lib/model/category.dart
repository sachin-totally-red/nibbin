import 'package:nibbin_app/common/database_helpers.dart';

class Category {
  int id;
  String name;
  String description;
  bool alreadySelected;

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        alreadySelected = false;

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (alreadySelected != null) 'alreadySelected': alreadySelected,
      };

  Category({this.id, this.name, this.description, this.alreadySelected});

  static convertToCategoryModel(SavedCategories savedCategories) {
    return Category(
        id: savedCategories.categoryID,
        name: savedCategories.categoryName,
        description: savedCategories.categoryDescription);
  }
}
