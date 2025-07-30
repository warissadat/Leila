import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    // اجرا بعد از ساخت اولین فریم برای اطمینان از آماده بودن context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLogin();
    });
  }

  void _checkLogin() async {
    final token = await _authService.getToken();

    if (!mounted) return; // جلوگیری از خطا اگر ویجت قبلا از بین رفته باشد

    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
