//Register
class RegisterRequestEntity {
  String? firstName;
  String? lastName;
  String? email;
  String? password;

  RegisterRequestEntity({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "password": password,
  };
}

//api post response msg
class UserRegisterResponseEntity {
  String? firstName;
  String? lastName;
  String? token;
  String? message;
  int? code;

  UserRegisterResponseEntity({
    this.code,
    this.token,
    this.message,
    this.firstName,
    this.lastName,
  });

  factory UserRegisterResponseEntity.fromJson(Map<String, dynamic> json) =>
      UserRegisterResponseEntity(
        code: json["code"],
        message: json["message"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        token: json["token"],
      );
}

//LogIn
class LoginRequestEntity {
  String? email;
  String? password;

  LoginRequestEntity({this.email, this.password});

  Map<String, dynamic> toJson() => {"email": email, "password": password};
}

//api post response msg
class UserLoginResponseEntity {
  String? token;
  String? message;
  int? code;

  UserLoginResponseEntity({this.token, this.message, this.code});

  factory UserLoginResponseEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginResponseEntity(
        token: json["token"],
        message: json["message"],
        code: json["code"],
      );
}

// login result
class Profile {
  String? firstName;
  String? lastName;
  int? age;
  String? image;
  String? location;
  String? description;
  String? email;
  int? code;

  Profile({
    this.firstName,
    this.lastName,
    this.image,
    this.email,
    this.age,
    this.location,
    this.description,
    this.code,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? json;
    return Profile(
      code: json['code'],
      firstName: user['first_name']?.toString(),
      lastName: user['last_name']?.toString(),
      email: user['email']?.toString(),
      location: user['location']?.toString(),
      description: user['description']?.toString(),
      image: user['image']?.toString(),
      age: user['age'] == null
          ? null
          : (user['age'] is int
                ? user['age']
                : int.tryParse(user['age'].toString())),
    );
  }

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "age": age,
    "location": location,
    "description": description,
    "image": image,
  };

  Profile copyWith({
    String? firstName,
    String? lastName,
    String? image,
    String? email,
    int? age,
    String? location,
    String? description,
    int? code,
  }) {
    return Profile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      age: age ?? this.age,
      location: location ?? this.location,
      description: description ?? this.description,
      image: image ?? this.image,
      code: code ?? this.code,
    );
  }
}
