import 'dart:convert';
import 'package:capstone/Backend/Model/user.dart';
import 'package:capstone/Constants/enum.dart';
import 'package:capstone/SharedResources/global_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(keepAlive: true)
class EditProfileNotifier extends StateNotifier<Profile> {
  EditProfileNotifier() : super(Profile()) {
    _loadFromStorage();
  }
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

  void setProfile(Profile user) {
    Profile profile = Profile();
    profile.firstName = user.firstName;
    profile.lastName = user.lastName;
    profile.email = user.email;
    profile.location = user.location;
    profile.age = user.age;
    profile.description = user.description;
    profile.image = user.image;
    
    GlobalStorageService.storageService.setString(
      EnumValues.USER_PROFILE,
      jsonEncode({
        "first_name": user.firstName,
        "last_name": user.lastName,
        "email": user.email,
        "age": user.age,
        "location": user.location,
        "description": user.description,
        "image": user.image,
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
      profile.age = data["age"];
      profile.location = data["location"];
      profile.description = data["description"];
      profile.image = data["image"];
    }
  }
}

var editProfileProvider = StateNotifierProvider<EditProfileNotifier, Profile>(
  (ref) => EditProfileNotifier(),
);
