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
  String? image;
  String? email;

  Profile({this.firstName, this.lastName, this.image, this.email});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    firstName: json["first_name"],
    lastName: json["last_name"],
    image: json["image"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
  };
}
