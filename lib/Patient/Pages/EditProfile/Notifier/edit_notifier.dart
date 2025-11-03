import 'package:capstone/Backend/Model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(keepAlive: false)
class EditProfileNotifier extends StateNotifier<Profile> {
  EditProfileNotifier() : super(Profile());
  void setFirstName(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void setLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setLocation(String location) {
    state = state.copyWith(location: location);
  }

  void setAge(int age) {
    state = state.copyWith(age: age);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  void setImage(String image) {
    state = state.copyWith(image: image);
  }
}

var editProfileProvider = StateNotifierProvider<EditProfileNotifier, Profile>(
  (ref) => EditProfileNotifier(),
);
