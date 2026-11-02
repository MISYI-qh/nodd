import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Satu-satunya pintu data. Nanti isi kelas ini diganti ke server sendiri,
// layar-layar tidak perlu diubah.
class Store {
  static late SharedPreferences _p;
  static Future<void> init() async => _p = await SharedPreferences.getInstance();

  static Map<String, dynamic> _users() {
    final s = _p.getString('users');
    return s == null ? <String, dynamic>{} : Map<String, dynamic>.from(jsonDecode(s) as Map);
  }

  static String _h(String x) => sha256.convert(utf8.encode(x)).toString();

  static bool usernameTaken(String u) => _users().containsKey(u);

  static Future<void> register(String u, String pass, String nick) async {
    final m = _users();
    m[u] = {'pass': _h(pass), 'nick': nick};
    await _p.setString('users', jsonEncode(m));
    await _p.setString('session', u);
  }

  static Future<bool> login(String u, String pass) async {
    final r = _users()[u];
    if (r == null || r['pass'] != _h(pass)) return false;
    await _p.setString('session', u);
    return true;
  }

  static String? get username => _p.getString('session');

  static String get nick {
    final u = username;
    if (u == null) return '';
    return (_users()[u]?['nick'] as String?) ?? u;
  }

  static Future<void> logout() async => _p.remove('session');
}
