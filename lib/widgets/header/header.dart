import 'package:arcane/nav_provider.dart';
import 'package:arcane/services/auth_service.dart'; 
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Header extends StatelessWidget {
  final double headerPosition;
  final void Function(int)? onNavItemSelected;

  const Header({
    required this.headerPosition,
    this.onNavItemSelected,
    super.key,
  });

  void toLoginPage(BuildContext context) {
    Navigator.pushNamed(context, '/auth/login');
  }

  void toRegisterPage(BuildContext context) {
    Navigator.pushNamed(context, '/auth/register');
  }

  void logout() async {
    await AuthService().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AnimatedPositioned(
      top: headerPosition,
      left: 0.0,
      right: 0.0,
      duration: const Duration(milliseconds: 325),
      child: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        toolbarHeight: 66,
        actions: [
          if (!isMobile)
            StreamBuilder<User?>(
              stream: AuthService().authStateChanges,
              builder: (context, snapshot) {
                final user = snapshot.data;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (user != null) {
                        logout();
                      } else {
                        toLoginPage(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 30),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              user != null ? user.email ?? "User" : "Sign in",
                              style: const TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor:
                                user != null ? Colors.green : Colors.black26,
                            child: user != null
                                ? const Icon(Icons.logout, size: 18)
                                : const Icon(Icons.login, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
        title: isMobile
            ? const Text("Arcana",
                style:
                    TextStyle(fontFamily: "Inter", fontWeight: FontWeight.bold))
            : Row(
                children: [
                  const Text("Arcana",
                      style: TextStyle(
                          fontFamily: "Inter", fontWeight: FontWeight.bold)),
                  const SizedBox(width: 44),
                  if (isTablet || isDesktop) ...[
                    BuildNavItem(
                      label: "Customers",
                      color: colorScheme.onPrimary,
                      onTap: () => navProvider.setIndex(0),
                    ),
                    BuildNavItem(
                      label: "Products",
                      color: colorScheme.onPrimary,
                      onTap: () => navProvider.setIndex(1),
                    ),
                    if (isDesktop) ...[
                      BuildNavItem(
                        label: "Projects",
                        color: colorScheme.onPrimary,
                        onTap: () => navProvider.setIndex(2),
                      ),
                      BuildNavItem(
                        label: "Tasks",
                        color: colorScheme.onPrimary,
                        onTap: () => navProvider.setIndex(3),
                      ),
                      BuildNavItem(
                        label: "Settings",
                        color: colorScheme.onPrimary,
                        onTap: () => navProvider.setIndex(4),
                      ),
                    ],
                  ],
                ],
              ),
        automaticallyImplyLeading: isMobile,
        leading: isMobile
            ? Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : null,
      ),
    );
  }
}

class BuildNavItem extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const BuildNavItem({
    required this.label,
    required this.color,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: color,
          splashFactory: NoSplash.splashFactory,
          overlayColor: Colors.transparent,
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(label,
            style: TextStyle(
                color: color,
                fontFamily: "Inter",
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
