import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/api_client.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _next();
  }

  Future<void> _next() async {
    await Future.delayed(const Duration(milliseconds: 900));
    final token = await ApiClient.getSavedToken();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => token != null ? const HomeScreen() : const RegisterScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(18)),
              alignment: Alignment.center,
              child: const Text('ز', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.onAccent)),
            ),
            const SizedBox(height: 18),
            const Text('سِكّة - سائق', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}
