import 'package:arcane/pages/auth/login.dart';
import 'package:arcane/pages/auth/register.dart';
import 'package:arcane/pages/home_page.dart';
import 'package:arcane/widgets/header/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:arcane/pages/life_graph.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AppScaffold(child: HomePage()),
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
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/auth/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/calculator',
      builder: (context, state) => const CalcLifeGraph(),
    ),
  ],
);
