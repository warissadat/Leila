import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class StytchApi {
  final String _projectId = dotenv.env['STYTCH_PROJECT_ID'] ?? '';
  final String _secret = dotenv.env['STYTCH_SECRET'] ?? '';

  Future<void> loginWithEmail(String email) async {
    final url = Uri.parse('https://test.stytch.com/v1/magic_links/email/login_or_create');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${base64Encode(utf8.encode("$_projectId:$_secret"))}',
    };
    final body = jsonEncode({
      'email': email,
      'login_magic_link_url': 'http://localhost:3000/magic-link',
      'signup_magic_link_url': 'http://localhost:3000/signup-magic-link',
    });

    final response = await http.post(url, headers: headers, body: body);
    print('Response: ${response.statusCode} ${response.body}');
  }
}
