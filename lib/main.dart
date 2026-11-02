import 'dart:math';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'store.dart';
import 'auth.dart';
import 'shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Store.init();
  runApp(const NoddApp());
}

class NoddApp extends StatelessWidget {
  const NoddApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nodd',
        theme: noddTheme(Brightness.light),
        darkTheme: noddTheme(Brightness.dark),
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) Navigator.pushReplacement(context, fade(const LoadingScreen()));
    });
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = CurvedAnimation(parent: c, curve: Curves.easeOutCubic);
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: a,
          child: ScaleTransition(
            scale: Tween(begin: .9, end: 1.0).animate(a),
            child: const NoddLogo(width: 210),
          ),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});
  @override
  State<LoadingScreen> createState() => _LoadingState();
}

class _LoadingState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late final AnimationController c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))..forward();
  static const ais = ['cat', 'bik', 'has', 'ding'];

  @override
  void initState() {
    super.initState();
    c.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) {
        Navigator.pushReplacement(
            context, fade(Store.username != null ? const Shell() : const AuthScreen()));
      }
    });
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final f = fg(context);
    return Scaffold(
      body: AnimatedBuilder(
        animation: c,
        builder: (_, __) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < 4; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Transform.translate(
                        offset: Offset(0, -10 * sin(c.value * 2 * pi * 3 + i * 1.2).abs()),
                        child: Image.asset('assets/ai/${ais[i]}.png', height: 52),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 36),
              Container(
                width: 180,
                height: 4,
                decoration: BoxDecoration(
                    color: f.withOpacity(.12), borderRadius: BorderRadius.circular(4)),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: Curves.easeInOut.transform(c.value),
                  child: Container(
                      decoration: BoxDecoration(
                          color: f, borderRadius: BorderRadius.circular(4))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
