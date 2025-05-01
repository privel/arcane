import 'package:arcane/widgets/header/app_scaffold.dart';
import 'package:arcane/widgets/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:arcane/pages/life_graph.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AppScaffold(child: CalcLifeGraph()),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const AppScaffold(child: Text("/products")),
    ),
    GoRoute(
      path: '/projects',
      builder: (context, state) => const AppScaffold(child: Text("/projects")),
    ),
    GoRoute(
      path: '/tasks',
      builder: (context, state) => const AppScaffold(child: Text("/tasks")),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const AppScaffold(child: Text("/settings")),
    ),
  ],
);
