import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../shared_prefs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _codeSent = false;
  bool _isLoading = false;
  String? _error;

  void _sendCode() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final success = await _authService.sendSmsCode(_phoneController.text);
    setState(() {
      _isLoading = false;
      _codeSent = success;
      if (!success) {
        _error = 'ارسال کد موفقیت‌آمیز نبود.';
      }
    });
  }

  void _verifyCode() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final token = await _authService.verifySmsCode(_phoneController.text, _codeController.text);
    setState(() {
      _isLoading = false;
    });
    if (token != null) {
      await SharedPrefs.setLoggedIn(true);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _error = 'کد وارد شده اشتباه است.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ورود')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'شماره تلفن'),
              keyboardType: TextInputType.phone,
              enabled: !_codeSent,
            ),
            if (_codeSent)
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'کد پیامک'),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 20),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _codeSent ? _verifyCode : _sendCode,
                    child: Text(_codeSent ? 'تایید کد' : 'ارسال کد'),
                  ),
          ],
        ),
      ),
    );
  }
}
