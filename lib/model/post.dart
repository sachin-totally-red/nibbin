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

  Post.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        imageSrc = json['image_url'],
        imageSourceName = json['imageSourceName'],
        title = json['title'],
        headline = json['headline'],
        link = json['link'],
        shortDesc = json['shortDesc'],
        type = json['type'],
        storyDate = json['dated'],
        bookmarked = false;

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (imageSrc != null) 'image_url': imageSrc,
        if (imageSourceName != null) 'imageSourceName': imageSourceName,
        if (title != null) 'title': title,
        if (headline != null) 'headline': headline,
        if (shortDesc != null) 'shortDesc': shortDesc,
        if (link != null) 'link': link,
        if (type != null) 'type': type,
        if (storyDate != null) 'dated': storyDate,
      };

  Post(
      {this.id,
      this.imageSrc,
      this.imageSourceName,
      this.title,
      this.headline,
      this.shortDesc,
      this.link,
      this.type,
      this.storyDate,
      this.bookmarked});
}
