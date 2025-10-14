import 'package:capstone/Backend/Model/user.dart';
import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Constants/enum.dart';
import 'package:capstone/Pages/LogIn/Notifier/sign_in_notifier.dart';
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

    LoginRequestEntity loginRequestEntity = LoginRequestEntity();
    loginRequestEntity.email = state.email;
    loginRequestEntity.password = state.password;

    try {
      var result = await _logIn(params: loginRequestEntity);
      if (result['code'] == 200 && result['token'] != null) {
        GlobalStorageService.storageService.setString(
          EnumValues.ACCESS_TOKEN,
          result['token'],
        );
        ref
            .watch(signInNotifierProvider.notifier)
            .setProfile(
              result['user']['first_name'],
              result['user']['last_name'],
              result['user']['email'],
              result['user']['image'],
            );
        print(
          "${result['user']['first_name']} ${result['user']['last_name']} ${result['user']['email']} ${result['user']['image']}",
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
