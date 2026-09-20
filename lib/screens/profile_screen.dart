import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'wallet_screen.dart';
import 'documents_screen.dart';
import 'help_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حسابي')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: AppColors.accent),
              title: const Text('المحفظة والمستحقات'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WalletScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.directions_car, color: AppColors.accent),
              title: const Text('سيارتي ومستنداتي'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DocumentsScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.support_agent, color: AppColors.accent),
              title: const Text('المساعدة'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HelpScreen())),
            ),
            const Spacer(),
            OutlinedButton(
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger, side: const BorderSide(color: AppColors.danger)),
              onPressed: () async {
                await AuthService.logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    (route) => false,
                  );
                }
              },
              child: const Text('تسجيل الخروج'),
            ),
          ],
        ),
      ),
    );
  }
}
