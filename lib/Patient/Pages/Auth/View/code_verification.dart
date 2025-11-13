import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Patient/Pages/Auth/Controller/reset_password_controller.dart';
import 'package:capstone/Patient/Pages/Auth/Notifier/reset_password_notifier.dart';
import 'package:capstone/Patient/Pages/Auth/View/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class CodeVerificationPage extends ConsumerStatefulWidget {
  const CodeVerificationPage({super.key});

  @override
  ConsumerState<CodeVerificationPage> createState() =>
      _CodeVerificationPageState();
}

class _CodeVerificationPageState extends ConsumerState<CodeVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  bool _obscureCode = false;
  String? _errorMessage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _codeController.text = '';
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verifyCode(int? resetCode) async {
    setState(() {
      _errorMessage = null;
      isLoading = true;
    });
    final result = await ResetPasswordController.verifyCode(ref);
    if (result == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("code verified successfuly")));
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: ResetPasswordPage(),
        ),
      );
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Code verification failed")));
    }
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      labelStyle: TextStyle(color: Colors.grey[600]),
      floatingLabelStyle: TextStyle(color: AppColors.DARK_GREEN),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.DARK_GREEN, width: 2),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureCode ? Icons.visibility_off : Icons.visibility,
          color: AppColors.DARK_GREEN,
        ),
        onPressed: () {
          setState(() {
            _obscureCode = !_obscureCode;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Code'),
        backgroundColor: AppColors.DARK_GREEN,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A verification code has been sent to you.',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                decoration: BoxDecoration(
                  color: AppColors.DARK_GREEN.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.DARK_GREEN.withOpacity(0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your verification code',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.DARK_GREEN,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "${ref.watch(resetPasswordNotifierProvider).resetCode ?? "XXXX"}",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _codeController,
                      cursorColor: AppColors.DARK_GREEN,
                      style: const TextStyle(
                        color: Colors.black,
                        letterSpacing: 2,
                      ),
                      decoration: _inputDecoration(
                        'Enter code',
                        hint: 'XXXXXX',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the verification code';
                        }
                        if (value.trim().length < 4) {
                          return 'Code must be at least 4 digits';
                        }
                        return null;
                      },
                      obscureText: _obscureCode,
                    ),
                    if (_errorMessage != null) ...[
                      SizedBox(height: 1.h),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: isLoading
                    ? Transform.scale(
                        scale: 1.6,
                        child: Lottie.asset(
                          "assets/json/Material wave loading.json",
                          width: 100,
                          height: 100,
                        ),
                      )
                    : OutlinedButton(
                        onPressed: () {
                          _verifyCode(
                            ref.watch(resetPasswordNotifierProvider).resetCode,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.DARK_GREEN,
                          backgroundColor: Colors.white,
                          side: BorderSide(color: AppColors.DARK_GREEN),
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Proceed'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
