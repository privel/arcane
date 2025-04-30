import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const NavButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(color: Colors.black)),
    );
  }
}
