import 'package:arcane/firebase_options.dart';
import 'package:arcane/services/providers/line_graph_provider.dart';
import 'package:arcane/services/providers/nav_provider.dart';
import 'package:arcane/pages/auth/login.dart';
import 'package:arcane/pages/auth/register.dart';
import 'package:arcane/pages/home.dart';
import 'package:arcane/services/auth_service.dart';
import 'package:arcane/services/theme.dart';
import 'package:arcane/widgets/header/header.dart';
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

    


    return MaterialApp(
      title: 'Arcane',
      debugShowCheckedModeBanner: false,
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
      initialRoute: '/',
      routes: {
        '/': (context) => const MainCode(),
        '/auth/login': (context) => const LoginPage(),
        '/auth/register': (context) => const RegisterPage(),
      },
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
    HomePage(),
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
      body: Stack(
        children: [
          // Содержимое страницы под AppBar
          Positioned.fill(
            top: 65, // ← высота AppBar
            child: ListView(
              controller: _scrollController,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: IndexedStack(
                    index: navProvider.currentIndex,
                    children: pages,
                  ),
                ),
              ],
            ),
          ),

          
          
          Header(
            headerPosition: _headerPosition,
          ),
        ],
      ),
      drawer: buildDrawer(context),
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
          const Divider(thickness: 0.8,),
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
