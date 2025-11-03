import 'package:capstone/Backend/Model/user.dart';
import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Patient/Pages/Register/Notifier/sign_up_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpController {
  SignUpController();
  Future<UserRegisterResponseEntity> handleSignUp(
    BuildContext context,
    WidgetRef ref,
  ) async {
    var state = ref.watch(signUpNotifierProvider);
    RegisterRequestEntity registerRequestEntity = RegisterRequestEntity(
      firstName: state.firstName,
      lastName: state.lastName,
      email: state.email,
      password: state.password,
    );
    try {
      var result = await _register(params: registerRequestEntity);
      if (result['errors'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(120, 0, 0, 0),
            content: Text(
              "${result['errors']['email'][0]}",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return UserRegisterResponseEntity();
      }
      return UserRegisterResponseEntity.fromJson(result);
    } catch (e) {
      return UserRegisterResponseEntity();
    }
  }

  static _register({RegisterRequestEntity? params}) async {
    var response = await HttpUtil().post(
      "api/register",
      queryParameters: params!.toJson(),
    );
    return response;
  }
}
