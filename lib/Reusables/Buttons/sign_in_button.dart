import 'package:capstone/Pages/FileUpload/View/file_upload.dart';
import 'package:capstone/Pages/LogIn/Controller/sign_in_controller.dart';
import 'package:capstone/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

// ignore: must_be_immutable
class SignInButton extends ConsumerStatefulWidget {
  final List<TextEditingController?> textFieldController;
  final String? emailErrorMessage, passwordErrorMessage;
  const SignInButton({
    super.key,
    required this.textFieldController,
    this.emailErrorMessage,
    this.passwordErrorMessage,
  });

  @override
  ConsumerState<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends ConsumerState<SignInButton> {
  bool isSignInBtnClicked = false;

  @override
  Widget build(BuildContext context) {
    return isSignInBtnClicked
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
                      widget.emailErrorMessage.toString(),
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
                      widget.passwordErrorMessage.toString(),
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
              ref
                  .watch(signInNotifierProvider.notifier)
                  .setEmail(widget.textFieldController[0]!.text);
              ref
                  .watch(signInNotifierProvider.notifier)
                  .setPassword(widget.textFieldController[1]!.text);
              var result = await SignInController().handleSignIn(context, ref);
              if (result.code == 200 && result.token != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color.fromARGB(120, 0, 0, 0),
                    content: Text(
                      "User Logged in Successfully!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: FilesUpload(),
                  ),
                );
              } else {
                setState(() {
                  isSignInBtnClicked = false;
                });
              }
            },
            child: Text("SignIn", style: TextStyle(color: Colors.white)),
          );
  }
}
