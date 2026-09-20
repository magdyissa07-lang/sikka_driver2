import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const SikkaDriverApp());
}

class SikkaDriverApp extends StatelessWidget {
  const SikkaDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سِكّة - سائق',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const SplashScreen(),
    );
  }
}
