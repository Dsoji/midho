import 'package:hive_flutter/hive_flutter.dart';

class SessionService {
  final _box = Hive.box('data');

  Future<void> logout() async {
    await _box.delete('accessToken');
    await _box.delete('login_time');
  }

  Future<bool> isSessionValid() async {
    final token = _box.get('accessToken');
    final loginTimeMillis = _box.get('login_time');
    if (token == null || loginTimeMillis == null) return false;

    final loginTime = DateTime.fromMillisecondsSinceEpoch(loginTimeMillis);
    return DateTime.now().difference(loginTime) < const Duration(minutes: 5);
  }

  Future<void> saveLoginSessionTimeOnly() async {
    await _box.put('login_time', DateTime.now().millisecondsSinceEpoch);
  }
}
