import 'package:capstone/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, this.onPasswordSubmitted});

  final Future<bool> Function(String newPassword)? onPasswordSubmitted;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, {bool isPassword = false}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600]),
      floatingLabelStyle: TextStyle(color: AppColors.DARK_GREEN),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.DARK_GREEN, width: 2),
      ),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                (_passwordController == _confirmPasswordController
                        ? _obscurePassword
                        : _obscureConfirmPassword)
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColors.DARK_GREEN,
              ),
              onPressed: () {
                setState(() {
                  if (_passwordController == _confirmPasswordController) {
                    _obscurePassword = !_obscurePassword;
                  } else {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  }
                });
              },
            )
          : null,
    );
  }

  bool _isStrongPassword(String value) {
    return value.length >= 8;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    final newPassword = _passwordController.text.trim();
    bool success = true;

    if (widget.onPasswordSubmitted != null) {
      success = await widget.onPasswordSubmitted!(newPassword);
    }

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully.')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update password. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: AppColors.DARK_GREEN,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your new password below.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 3.h),
                TextFormField(
                  controller: _passwordController,
                  cursorColor: AppColors.DARK_GREEN,
                  style: const TextStyle(color: Colors.black),
                  decoration: _inputDecoration('New password', isPassword: true),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (!_isStrongPassword(value.trim())) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),
                TextFormField(
                  controller: _confirmPasswordController,
                  cursorColor: AppColors.DARK_GREEN,
                  style: const TextStyle(color: Colors.black),
                  decoration: _inputDecoration('Confirm password', isPassword: true),
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value.trim() != _passwordController.text.trim()) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.DARK_GREEN,
                      backgroundColor: Colors.white,
                      side: BorderSide(color: AppColors.DARK_GREEN),
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            height: 2.h,
                            width: 2.h,
                            child: const CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Proceed'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
