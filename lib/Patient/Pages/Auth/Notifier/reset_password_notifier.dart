import 'package:capstone/Patient/Pages/Auth/Model/reset_password_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
class ResetPasswordNotifier extends StateNotifier<ResetPasswordModel> {
  ResetPasswordNotifier() : super(ResetPasswordModel());

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setResetCode(int resetCode) {
    state = state.copyWith(resetCode: resetCode);
  }

  void setNewPassword(String newPassword) {
    state = state.copyWith(newPassword: newPassword);
  }
}

var resetPasswordNotifierProvider =
    StateNotifierProvider<ResetPasswordNotifier, ResetPasswordModel>(
      (ref) => ResetPasswordNotifier(),
    );
