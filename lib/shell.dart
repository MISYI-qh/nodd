import 'dart:math';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'icons.dart';
import 'store.dart';
import 'widgets.dart';
import 'auth.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int i = 0;
  static const accents = [NC.purple, NC.green, NC.pink, NC.orange, NC.purple];
  static const labels = ['Beranda', 'Belajar', 'Bebas', 'Tanding', 'Profil'];
  static const icons = [NI.home, NI.learn, NI.free, NI.duel, NI.profile];

  Widget page(int k) {
    switch (k) {
      case 0:
        return const HomePage();
      case 1:
        return const Soon('Belajar', 'Pilih materi, lalu jalur level.');
      case 2:
        return const Soon('Bebas', 'Papan catur, kubus rubik, dan Dek.');
      case 3:
        return const Soon('Tanding', 'Lawan AI dan tes.');
      default:
        return ProfilePage(onLogout: () async {
          await Store.logout();
          if (mounted) Navigator.pushReplacement(context, fade(const AuthScreen()));
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final f = fg(context);
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          transitionBuilder: (w, a) => FadeTransition(
              opacity: a,
              child: SlideTransition(
                  position: Tween(begin: const Offset(0, .03), end: Offset.zero).animate(a),
                  child: w)),
          child: KeyedSubtree(key: ValueKey(i), child: page(i)),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: f.withOpacity(.1)))),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 68,
            child: Row(
              children: [
                for (var k = 0; k < 5; k++)
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => i = k),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: i == k ? 1.15 : 1,
                            duration: const Duration(milliseconds: 220),
                            child: NIcon(icons[k],
                                size: 24,
                                color: i == k ? accents[k] : f.withOpacity(.45)),
                          ),
                          const SizedBox(height: 4),
                          Text(labels[k],
                              style: TextStyle(
                                  fontSize: 11,
                                  color: i == k ? f : f.withOpacity(.45))),
                          const SizedBox(height: 3),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            width: i == k ? 16 : 0,
                            height: 3,
                            decoration: BoxDecoration(
                                color: accents[k], borderRadius: BorderRadius.circular(3)),
                          ),
                        ],
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
  // AI yang muncul dipilih acak murni.
  final ai = const ['cat', 'bik', 'has', 'ding'][Random().nextInt(4)];
  late final AnimationController c =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: c,
              builder: (_, __) => Transform.translate(
                  offset: Offset(0, -14 * Curves.easeInOut.transform(c.value)),
                  child: Image.asset('assets/ai/$ai.png', height: 150)),
            ),
            const SizedBox(height: 28),
            Text('Halo, ${Store.nick}',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(ai[0].toUpperCase() + ai.substring(1) + ' menyapamu hari ini.',
                style: TextStyle(color: fg(context).withOpacity(.6))),
          ],
        ),
      );
}

class Soon extends StatelessWidget {
  final String title, sub;
  const Soon(this.title, this.sub, {super.key});
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(sub, style: TextStyle(color: fg(context).withOpacity(.6))),
            const SizedBox(height: 4),
            Text('Segera hadir', style: TextStyle(color: fg(context).withOpacity(.4))),
          ],
        ),
      );
}

class ProfilePage extends StatelessWidget {
  final VoidCallback onLogout;
  const ProfilePage({super.key, required this.onLogout});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(Store.nick, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('@${Store.username}', style: TextStyle(color: fg(context).withOpacity(.6))),
            const Spacer(),
            NButton('KELUAR', onTap: onLogout, outlined: true),
          ],
        ),
      );
}
