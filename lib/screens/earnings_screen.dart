import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../services/wallet_service.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});
  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    EarningsService.load().then((d) => setState(() => _data = d));
  }

  @override
  Widget build(BuildContext context) {
    final d = _data;
    return Scaffold(
      appBar: AppBar(title: const Text('أرباحي')),
      body: d == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    Expanded(child: _statCard('النهاردة', '${d['today']['earnings']} ج.م', '${d['today']['trips']} رحلة')),
                    const SizedBox(width: 12),
                    Expanded(child: _statCard('الأسبوع ده', '${d['this_week']['earnings']} ج.م', '${d['this_week']['trips']} رحلة')),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt_long, color: AppColors.warning),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('دين العمولة الحالي: ${d['pending_commission_debt']} ج.م', style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text('يُخصم تلقائيًا من مستحقاتك يوم الصرف', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.accent, size: 18),
                      const SizedBox(width: 10),
                      Text('ميعاد الصرف الجاي: ${d['next_payout_date']}'),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _statCard(String label, String value, String sub) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.accent, Color(0xFFB08D4C)]),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.onAccent, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: AppColors.onAccent, fontSize: 20, fontWeight: FontWeight.w800)),
          Text(sub, style: const TextStyle(color: AppColors.onAccent, fontSize: 11)),
        ],
      ),
    );
  }
}
