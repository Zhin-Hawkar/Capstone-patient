import 'package:capstone/Pages/LogIn/View/login_page.dart';
import 'package:capstone/Reusables/Buttons/sign_up_button.dart';
import 'package:capstone/Reusables/TextFields/sign_up_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 120),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  SignUpTextField(
                    textFieldController: _firstNameController,
                    hintText: "First Name",
                    fieldIcon: Icons.person,
                  ),
                  SizedBox(height: 30),
                  SignUpTextField(
                    textFieldController: _lastNameController,
                    hintText: "Last Name",
                    fieldIcon: Icons.person,
                  ),
                  SizedBox(height: 30),
                  SignUpTextField(
                    textFieldController: _emailController,
                    hintText: "Email",
                    fieldIcon: Icons.person,
                  ),
                  SizedBox(height: 30),
                  SignUpTextField(
                    textFieldController: _passwordController,
                    hintText: "Password",
                    fieldIcon: Icons.person,
                  ),
                  SizedBox(height: 30),
                  SignUpTextField(
                    textFieldController: _rePasswordController,
                    hintText: "Confirm Password",
                    fieldIcon: Icons.person,
                  ),
                  SizedBox(height: 30),
                  Column(
                    children: [
                      SignUpButton(
                        textFieldController: [
                          _firstNameController,
                          _lastNameController,
                          _emailController,
                          _passwordController,
                          _rePasswordController,
                        ],
                        nameErrorMessage: "field (name) is empty",
                        emailErrorMessage: "field (email) is empty",
                        passwordErrorMessage: "field (password) is empty",
                        rePasswordErrorMessage:
                            "field (confirm password) is empty",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "already have an account?",
                            style: TextStyle(
                              color: const Color.fromARGB(107, 0, 0, 0),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              "SignIn",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadiusGeometry.only(
              bottomLeft: Radius.elliptical(70, 90),
              bottomRight: Radius.elliptical(70, 90),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              color: Colors.blue,
              child: Center(
                child: Text(
                  "SignUp",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
