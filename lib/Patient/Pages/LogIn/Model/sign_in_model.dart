import 'package:capstone/Backend/Model/user.dart';

class SignInState {
  final String email;
  final String password;
  Profile? profile;

  SignInState({this.email = "", this.password = "", this.profile});

  SignInState copyWith({String? email, String? password, Profile? profile}) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      profile: profile ?? this.profile,
    );
  }
}
