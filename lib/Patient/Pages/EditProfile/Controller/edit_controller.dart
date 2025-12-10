import 'package:capstone/Backend/Model/user.dart';
import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Patient/Pages/EditProfile/Notifier/edit_notifier.dart';
import 'package:capstone/Patient/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileController {
  Future<Map<String, dynamic>> handleProfileEdit(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final state = ref.watch(editProfileProvider);

    final profileRequest = Profile()
      ..firstName = state.firstName
      ..lastName = state.lastName
      ..age = state.age
      ..location = state.location
      ..description = state.description
      ..image = state.image
      ..email = state.email;

    try {
      final result = await _editProfile(params: profileRequest);
      if (result == null || result['code'] == null) {
        throw Exception("Invalid response from server");
      }

      if (result['code'] != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(120, 0, 0, 0),
            content: Text(
              "${result['error']}",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return result;
      }

      final updatedProfile = Profile.fromJson(result);
      ref.read(signInNotifierProvider.notifier).setProfile(updatedProfile);

      return result;
    } catch (e) {
      return {"code": 500, "error": e.toString()};
    }
  }

  static Future<dynamic> _editProfile({Profile? params}) async {
    FormData formData = FormData.fromMap({
      "first_name": params!.firstName,
      "last_name": params.lastName,
      "email": params.email,
      "age": params.age,
      "location": params.location,
      "description": params.description,
      if (params.image != null && params.image!.isNotEmpty)
        "image": await MultipartFile.fromFile(
          params.image!,
          filename: params.image!.split('/').last,
        ),
    });
    final result = await HttpUtil().post(
      "api/edituserprofile",
      data: formData,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    return result;
  }
}
