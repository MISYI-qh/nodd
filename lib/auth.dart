import 'package:flutter/material.dart';
import 'theme.dart';
import 'icons.dart';
import 'store.dart';
import 'widgets.dart';
import 'shell.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthState();
}

class _AuthState extends State<AuthScreen> {
  bool reg = true, show = false;
  final u = TextEditingController(), p = TextEditingController(), n = TextEditingController();
  String? err;

  void fail(String m) => setState(() => err = m);

  Future<void> submit() async {
    final user = u.text.trim().toLowerCase();
    if (!RegExp(r'^[a-z0-9_]{3,20}$').hasMatch(user)) {
      return fail('Nama pengguna 3 sampai 20 karakter: huruf kecil, angka, garis bawah.');
    }
    if (p.text.length < 6) return fail('Sandi minimal 6 karakter.');
    if (reg) {
      if (n.text.trim().isEmpty) return fail('Isi nama panggilan.');
      if (Store.usernameTaken(user)) return fail('Nama pengguna sudah dipakai.');
      await Store.register(user, p.text, n.text.trim());
    } else if (!await Store.login(user, p.text)) {
      return fail('Nama pengguna atau sandi salah.');
    }
    if (!mounted) return;
    Navigator.pushReplacement(context, fade(const Shell()));
  }

  @override
  Widget build(BuildContext context) {
    final f = fg(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (_, v, child) => Opacity(
                opacity: v,
                child: Transform.translate(offset: Offset(0, 24 * (1 - v)), child: child)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const NoddLogo(width: 130),
                const SizedBox(height: 40),
                Text(reg ? 'Buat akun' : 'Masuk',
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                const SizedBox(height: 28),
                NField(u, 'Nama pengguna'),
                const SizedBox(height: 14),
                NField(p, 'Sandi',
                    obscure: !show,
                    suffix: GestureDetector(
                      onTap: () => setState(() => show = !show),
                      child: NIcon(show ? NI.eyeOff : NI.eye, size: 22, color: f.withOpacity(.6)),
                    )),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: reg
                      ? Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: NField(n, 'Nama panggilan'))
                      : const SizedBox(width: double.infinity),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  child: err == null
                      ? const SizedBox(width: double.infinity)
                      : Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text(err!, style: const TextStyle(color: NC.pink, fontSize: 13))),
                ),
                const SizedBox(height: 26),
                NButton(reg ? 'DAFTAR' : 'MASUK', onTap: submit),
                const SizedBox(height: 18),
                Center(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      reg = !reg;
                      err = null;
                    }),
                    child: Text(reg ? 'Sudah punya akun? Masuk' : 'Belum punya akun? Daftar',
                        style: TextStyle(color: f.withOpacity(.7))),
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
