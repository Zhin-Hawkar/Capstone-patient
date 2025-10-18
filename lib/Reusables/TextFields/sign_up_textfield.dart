import 'package:flutter/material.dart';

class SignUpTextField extends StatelessWidget {
  final TextEditingController? textFieldController;
  final String? hintText;
  final IconData? fieldIcon;
  const SignUpTextField({
    super.key,
    required this.textFieldController,
    required this.hintText,
    this.fieldIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(84, 144, 202, 250),
      ),
      width: 330,
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
            color: const Color.fromARGB(255, 16, 131, 225),
          ),
          focusColor: const Color.fromARGB(255, 0, 0, 0),
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}

class EditTextField extends StatelessWidget {
  final TextEditingController? textFieldController;
  final String? hintText;
  final IconData? fieldIcon;
  const EditTextField({
    super.key,
    required this.textFieldController,
    required this.hintText,
    this.fieldIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 213, 213, 213),
      ),
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

class DescriptionTextField extends StatelessWidget {
  final TextEditingController? textFieldController;
  final String? hintText;
  final IconData? fieldIcon;
  const DescriptionTextField({
    super.key,
    required this.textFieldController,
    required this.hintText,
    this.fieldIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 213, 213, 213),
      ),
      child: TextFormField(
        maxLines: 5,
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
          prefixIcon: Icon(fieldIcon, color: Colors.black),
          focusColor: const Color.fromARGB(255, 0, 0, 0),
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
