import 'dart:convert';

import 'package:capstone/Backend/Model/user.dart';
import 'package:capstone/Constants/enum.dart';
import 'package:capstone/Pages/LogIn/Model/sign_in_model.dart';
import 'package:capstone/SharedResources/global_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(keepAlive: true)
class SignInNotifier extends StateNotifier<SignInState> {
  SignInNotifier() : super(SignInState()) {
    _loadFromStorage();
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setProfile(
    String? firstName,
    String? lastName,
    String? email,
    String? image,
  ) {
    Profile profile = Profile();
    profile.firstName = firstName;
    profile.lastName = lastName;
    profile.email = email;
    profile.image = image;
    state = state.copyWith(profile: profile);

    GlobalStorageService.storageService.setString(
      "USER_PROFILE",
      jsonEncode({
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "image": image,
      }),
    );
  }

  void _loadFromStorage() {
    final jsonstr = GlobalStorageService.storageService.getString(
      EnumValues.USER_PROFILE,
    );
    if (jsonstr.isNotEmpty) {
      final data = jsonDecode(jsonstr);
      Profile profile = Profile();
      profile.firstName = data["first_name"];
      profile.lastName = data["last_name"];
      profile.email = data["email"];
      profile.image = data["image"];
      state = state.copyWith(profile: profile);
    }
  }
}

var signInNotifierProvider = StateNotifierProvider<SignInNotifier, SignInState>(
  (ref) => SignInNotifier(),
);
