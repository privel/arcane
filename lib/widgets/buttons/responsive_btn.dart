import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveButtonGrid extends StatelessWidget {
  final List<Widget> buttons;

  const ResponsiveButtonGrid({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    final double spacing = isMobile ? 16 : 24;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buttons
                  .map((btn) => Padding(
                        padding: EdgeInsets.only(bottom: spacing),
                        child: btn,
                      ))
                  .toList(),
            )
          : Wrap(
              spacing: spacing,
              runSpacing: spacing,
              alignment: WrapAlignment.center,
              children: buttons
                  // .map((btn) => ConstrainedBox(
                  //       constraints: BoxConstraints(
                  //         minWidth: isTablet ? 280 : 320,
                  //         maxWidth: isDesktop ? 360 : 340,
                  //       ),
                  //       child: btn,
                  //     ))
                  .map((btn) => Padding(
                        padding: EdgeInsets.only(bottom: spacing),
                        child: btn,
                      ))
                  .toList(),
            ),
    );
  }
}

class ContainerBlockWithTransition extends StatelessWidget {
  final String mainName;
  final String discription;
  final VoidCallback onPressed;
  final double height;
  final double width;

  const ContainerBlockWithTransition({
    super.key,
    required this.mainName,
    required this.discription,
    required this.onPressed,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    final double logoSize = isMobile ? 100 : 120;
    final double textFontSizeMain = isMobile
        ? 18
        : isTablet
            ? 18
            : 20;
    final double textFontSizeDesc = isMobile ? 12 : 14;
    final double paddingValue = isMobile ? 12 : 20;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.3), width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(paddingValue),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: logoSize,
                        width: logoSize,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.brown,
                        ),
                        child: const Center(child: Text("LOGO")),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mainName.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: textFontSizeMain,
                              fontFamily: "Inter",
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        discription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: textFontSizeDesc,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: onPressed,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          icon: const Icon(Icons.arrow_forward, size: 16),
                          label: const Text(
                            "РАССЧИТАТЬ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        height: logoSize,
                        width: logoSize,
                        margin: const EdgeInsets.only(right: 24),
                        decoration: const BoxDecoration(
                          color: Colors.brown,
                        ),
                        child: const Center(child: Text("LOGO")),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  mainName.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: textFontSizeMain,
                                    fontFamily: "Inter",
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              discription,
                              style: TextStyle(
                                fontSize: textFontSizeDesc,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: onPressed,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                                icon: const Icon(Icons.arrow_forward, size: 16),
                                label: const Text(
                                  "РАССЧИТАТЬ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
