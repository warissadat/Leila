import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StytchApi {
  final String _projectId = dotenv.env['STYTCH_PROJECT_ID'] ?? '';
  final String _secret = dotenv.env['STYTCH_SECRET'] ?? '';
  final String baseUrl = 'https://api.stytch.com';

  String get _authHeader {
    final credentials = '$_projectId:$_secret';
    return 'Basic ${base64Encode(utf8.encode(credentials))}';
  }

  Future<bool> sendSmsCode(String phoneNumber) async {
    final url = Uri.parse('$baseUrl/v1/sms/login_or_create');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': _authHeader,
    };
    final body = jsonEncode({'phone_number': phoneNumber});
    final response = await http.post(url, headers: headers, body: body);

    return response.statusCode == 200;
  }

  Future<String?> verifySmsCode(String phoneNumber, String code) async {
    final url = Uri.parse('$baseUrl/v1/sms/authenticate');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': _authHeader,
    };
    final body = jsonEncode({'phone_number': phoneNumber, 'code': code});
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['session_token'];
    }
    return null;
  }
}
