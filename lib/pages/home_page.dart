import 'package:arcane/widgets/buttons/responsive_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? 16
                : isTablet
                    ? 24
                    : 32,
            vertical: isMobile ? 20 : 40,
          ),
          child: Center(
            child: isMobile
                ? const MobileLayout()
                : isTablet
                    ? const TabletLayout()
                    : const DesktopLayout(),
          ),
        ),
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text("Это мобильная версия"),
        SizedBox(height: 20),
        Icon(Icons.phone_android, size: 64),
      ],
    );
  }
}

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text("Это планшетная версия"),
        SizedBox(height: 20),
        Icon(Icons.tablet_mac, size: 64),
      ],
    );
  }
}

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Калькуляторы",
          style: TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.w600,
            fontSize: 40,
          ),
        ),
        const SizedBox(height: 40),
        ResponsiveButtonGrid(
          buttons: [
            ContainerBlockWithTransition(
              mainName: "Чакроанализ",
              height: 140,
              width: 350,
              onPressed: () {},
            ),
            ContainerBlockWithTransition(
              mainName: "Совместимость",
              height: 140,
              width: 350,
              onPressed: () {},
            ),
            ContainerBlockWithTransition(
              mainName: "Призма Души",
              height: 140,
              width: 350,
              onPressed: () {},
            ),
            ContainerBlockWithTransition(
              mainName: "Матрица Судьбы",
              height: 140,
              width: 350,
              onPressed: () {},
            ),
          ],
        )
      ],
    );
  }
}
