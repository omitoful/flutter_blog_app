class User {
  int? id;
  String? name;
  String? image;
  String? email;
  String? token;

  User({this.id, this.name, this.image, this.email, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      email: json['email'],
      token: json['token'],
    );
  }
}
