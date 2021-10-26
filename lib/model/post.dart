class Post {
  int id;
  String imageSrc;
  String imageSourceName;
  String title;
  String headline;
  String shortDesc;
  String link;
  String type;
  String storyDate;
  bool bookmarked;
  List<NewsCategory> newsCategories;

  Post.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        imageSrc = (json['imageSrc']?.isEmpty ?? true)
            ? "https://i.picsum.photos/id/42/200/300.jpg?hmac=RFAv_ervDAXQ4uM8dhocFa6_hkOkoBLeRR35gF8OHgs"
            : json['imageSrc'],
        imageSourceName = json['imageSourceName'],
        title = json['title'],
        headline = json['headline'],
        link = json['link'],
        shortDesc = json['shortDesc'],
        type = json['type'],
        storyDate = json['dated'] ?? DateTime.now().toString(),
        bookmarked = false,
        newsCategories = (json["categories"] != null)
            ? (json["categories"]
                .map<NewsCategory>((i) => NewsCategory.fromJson(i))
                .toList())
            : List<NewsCategory>();

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (imageSrc != null) 'imageSrc': imageSrc,
        if (imageSourceName != null) 'imageSourceName': imageSourceName,
        if (title != null) 'title': title,
        if (headline != null) 'headline': headline,
        if (shortDesc != null) 'shortDesc': shortDesc,
        if (link != null) 'link': link,
        if (type != null) 'type': type,
        if (storyDate != null) 'dated': storyDate,
      };

  Post({
    this.id,
    this.imageSrc,
    this.imageSourceName,
    this.title,
    this.headline,
    this.shortDesc,
    this.link,
    this.type,
    this.storyDate,
    this.bookmarked,
    this.newsCategories,
  });
}

class NewsCategory {
  int id;
  String name;

  NewsCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  NewsCategory({
    this.id,
    this.name,
  });
}
