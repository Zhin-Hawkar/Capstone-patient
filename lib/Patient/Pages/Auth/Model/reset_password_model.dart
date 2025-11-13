class ResetPasswordModel {
  String? email;
  int? resetCode;
  String? newPassword;

  ResetPasswordModel({this.email, this.newPassword, this.resetCode});

  ResetPasswordModel copyWith({
    String? email,
    int? resetCode,
    String? newPassword,
  }) {
    return ResetPasswordModel(
      email: email ?? this.email,
      resetCode: resetCode ?? this.resetCode,
      newPassword: newPassword ?? this.newPassword,
    );
  }
}
