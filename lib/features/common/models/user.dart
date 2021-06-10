class User {
  final int id;
  final String name;
  final String email;
  final String gender;
  final String status;
  final String createdAt;
  final String updatedAt;

  User(
      {this.id,
      this.name,
      this.email,
      this.gender,
      this.status,
      this.createdAt,
      this.updatedAt});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        gender: json['gender'],
        status: json['status'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }
}
