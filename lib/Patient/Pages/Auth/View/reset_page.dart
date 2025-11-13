import 'package:capstone/Patient/Pages/Auth/Controller/reset_password_controller.dart';
import 'package:capstone/Patient/Pages/Auth/Notifier/reset_password_notifier.dart';
import 'package:capstone/Patient/Pages/Auth/View/code_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class EnterEmmailPage extends ConsumerStatefulWidget {
  const EnterEmmailPage({super.key});

  @override
  ConsumerState<EnterEmmailPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<EnterEmmailPage> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF5AA081);
    const bgColor = Color(0xFFF9F9FF);
    final state = ref.watch(resetPasswordNotifierProvider.notifier);
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        // keep SafeArea enabled to preserve natural layout
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // slightly higher back arrow without affecting other widgets
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 24,
                  splashRadius: 22,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              const SizedBox(height: 8),
              const Text(
                'Reset password',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter the email associated with your account and we’ll send a code with instructions to reset your password.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                "Email address",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "you@example.com",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 0.7,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: green, width: 1.4),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: isLoading
                    ? Transform.scale(
                        scale: 1.6,
                        child: Lottie.asset(
                          "assets/json/Material wave loading.json",
                          width: 100,
                          height: 100,
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          state.setEmail(_emailController.text);
                          ResetPasswordController.generateResetCode(ref);
                          if (ref
                                  .watch(resetPasswordNotifierProvider)
                                  .resetCode !=
                              0) {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: CodeVerificationPage(),
                              ),
                            );
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: const Text(
                          'Send',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
