class UserModel {
  String? name, email, password, gender, address, imageUrl;
  int? age, id;

  UserModel({
    this.name,
    this.email,
    this.password,
    this.gender,
    this.age,
    this.address,
    this.imageUrl,
    this.id,
  });

  // From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      gender: json['gender'],
      age: json['age'],
      address: json['address'],
      imageUrl: json['image_url'],
      id: json['id'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'gender': gender,
      'age': age,
      'address': address,
      'image_url': imageUrl,
      'id': id,
    };
  }
}
