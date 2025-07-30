import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../shared_prefs.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    final auth = AuthService();
    await auth.removeToken();
    await SharedPrefs.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خانه'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: const Center(
        child: Text('خوش آمدید!'),
      ),
    );
  }
}
