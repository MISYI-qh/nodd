import 'package:flutter/material.dart';

class NC {
  static const purple = Color(0xFF9B5BD6);
  static const green = Color(0xFFB4D332);
  static const pink = Color(0xFFFF6BAA);
  static const orange = Color(0xFFFF9330);
}

bool isDark(BuildContext c) => Theme.of(c).brightness == Brightness.dark;
Color fg(BuildContext c) => isDark(c) ? Colors.white : Colors.black;
Color bgc(BuildContext c) => isDark(c) ? Colors.black : Colors.white;

ThemeData noddTheme(Brightness b) {
  final d = b == Brightness.dark;
  final base = d ? Colors.black : Colors.white;
  final top = d ? Colors.white : Colors.black;
  final tt = d ? Typography.material2021().white : Typography.material2021().black;
  return ThemeData(
    brightness: b,
    useMaterial3: true,
    scaffoldBackgroundColor: base,
    splashFactory: NoSplash.splashFactory,
    textTheme: tt.apply(bodyColor: top, displayColor: top),
    colorScheme: ColorScheme(
      brightness: b,
      primary: top,
      onPrimary: base,
      secondary: NC.purple,
      onSecondary: Colors.white,
      error: NC.pink,
      onError: Colors.white,
      surface: base,
      onSurface: top,
    ),
  );
}

Route<T> fade<T>(Widget w) => PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => w,
      transitionsBuilder: (_, a, __, child) =>
          FadeTransition(opacity: a, child: child),
    );

class NoddLogo extends StatelessWidget {
  final double width;
  const NoddLogo({super.key, this.width = 180});
  @override
  Widget build(BuildContext context) => Image.asset(
        isDark(context)
            ? 'assets/logo/nodd_white.png'
            : 'assets/logo/nodd_black.png',
        width: width,
        filterQuality: FilterQuality.high,
      );
}
