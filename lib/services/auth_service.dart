import 'package:shared_preferences/shared_preferences.dart';
import '../api/stytch_api.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';

  final StytchApi _api = StytchApi();

  Future<bool> sendSmsCode(String phoneNumber) async {
    return await _api.sendSmsCode(phoneNumber);
  }

  Future<String?> verifySmsCode(String phoneNumber, String code) async {
    final token = await _api.verifySmsCode(phoneNumber, code);
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    }
    return token;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
