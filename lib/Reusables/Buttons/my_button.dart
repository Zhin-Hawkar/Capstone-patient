import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const MyButton({
    super.key,
    required this.onTap,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return (backgroundColor ?? Colors.white);
            }
            return backgroundColor ?? Colors.white;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            final active = foregroundColor ?? const Color(0xFF5AA081);
            if (states.contains(WidgetState.disabled)) {
              return active.withOpacity(0.45);
            }
            return active;
          }),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          textStyle: const MaterialStatePropertyAll(
            TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
