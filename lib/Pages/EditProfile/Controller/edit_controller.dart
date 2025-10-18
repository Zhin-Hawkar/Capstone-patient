import 'package:capstone/Backend/Model/user.dart';
import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Pages/EditProfile/Notifier/edit_notifier.dart';
import 'package:capstone/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileController {
  Future<Profile> handleProfileEdit(BuildContext context, WidgetRef ref) async {
    var state = ref.watch(editProfileProvider);

    Profile profile = Profile();
    profile.firstName = state.firstName;
    profile.lastName = state.lastName;
    profile.age = state.age;
    profile.location = state.location;
    profile.description = state.description;
    profile.email = state.email;

    try {
      var result = await _editProfile(params: profile);
      print(result);
      if (result['code'] == 200) {
        Profile profile = Profile();
        profile.firstName = result['user']['first_name'];
        profile.lastName = result['user']['last_name'];
        profile.email = result['user']['email'];
        profile.location = result['user']['location'];
        profile.age = result['user']['age'];
        profile.description = result['user']['description'];
        profile.image = result['user']['image'];
        profile.code = result['code'];
        ref.watch(editProfileProvider.notifier).setProfile(profile);
      } else if (result['code'] != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(120, 0, 0, 0),
            content: Text(
              "${result['error']}",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
      return Profile.fromJson(result);
    } catch (e) {
      return Profile();
    }
  }

  static _editProfile({Profile? params}) async {
    var result = await HttpUtil().post(
      "api/edituserprofile",
      queryParameters: params!.toJson(),
    );
    return result;
  }
}
