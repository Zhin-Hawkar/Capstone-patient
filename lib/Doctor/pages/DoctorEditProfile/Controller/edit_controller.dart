import 'package:capstone/Backend/Model/user.dart';
import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Doctor/pages/DoctorEditProfile/Notifier/edit_notifier.dart';
import 'package:capstone/Patient/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditDoctorController {
  static Future<Map<String, dynamic>> handleDoctorEdit(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final state = ref.watch(editDoctorProvider);

    final profileRequest = Doctor()
      ..firstName = state.firstName
      ..lastName = state.lastName
      ..age = state.age
      ..location = state.location
      ..description = state.description
      ..email = state.email
      ..image = state.image
      ..department = state.department
      ..specialization = state.specialization
      ..yearsOfExperience = state.yearsOfExperience
      ..licenseId = state.licenseId
      ..qualification = state.qualification;
   
    try {
      final result = await _editDoctor(params: profileRequest);
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

      final updatedProfile = Doctor.fromJson(result);
      ref.read(signInNotifierProvider.notifier).setDoctor(updatedProfile);

      return result;
    } catch (e) {
      return {"code": 500, "error": e.toString()};
    }
  }

  static Future<dynamic> _editDoctor({Doctor? params}) async {
    FormData formData = FormData.fromMap({
      "firstName": params?.firstName,
      "lastName": params?.lastName,
      "age": params?.age,
      "location": params?.location,
      "email": params?.email,
      "description": params?.description,
      "specialization": params?.specialization,
      "qualification": params?.qualification,
      "licenseId": params?.licenseId,
      "yearsofexperience": params?.yearsOfExperience,
      "department": params?.department,
      if (params?.image != null && params!.image!.isNotEmpty)
        "doctorImage": await MultipartFile.fromFile(
          params.image!,
          filename: params.image!.split('/').last,
        ),
    });
    final result = await HttpUtil().post(
      "api/editdoctorprofile",
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
