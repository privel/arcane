import 'package:flutter/material.dart';

class Textbtn extends StatelessWidget {
  final Text textparamets;
  final VoidCallback onpressed;

  const Textbtn({
    required this.textparamets,
    required this.onpressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onpressed,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        foregroundColor: MaterialStateProperty.all(Colors.grey),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
        surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: textparamets,
    );
  }
}
