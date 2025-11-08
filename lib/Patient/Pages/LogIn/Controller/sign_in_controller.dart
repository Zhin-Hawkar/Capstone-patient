import 'package:capstone/Backend/Model/user.dart';
import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Constants/enum.dart';
import 'package:capstone/Patient/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:capstone/SharedResources/global_storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInController {
  Future<UserLoginResponseEntity> handleSignIn(
    BuildContext context,
    WidgetRef ref,
  ) async {
    var state = ref.watch(signInNotifierProvider);

    LoginRequestEntity loginRequestEntity = LoginRequestEntity()
      ..email = state.email
      ..password = state.password;

    try {
      var result = await _logIn(params: loginRequestEntity);
      print(result);
      if (result['code'] == 200 && result['token'] != null) {
        if (result['user']['role'] == EnumValues.DOCTOR) {
          GlobalStorageService.storageService.setDoctorId(
            EnumValues.DOCTORID,
            result['user']['id'],
          );
          print(
            "Doctor Id: ${GlobalStorageService.storageService.getInt(EnumValues.DOCTORID)}",
          );
        }
        GlobalStorageService.storageService.setString(
          EnumValues.ACCESS_TOKEN,
          result['token'],
        );
        GlobalStorageService.storageService.setString(
          EnumValues.ROLE,
          result['user']['role'],
        );
        if (result['user']['role'] == EnumValues.DOCTOR) {
          Doctor doctor = Doctor()
            ..firstName = result['user']['first_name']
            ..lastName = result['user']['last_name']
            ..specialization = result['user']['specialization']
            ..qualification = result['user']['qualification']
            ..hospital = result['user']['hospital']
            ..department = result['user']['department']
            ..licenseId = result['user']['licenseId']
            ..email = result['user']['email']
            ..location = result['user']['location']
            ..age = result['user']['age']
            ..description = result['user']['description']
            ..image = result['user']['image']
            ..role = result['user']['role'];
          ref.watch(signInNotifierProvider.notifier).setDoctor(doctor);
        } else if (result['user']['role'] == EnumValues.USER) {
          Profile profile = Profile()
            ..firstName = result['user']['first_name']
            ..lastName = result['user']['last_name']
            ..email = result['user']['email']
            ..location = result['user']['location']
            ..age = result['user']['age']
            ..description = result['user']['description']
            ..image = result['user']['image']
            ..role = result['user']['role'];
          ref.watch(signInNotifierProvider.notifier).setProfile(profile);
        }
        print(
          "from local cache: ${GlobalStorageService.storageService.getString(EnumValues.USER_PROFILE)}",
        );
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
      return UserLoginResponseEntity.fromJson(result);
    } catch (e) {
      return UserLoginResponseEntity();
    }
  }

  static _logIn({LoginRequestEntity? params}) async {
    var result = await HttpUtil().post(
      "api/login",
      queryParameters: params!.toJson(),
    );
    return result;
  }
}
