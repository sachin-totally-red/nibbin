import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
//bookmarks Table
final String tableBookmarks = 'bookmarks';
final String columnId = '_id';
final String columnPostID = 'postID';
final String columnImgSrc = 'imageSrc';
final String columnTitle = 'title';
final String columnStory = 'story';
final String columnLink = 'link';
final String columnType = 'type';
final String columnStoryDate = 'storyDate';
//categories table
final String tableCategories = 'categories';
final String columnCategoryID = 'categoryID';
final String columnCategoryName = 'categoryName';
final String columnCategoryDescription = 'categoryDescription';
//reportType table
final String tableReportType = 'reportType';
//reportSubType table
final String tableReportSubType = 'reportSubType';

// Bookmarks data model class
class SavedBookmarks {
  int id;
  int postID;
  String imageSrc;
  String title;
  String story;
  String link;
  String type;
  String storyDate;

  SavedBookmarks({
    this.id,
    this.postID,
    this.imageSrc,
    this.title,
    this.story,
    this.link,
    this.type,
    this.storyDate,
  });

  // convenience constructor to create a Bookmarks object
  SavedBookmarks.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    postID = map[columnPostID];
    imageSrc = map[columnImgSrc];
    title = map[columnTitle];
    story = map[columnStory];
    link = map[columnLink];
    type = map[columnType];
    storyDate = map[columnStoryDate];
  }

  // convenience method to create a Map from this Bookmarks object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnPostID: postID,
      columnImgSrc: imageSrc ?? "",
      columnTitle: title ?? "",
      columnStory: story ?? "",
      columnLink: link ?? "",
      columnType: type ?? "",
      columnStoryDate: storyDate ?? "",
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// Categories data model class
class SavedCategories {
  int id;
  int categoryID;
  String categoryName;
  String categoryDescription;

  SavedCategories({
    this.id,
    this.categoryID,
    this.categoryName,
    this.categoryDescription,
  });

  // convenience constructor to create a Categories object
  SavedCategories.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    categoryID = map[columnCategoryID];
    categoryName = map[columnCategoryName];
    categoryDescription = map[columnCategoryDescription];
  }

  // convenience method to create a Map from this Categories object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnCategoryID: categoryID,
      columnCategoryName: categoryName,
      columnCategoryDescription: categoryDescription
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "NibbinDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableBookmarks (
                $columnId INTEGER PRIMARY KEY,
                $columnPostID INTEGER NOT NULL UNIQUE,
                $columnImgSrc TEXT NOT NULL,
                $columnTitle TEXT NOT NULL,
                $columnStory TEXT NOT NULL,
                $columnLink TEXT NOT NULL,
                $columnType TEXT NOT NULL,
                $columnStoryDate TEXT NOT NULL
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableCategories (
                $columnId INTEGER PRIMARY KEY,             
                $columnCategoryID INTEGER NOT NULL UNIQUE,
                $columnCategoryName TEXT NOT NULL,
                $columnCategoryDescription TEXT NOT NULL
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableReportType (
                _id INTEGER PRIMARY KEY,             
                id INTEGER NOT NULL UNIQUE,
                title TEXT NOT NULL,
                createdAt INTEGER NOT NULL,
                updatedAt INTEGER NOT NULL
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableReportSubType (
                _id INTEGER PRIMARY KEY,             
                id INTEGER NOT NULL UNIQUE,
                typeId INTEGER NOT NULL,
                title TEXT NOT NULL,
                description TEXT NOT NULL,
                createdAt INTEGER NOT NULL,
                updatedAt INTEGER NOT NULL
              )
              ''');
  }

  // Database helper methods:
  Future<int> insert({String tableName, tableData}) async {
    Database db = await database;
    try {
      int id = await db.insert(tableName, tableData.toMap());
      return id;
    } catch (e) {
      int id = await db.insert(tableName, tableData.toJson());
      return id;
    }
  }

  // To get one row of a table on the basis of row ID
  Future queryDataOnRowIDAndTableName({int id, String tableName}) async {
    Database db = await database;
    List<Map> maps =
        await db.query(tableName, where: '$columnId = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return SavedBookmarks.fromMap(maps.first);
    }
    return null;
  }

// To get all data of a table
  Future queryAllDataOnTableName(String tableName) async {
    try {
      Database db = await database;
      List<Map> maps = await db.query(tableName);
      return maps;
    } catch (exception) {
      List<Map> maps = [];
      return maps;
    }
  }

// TODO: delete(int id)
  Future deleteAllDataOnTableName(String tableName) async {
    Database db = await database;
    int result = await db.delete(tableName);
    return result;
  }

  Future deleteBookmarks({int id, String tableName, String columnName}) async {
    Database db = await database;
//    var abc = deleteDatabase(db.path);
//    int maps = await db.delete('bookmarks');
    int result =
        await db.delete(tableName, where: '$columnName = ?', whereArgs: [id]);
    return result;
  }

// TODO: update(Word word)
}
