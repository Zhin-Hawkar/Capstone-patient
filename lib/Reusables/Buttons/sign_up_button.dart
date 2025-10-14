import 'package:capstone/Pages/Register/Controller/sign_up_controller.dart';
import 'package:capstone/Pages/Register/Notifier/sign_up_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class SignUpButton extends ConsumerStatefulWidget {
  final List<TextEditingController?> textFieldController;
  final String? nameErrorMessage,
      emailErrorMessage,
      passwordErrorMessage,
      rePasswordErrorMessage;

  const SignUpButton({
    super.key,
    required this.textFieldController,
    this.nameErrorMessage,
    this.emailErrorMessage,
    this.passwordErrorMessage,
    this.rePasswordErrorMessage,
  });

  @override
  ConsumerState<SignUpButton> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends ConsumerState<SignUpButton> {
  bool isSignUpBtnClicked = false;
  @override
  Widget build(BuildContext context) {
    return isSignUpBtnClicked
        ? CircularProgressIndicator()
        : ElevatedButton(
            style: ButtonStyle(
              padding: WidgetStatePropertyAll(
                EdgeInsets.only(top: 15, bottom: 15, right: 120, left: 120),
              ),
              backgroundColor: WidgetStatePropertyAll(Colors.blue),
            ),
            onPressed: () async {
              if (widget.textFieldController[0]!.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.nameErrorMessage.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              if (widget.textFieldController[1]!.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.emailErrorMessage.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              if (widget.textFieldController[2]!.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.passwordErrorMessage.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              if (widget.textFieldController[3]!.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.rePasswordErrorMessage.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              if (widget.textFieldController[4]!.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.rePasswordErrorMessage.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              if (widget.textFieldController[3]!.text !=
                  widget.textFieldController[4]!.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "password doesn't match",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              setState(() {
                isSignUpBtnClicked = true;
              });
              ref
                  .watch(signUpNotifierProvider.notifier)
                  .setFirstName(widget.textFieldController[0]!.text);
              ref
                  .watch(signUpNotifierProvider.notifier)
                  .setLastName(widget.textFieldController[1]!.text);
              ref
                  .watch(signUpNotifierProvider.notifier)
                  .setEmail(widget.textFieldController[2]!.text);
              ref
                  .watch(signUpNotifierProvider.notifier)
                  .setPassword(widget.textFieldController[3]!.text);
              ref
                  .watch(signUpNotifierProvider.notifier)
                  .setConfirmPassword(widget.textFieldController[4]!.text);
              var user = await SignUpController().handleSignUp(context, ref);
              if (user.code == 200 && user.token != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color.fromARGB(120, 0, 0, 0),
                    content: Text(
                      "User Registered Successfully!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
               
              } else {
                setState(() {
                  isSignUpBtnClicked = false;
                });
              }
            },
            child: Text("SignUp", style: TextStyle(color: Colors.white)),
          );
  }
}
