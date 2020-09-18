class User {
  int id;
  String firstName;
  String lastName;
  String phone;
  String email;
  String outlookID;
  String googleID;
  String profileImagePath;
  String accessToken;
  String clientID;
  String idToken;

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        phone = json['phone'],
        email = json['email'],
        outlookID = json['outlookID'],
        googleID = json['googleID'],
        profileImagePath = json['profileImage'];

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
        if (outlookID != null) 'facebookToken': outlookID,
        if (googleID != null) 'googleID': googleID,
        if (profileImagePath != null) 'profileImage': profileImagePath,
        if (accessToken != null) 'accessToken': accessToken,
        if (clientID != null) 'clientID': clientID,
        if (idToken != null) 'idToken': idToken,
      };

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.outlookID,
    this.googleID,
    this.profileImagePath,
    this.accessToken,
    this.clientID,
    this.idToken,
  });
}
