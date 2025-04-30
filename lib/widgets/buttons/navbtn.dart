import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const NavButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        foregroundColor: MaterialStateProperty.all(Colors.grey),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
        surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: Text(label,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontFamily: "Inter",
              fontWeight: FontWeight.w500)),
    );
  }
}

// import 'package:flutter/material.dart';

// class NavButton extends StatefulWidget {
//   final String label;
//   final VoidCallback onPressed;

//   const NavButton({super.key, required this.label, required this.onPressed});

//   @override
//   State<NavButton> createState() => _NavButtonState();
// }

// class _NavButtonState extends State<NavButton> {
//   bool _isHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     final textColor = Theme.of(context).colorScheme.onPrimary;

//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       child: GestureDetector(
//         onTap: widget.onPressed,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               widget.label,
//               style: TextStyle(
//                 fontFamily: "Inter",
//                 fontWeight: FontWeight.w500,
//                 color: textColor,
//               ),
//             ),
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               height: 2,
//               margin: const EdgeInsets.only(top: 4),
//               width: _isHovered ? 24 : 0,
//               decoration: BoxDecoration(
//                 color: textColor,
//                 borderRadius: BorderRadius.circular(1),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
