class UserModel {
  String id;
  String name;
  String type;
  String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      type: json["type"] ?? "",
      email: json["email"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "type": type, "email": email};
  }
}
