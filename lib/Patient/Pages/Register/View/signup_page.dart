import 'package:capstone/Patient/Pages/LogIn/View/login_page.dart';
import 'package:capstone/Patient/Pages/Register/Controller/sign_up_controller.dart';
import 'package:capstone/Patient/Pages/Register/Notifier/sign_up_notifier.dart';
import 'package:capstone/Reusables/Buttons/my_button.dart';
import 'package:capstone/Reusables/TextFields/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isSignUpBtnClicked = false;

  bool showPassword = false;
  bool showConfirmPassword = false;

  static const Color kGreen = Color(0xFF5AA081);

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(_onChanged);
    lastNameController.addListener(_onChanged);
    emailController.addListener(_onChanged);
    passwordController.addListener(_onChanged);
    confirmPasswordController.addListener(_onChanged);
  }

  void _onChanged() => setState(() {});

  bool get isValid =>
      firstNameController.text.trim().isNotEmpty &&
      lastNameController.text.trim().isNotEmpty &&
      emailController.text.trim().contains('@') &&
      passwordController.text.trim().isNotEmpty &&
      confirmPasswordController.text.trim().isNotEmpty &&
      passwordController.text.trim() == confirmPasswordController.text.trim();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signUserUp() async {
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Signing up...')));

    // Here you can add your backend signup logic
    setState(() {
      isSignUpBtnClicked = true;
    });

    ref
        .watch(signUpNotifierProvider.notifier)
        .setFirstName(firstNameController.text);
    ref
        .watch(signUpNotifierProvider.notifier)
        .setLastName(lastNameController.text);
    ref.watch(signUpNotifierProvider.notifier).setEmail(emailController.text);
    ref
        .watch(signUpNotifierProvider.notifier)
        .setPassword(passwordController.text);
    ref
        .watch(signUpNotifierProvider.notifier)
        .setConfirmPassword(confirmPasswordController.text);
    var result = await SignUpController().handleSignUp(context, ref);
    if (result.code == 200 && result.token != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(120, 0, 0, 0),
          content: Text(
            "User Registered Successfully!",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      Navigator.pushReplacement(
        context,
        PageTransition(type: PageTransitionType.fade, child: LoginPage()),
      );
    } else {
      setState(() {
        isSignUpBtnClicked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final double diameter = size.width * 1.6;
    final double circleLeft = (size.width - diameter) / 2;
    final double circleBottom = -diameter * 0.55;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: circleLeft,
              bottom: circleBottom,
              child: Container(
                width: diameter,
                height: diameter,
                decoration: const BoxDecoration(
                  color: kGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Transform.scale(
                                scale: 1.2,
                                child: Lottie.asset(
                                  "assets/json/Pin code Password Protection, Secure Login animation.json",
                                  height: 230,
                                  width: 230,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Create Your Account',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Join us and get started today!',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.black.withOpacity(0.55),
                                  ),
                            ),
                            const SizedBox(height: 20),

                            // Name
                            MyTextField(
                              controller: firstNameController,
                              hintText: 'First Name',
                              obscureText: false,
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            const SizedBox(height: 12),
                            MyTextField(
                              controller: lastNameController,
                              hintText: 'Last Name',
                              obscureText: false,
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            const SizedBox(height: 12),

                            // Email
                            MyTextField(
                              controller: emailController,
                              hintText: 'Email',
                              obscureText: false,
                              prefixIcon: const Icon(Icons.email_outlined),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 12),

                            // Password
                            MyTextField(
                              controller: passwordController,
                              hintText: 'Password',
                              obscureText: !showPassword,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                  () => showPassword = !showPassword,
                                ),
                                icon: Icon(
                                  showPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Confirm Password
                            MyTextField(
                              controller: confirmPasswordController,
                              hintText: 'Confirm Password',
                              obscureText: !showConfirmPassword,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                  () => showConfirmPassword =
                                      !showConfirmPassword,
                                ),
                                icon: Icon(
                                  showConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Sign Up button
                            Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 260,
                                ),
                                child: MyButton(
                                  onTap: isValid ? signUserUp : null,
                                  label: 'Sign Up',
                                  backgroundColor: Colors.white,
                                  foregroundColor: kGreen,
                                ),
                              ),
                            ),

                            const Spacer(),

                            Row(
                              children: const [
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    "Already have an account?",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Go back to Login
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Log in Here',
                                  style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
