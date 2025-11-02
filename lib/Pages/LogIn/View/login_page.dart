import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Constants/enum.dart';
import 'package:capstone/Pages/FileUpload/View/file_upload.dart';
import 'package:capstone/Pages/Home/View/home.dart';
import 'package:capstone/Pages/LogIn/Controller/sign_in_controller.dart';
import 'package:capstone/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:capstone/Pages/Register/View/signup_page.dart';
import 'package:capstone/Reusables/Buttons/my_button.dart';
import 'package:capstone/Reusables/TextFields/my_textfield.dart';
import 'package:capstone/SharedResources/global_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;
  bool isSignInBtnClicked = false;

  static const Color kGreen = Color(0xFF5AA081);

  @override
  void initState() {
    super.initState();
    emailController.addListener(_onChanged);
    passwordController.addListener(_onChanged);
  }

  void _onChanged() => setState(() {});

  bool get isValid =>
      emailController.text.trim().contains('@') &&
      passwordController.text.trim().isNotEmpty;

  @override
  void dispose() {
    emailController.removeListener(_onChanged);
    passwordController.removeListener(_onChanged);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUserIn() async {
    if (!isValid) return;
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "field (email) is empty",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "field (password) is empty",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      isSignInBtnClicked = true;
    });
    ref.watch(signInNotifierProvider.notifier).setEmail(emailController.text);
    ref
        .watch(signInNotifierProvider.notifier)
        .setPassword(passwordController.text);
    var result = await SignInController().handleSignIn(context, ref);
    print("${result.token} from log in page");
    if (result.code == 200 &&
        GlobalStorageService.storageService
            .getString(EnumValues.ACCESS_TOKEN)
            .isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(120, 0, 0, 0),
          content: Text(
            "User Logged in Successfully!",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      bool isFirstFileUploadShowed = GlobalStorageService.storageService
          .getBool(EnumValues.DEVICE_FIRST_OPEN);
      if (isFirstFileUploadShowed) {
        Navigator.pushReplacement(
          context,
          PageTransition(type: PageTransitionType.fade, child: Home()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          PageTransition(type: PageTransitionType.fade, child: FilesUpload()),
        );
      }
    } else {
      setState(() {
        isSignInBtnClicked = false;
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
      backgroundColor: AppColors.WHITE_BACKGROUND,
      body: SafeArea(
        child: Stack(
          children: [
            // Green circular background
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

            // Main content
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
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child: Home(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Home",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.DARK_GREEN,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

                            // Titles
                            Text(
                              'Login to Your Account.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Hello, welcome back to your account',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.black),
                            ),

                            const SizedBox(height: 20),

                            // Email
                            MyTextField(
                              controller: emailController,
                              hintText: 'Email',
                              obscureText: false,
                              prefixIcon: const Icon(Icons.email_outlined),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
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
                                tooltip: showPassword
                                    ? 'Hide password'
                                    : 'Show password',
                              ),
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => loginUserIn(),
                            ),

                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(44, 44),
                                ),
                                child: Text(
                                  'Forgot password?',
                                  style: TextStyle(color: AppColors.DARK_GREEN),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Login button
                            isSignInBtnClicked
                                ? Transform.scale(
                                    scale: 1.6,
                                    child: Lottie.asset(
                                      "assets/json/Material wave loading.json",
                                      width: 100,
                                      height: 100,
                                    ),
                                  )
                                : Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 260,
                                      ),
                                      child: MyButton(
                                        onTap: isValid ? loginUserIn : null,
                                        label: 'Log in',
                                        backgroundColor: Colors.white,
                                        foregroundColor: kGreen,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 40),

                            // Bottom text on green arc
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
                                    "Don't Have an Account?",
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
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: SignUpPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Sign Up Here',
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
