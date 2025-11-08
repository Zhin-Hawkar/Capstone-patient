import 'package:capstone/Backend/Model/user.dart';

class SignInState {
  final String email;
  final String password;
  Profile? profile;
  Doctor? doctor;

  SignInState({this.email = "", this.password = "", this.profile, this.doctor});

  SignInState copyWith({
    String? email,
    String? password,
    Profile? profile,
    Doctor? doctor,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      profile: profile ?? this.profile,
      doctor: doctor ?? this.doctor,
    );
  }
}
