import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Arcane"),
        actions: [
          TextButton(
            onPressed: () => context.go('/'),
            child: const Text("Главная"),
          ),
          TextButton(
            onPressed: () => context.go('/products'),
            child: const Text("Продукты"),
          ),
          TextButton(
            onPressed: () => context.go('/projects'),
            child: const Text("Проекты"),
          ),
          TextButton(
            onPressed: () => context.go('/tasks'),
            child: const Text("Задачи"),
          ),
          TextButton(
            onPressed: () => context.go('/settings'),
            child: const Text("Настройки"),
          ),
        ],
      ),
      body: child,
    );
  }
}
