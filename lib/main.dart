import 'package:arcane/firebase_options.dart';
import 'package:arcane/pages/home_page.dart';
import 'package:arcane/services/providers/line_graph_provider.dart';
import 'package:arcane/services/providers/nav_provider.dart';
import 'package:arcane/services/auth_service.dart';
import 'package:arcane/services/routers/router.dart';
import 'package:arcane/services/theme.dart';
import 'package:arcane/widgets/buttons/navbtn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => LifeChartProvider()),
        StreamProvider<User?>.value(
          value: AuthService().authStateChanges,
          initialData: FirebaseAuth.instance.currentUser,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Arcane',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: ThemeMode.light,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}

class MainCode extends StatefulWidget {
  const MainCode({super.key});

  @override
  _MainCodeState createState() => _MainCodeState();
}

class _MainCodeState extends State<MainCode> {
  final ScrollController _scrollController = ScrollController();

  bool _isHeaderVisible = true;
  double _headerPosition = 0.0;

  final List<Widget> pages = const [
    HomePage(), // 0
    Center(child: Text('Products Page')),
    Center(child: Text('Projects Page')),
    Center(child: Text('Tasks Page')),
    Center(child: Text('Settings Page')),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final direction = _scrollController.position.userScrollDirection;

      if (direction == ScrollDirection.reverse && _isHeaderVisible) {
        setState(() {
          _isHeaderVisible = false;
          _headerPosition = -150.0;
        });
      } else if (direction == ScrollDirection.forward && !_isHeaderVisible) {
        setState(() {
          _isHeaderVisible = true;
          _headerPosition = 0.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          final direction = notification.direction;

          if (direction == ScrollDirection.reverse && _isHeaderVisible) {
            setState(() => _isHeaderVisible = false);
          } else if (direction == ScrollDirection.forward &&
              !_isHeaderVisible) {
            setState(() => _isHeaderVisible = true);
          }

          return true;
        },
        child: CustomScrollView(
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
                      if (ResponsiveBreakpoints.of(context)
                          .smallerOrEqualTo(TABLET)) ...[
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          "Arcane",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                      ],
                      if (ResponsiveBreakpoints.of(context)
                          .largerThan(TABLET)) ...[
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
                            onPressed: () {
                              Provider.of<NavigationProvider>(context,
                                      listen: false)
                                  .setIndex(0);
                            }),
                        NavButton(
                            label: "Продукты",
                            onPressed: () {
                              Provider.of<NavigationProvider>(context,
                                      listen: false)
                                  .setIndex(1);
                            }),
                        NavButton(
                            label: "Проекты",
                            onPressed: () {
                              Provider.of<NavigationProvider>(context,
                                      listen: false)
                                  .setIndex(2);
                            }),
                        NavButton(
                            label: "Задачи",
                            onPressed: () {
                              Provider.of<NavigationProvider>(context,
                                      listen: false)
                                  .setIndex(3);
                            }),
                        NavButton(
                            label: "Настройки",
                            onPressed: () {
                              Provider.of<NavigationProvider>(context,
                                      listen: false)
                                  .setIndex(4);
                            }),
                        const Spacer(),
                        OutlinedButton.icon(
                          onPressed: () async {
                            await AuthService().signOut();
                          },
                          icon: const Icon(Icons.logout, size: 18),
                          label: const Text("Выйти"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black12),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
            // Контент страницы
            SliverToBoxAdapter(
              child: pages[navProvider.currentIndex],
            ),
          ],
        ),
      ),
      drawer: ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET)
          ? buildDrawer(context)
          : null,
      drawerEnableOpenDragGesture: false,
    );
  }

  Drawer buildDrawer(BuildContext context) {
    final user = Provider.of<User?>(context);
    final isLoggedIn = user != null;

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
                        Navigator.pushNamed(context, '/auth/login');
                      },
                    )
                  ]
                : null,
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context);
              Provider.of<NavigationProvider>(context, listen: false)
                  .setIndex(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text("Products"),
            onTap: () {
              Navigator.pop(context);
              Provider.of<NavigationProvider>(context, listen: false)
                  .setIndex(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Provider.of<NavigationProvider>(context, listen: false)
                  .setIndex(4);
            },
          ),
          const Spacer(),
          const Divider(
            thickness: 0.8,
          ),
          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                Navigator.pop(context);
                await AuthService().signOut();
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
      duration: const Duration(milliseconds: 180), // длительность анимации
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
