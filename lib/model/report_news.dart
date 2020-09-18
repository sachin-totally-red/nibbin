class ReportType {
  int typeID;
  String typeTitle;
  int typeCreatedAt;
  int typeUpdatedAt;
  List<ReportSubType> subTypes;

  ReportType.fromJson(Map<String, dynamic> json)
      : typeID = json['id'],
        typeTitle = json['title'],
        typeCreatedAt = json['createdAt'],
        typeUpdatedAt = json['updatedAt'],
        subTypes = json["subTypes"] != null
            ? json["subTypes"]
                .map<ReportSubType>((i) => ReportSubType.fromJson(i))
                .toList()
            : null;

  Map<String, dynamic> toMap() => {
        'id': typeID,
        'title': typeTitle,
        "createdAt": typeCreatedAt,
        "updatedAt": typeUpdatedAt
      };

  Map<String, dynamic> toJson() => {
        'id': typeID,
        'title': typeTitle,
        "createdAt": typeCreatedAt,
        "updatedAt": typeUpdatedAt,
        "subTypes": subTypes
      };

  ReportType(
      {this.typeID,
      this.typeTitle,
      this.typeCreatedAt,
      this.typeUpdatedAt,
      this.subTypes});
}

class ReportSubType {
  int subTypeID;
  int typeID;
  String subTypeTitle;
  String subTypeDescription;
  int subTypeCreatedAt;
  int subTypeUpdatedAt;

  ReportSubType.fromJson(Map<String, dynamic> json)
      : subTypeID = json['id'],
        typeID = json['typeId'],
        subTypeTitle = json['title'],
        subTypeDescription = json['description'],
        subTypeCreatedAt = json['createdAt'],
        subTypeUpdatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() => {
        'id': subTypeID,
        'typeId': typeID,
        "title": subTypeTitle,
        "description": subTypeDescription,
        "createdAt": subTypeCreatedAt,
        "updatedAt": subTypeUpdatedAt
      };

  ReportSubType(
      {this.subTypeID,
      this.typeID,
      this.subTypeTitle,
      this.subTypeDescription,
      this.subTypeCreatedAt,
      this.subTypeUpdatedAt});
}
