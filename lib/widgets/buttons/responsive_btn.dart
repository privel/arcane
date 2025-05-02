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
                  .map((btn) => ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: isTablet ? 280 : 320,
                          maxWidth: isDesktop ? 360 : 340,
                        ),
                        child: btn,
                      ))
                  .toList(),
            ),
    );
  }
}

class ContainerBlockWithTransition extends StatelessWidget {
  final String mainName;
  final VoidCallback onPressed;
  final double height;
  final double width;

  const ContainerBlockWithTransition({
    super.key,
    required this.mainName,
    required this.onPressed,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    // Примеры адаптивных значений
    final double logoSize = isMobile
        ? 60
        : isTablet
            ? 80
            : 200;

    final double textFontSize = isMobile
        ? 12
        : isTablet
            ? 14
            : 16;

    final double paddingValue = isMobile
        ? 8
        : isTablet
            ? 12
            : 16;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: paddingValue,
              vertical: paddingValue,
            ),
            child: Row(
              children: [
                Container(
                  height: logoSize,
                  width: logoSize,
                  color: Colors.brown,
                  child: const Center(child: SelectableText("LOGO")),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: SelectableText(
                    mainName,
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                      fontSize: textFontSize,
                    ),
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
