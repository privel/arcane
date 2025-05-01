import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arcane/services/providers/nav_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            // Переключение страницы на "Projects Page" (index 2)
            Provider.of<NavigationProvider>(context, listen: false).setIndex(2);
          },
          child: const Text("Перейти на страницу проектов"),
        ),
      ),
    );
  }
}
