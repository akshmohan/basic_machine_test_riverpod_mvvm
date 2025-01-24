class UserModel {
  final String? email;
  final String accessToken;

  UserModel({required this.accessToken,  this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      accessToken: json['accessoken'] ?? '',
      email: json['email'] ?? '',
    );
  }

}