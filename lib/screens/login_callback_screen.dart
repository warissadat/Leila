import 'package:flutter/material.dart';
import '../api/stytch_api.dart';
import '../shared_prefs.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _codeSent = false;
  String _status = '';

  Future<void> _sendCode() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;

    setState(() => _status = 'Sending SMS...');
    final success = await StytchApi.sendOtp(phone); // نام متد اصلاح شد

    setState(() {
      _codeSent = success;
      _status = success ? 'Code sent! Enter it below.' : 'Failed to send code.';
    });
  }

  Future<void> _verifyCode() async {
    final phone = _phoneController.text.trim();
    final code = _codeController.text.trim();
    if (phone.isEmpty || code.isEmpty) return;

    setState(() => _status = 'Verifying...');
    final success = await StytchApi.authenticateOtp(phone, code); // نام متد اصلاح شد

    if (success) {
      await SharedPrefs.setLoggedIn(true);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() => _status = 'Invalid code or phone.');
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login with SMS')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+11234567890',
              ),
            ),
            if (_codeSent)
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'OTP Code'),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _codeSent ? _verifyCode : _sendCode,
              child: Text(_codeSent ? 'Verify Code' : 'Send Code'),
            ),
            const SizedBox(height: 16),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
