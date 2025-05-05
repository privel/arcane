import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:go_router/go_router.dart';
import 'package:arcane/widgets/buttons/navbtn.dart';

class AppScaffold extends StatefulWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final ScrollController _scrollController = ScrollController();

  bool _isHeaderVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final direction = _scrollController.position.userScrollDirection;
      if (direction == ScrollDirection.reverse && _isHeaderVisible) {
        setState(() => _isHeaderVisible = false);
      } else if (direction == ScrollDirection.forward && !_isHeaderVisible) {
        setState(() => _isHeaderVisible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTabletOrSmaller =
        ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET);

    final user = FirebaseAuth.instance.currentUser;
    final isLoggedIn = user != null;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final isLoggedIn = user != null;
        return Scaffold(
          // drawer: isTabletOrSmaller ? buildDrawer(context) : null,
          drawer: isTabletOrSmaller ? buildDrawer(context, user) : null,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPersistentHeader(
                pinned: false,
                floating: true,
                delegate: _AnimatedHeader(
                  minExtent: 66,
                  maxExtent: 66,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        if (isTabletOrSmaller) ...[
                          Builder(
                            builder: (context) => IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer(),
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Text(
                            "Arcane",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                        ] else ...[
                          const Text(
                            "Arcane",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 20),
                          NavButton(
                              label: "Главная",
                              onPressed: () => context.go('/')),
                          NavButton(
                              label: "Продукты",
                              onPressed: () => context.go('/products')),
                          NavButton(
                              label: "Проекты",
                              onPressed: () => context.go('/projects')),
                          NavButton(
                              label: "Задачи",
                              onPressed: () => context.go('/tasks')),
                          NavButton(
                              label: "Настройки",
                              onPressed: () => context.go('/settings')),
                          const Spacer(),
                          if (isLoggedIn) ...[
                            Text(
                              user!.email ?? '',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                            const SizedBox(width: 12),
                            TextButton.icon(
                              onPressed: () async {
                                setState(() async {
                                  await FirebaseAuth.instance.signOut();
                                });

                                context.go('/');
                              },
                              icon: const Icon(Icons.logout, size: 18),
                              label: const Text("Выйти"),
                            ),
                          ] else ...[
                            TextButton.icon(
                              onPressed: () => context.go('/auth/login'),
                              icon: const Icon(Icons.login, size: 18),
                              label: const Text("Войти"),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: widget.child,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildDrawer(BuildContext context, User? user) {
    final isLoggedIn = user != null;
    // final user = FirebaseAuth.instance.currentUser;
    // final isLoggedIn = user != null;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(isLoggedIn ? (user.email ?? 'User') : 'Guest'),
            accountEmail: isLoggedIn ? null : const Text("Not signed in"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black),
            ),
            decoration: const BoxDecoration(color: Color(0xFFb31217)),
            otherAccountsPictures: !isLoggedIn
                ? [
                    IconButton(
                      icon: const Icon(Icons.login, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/auth/login');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.app_registration,
                          color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/auth/register');
                      },
                    ),
                  ]
                : null,
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Главная"),
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text("Продукты"),
            onTap: () {
              Navigator.pop(context);
              context.go('/products');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text("Настройки"),
            onTap: () {
              Navigator.pop(context);
              context.go('/settings');
            },
          ),
          const Spacer(),
          const Divider(thickness: 0.8),
          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Выйти"),
              onTap: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
                context.go('/');
              },
            ),
        ],
      ),
    );
  }
}

class _AnimatedHeader extends SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final Widget child;

  _AnimatedHeader({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double targetOffset = -shrinkOffset.clamp(0.0, maxExtent);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: targetOffset),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      builder: (context, animatedOffset, childWidget) {
        return Transform.translate(
          offset: Offset(0, animatedOffset),
          child: SizedBox(
            height: maxExtent,
            child: Material(
              elevation: 4,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _AnimatedHeader oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.minExtent != minExtent ||
        oldDelegate.maxExtent != maxExtent;
  }
}
