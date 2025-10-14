import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AiTextField extends StatelessWidget {
  final TextEditingController? textFieldController;
  final String? hintText;
  final IconData? fieldIcon;
  final Color? backgroundColor;
  final Color? textColor;
  const AiTextField({
    super.key,
    this.textFieldController,
    this.hintText,
    this.fieldIcon,
    this.backgroundColor = const Color.fromARGB(82, 199, 199, 199),
    this.textColor = const Color.fromARGB(118, 0, 0, 0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(82, 199, 199, 199),
      ),
      width: 530.w,
      child: TextFormField(
        controller: textFieldController,
        onTapUpOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        cursorHeight: 15,
        decoration: InputDecoration(
          hint: Text(
            hintText.toString(),
            style: TextStyle(color: const Color.fromARGB(118, 0, 0, 0)),
          ),
          prefixIcon: Icon(
            fieldIcon,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          focusColor: const Color.fromARGB(255, 0, 0, 0),
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
