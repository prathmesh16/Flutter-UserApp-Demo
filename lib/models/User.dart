class User{
  final int id;
  final String name;
  final String email;
  final String gender;
  final String status;

  User({this.id,this.name,this.email,this.gender,this.status});

  factory User.fromJson(Map<String,dynamic> json)
  {
    return User(
      id:json['id'],
      name:json['name'],
      email: json['email'],
      gender: json['gender'],
      status: json['status']
    );
  }

}