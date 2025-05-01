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

    return Scaffold(
      drawer: isTabletOrSmaller ? _buildDrawer(context) : null,
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    if (isTabletOrSmaller) ...[
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => Scaffold.of(context).openDrawer(),
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
                    ],
                    if (!isTabletOrSmaller) ...[
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
                          label: "Главная", onPressed: () => context.go('/')),
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
                    ]
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
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFb31217)),
            child: Text('Меню',
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Главная'),
            onTap: () => context.go('/'),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Продукты'),
            onTap: () => context.go('/products'),
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Проекты'),
            onTap: () => context.go('/projects'),
          ),
          ListTile(
            leading: const Icon(Icons.check_box),
            title: const Text('Задачи'),
            onTap: () => context.go('/tasks'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Настройки'),
            onTap: () => context.go('/settings'),
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
