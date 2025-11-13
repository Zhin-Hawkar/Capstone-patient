import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Patient/Pages/Auth/Notifier/reset_password_notifier.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordController {
  static Future<void> generateResetCode(WidgetRef ref) async {
    final state = ref.watch(resetPasswordNotifierProvider.notifier);
    final email = ref.watch(resetPasswordNotifierProvider).email;
    print("email: ${email}");

    final result = await HttpUtil().post(
      "api/generateresetcode",
      data: {"email": email.toString()},
    );
    final code = result["reset_password_code"];
    print("generated code: ${code}");
    state.setResetCode(code);
  }

  static Future<dynamic> verifyCode(WidgetRef ref) async {
    final resetCode = ref.watch(resetPasswordNotifierProvider).resetCode;
    final email = ref.watch(resetPasswordNotifierProvider).email;
    print("reset code noti: ${resetCode}");
    print("email: ${email}");
    final result = await HttpUtil().post(
      "api/verifycode",
      data: {"email": email, "reset_password_code": resetCode},
    );
    print("Verified? : ${result['code']}");

    return result['code'];
  }

  static Future<dynamic> resetPassword(WidgetRef ref) async {
    final newPassword = ref.watch(resetPasswordNotifierProvider).newPassword;
    final email = ref.watch(resetPasswordNotifierProvider).email;
    print("new password: ${newPassword}");
    print("email: ${email}");
    final result = await HttpUtil().post(
      "api/resetpassword",
      data: {"email": email, "password": newPassword},
    );
    print("Password reseted ? : ${result['code']}");
    return result["code"];
  }
}
