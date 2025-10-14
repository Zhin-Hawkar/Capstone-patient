import 'package:firebase_auth/firebase_auth.dart';

class SignUpState {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;

  SignUpState({
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.password = "",
    this.confirmPassword = "",
  });

  SignUpState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirmPassword,
    UserCredential? credential,
  }) {
    return SignUpState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
