import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import 'documents_screen.dart';
import 'home_screen.dart';

/// شاشة بينية بعد التحقق: السائق لسه status=pending_review في قاعدة
/// البيانات. أي محاولة يشوف رحلات هترفض من الـBackend لحد ما إداري يوافق.
class PendingReviewScreen extends StatelessWidget {
  const PendingReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_top, color: AppColors.warning, size: 48),
              const SizedBox(height: 18),
              const Text('حسابك قيد المراجعة', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text(
                'لازم ترفع مستنداتك (الرخصة، التأمين، استمارة السيارة، الفيش والتشبيه) وينتظر فريق سِكّة يراجعها ويوافق على سيارتك قبل ما تقدر تستقبل رحلات',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.6),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DocumentsScreen())),
                  child: const Text('رفع المستندات'),
                ),
              ),
              const SizedBox(height: 10),
              // للتجربة فقط: بعد ما تفعّل الحساب يدويًا في قاعدة البيانات
              // (زي ما هو موضح في README الباك إند)، ادخل من هنا.
              TextButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                ),
                child: const Text('تخطي (للتجربة فقط بعد التفعيل اليدوي)', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
