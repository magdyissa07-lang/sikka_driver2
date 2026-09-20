import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../services/auth_service.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  final _makeCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();

  bool _submitting = false;
  String? _error;

  Future<void> _submit() async {
    final year = int.tryParse(_yearCtrl.text.trim());

    if ([_nameCtrl.text, _phoneCtrl.text, _idCtrl.text, _makeCtrl.text, _modelCtrl.text, _plateCtrl.text]
        .any((v) => v.trim().isEmpty) || year == null) {
      setState(() => _error = 'من فضلك أكمل كل البيانات');
      return;
    }

    // نفس شرط الموديل 2020+ بيتفحص هنا كمان قبل ما نبعت للسيرفر، عشان تجربة
    // أسرع للسائق - لكن الفحص الحقيقي والملزم فعليًا في الـ Backend.
    if (year < 2020) {
      setState(() => _error = 'التطبيق لا يقبل سيارات أقل من موديل 2020');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await AuthService.register(
        fullName: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        nationalId: _idCtrl.text.trim(),
        make: _makeCtrl.text.trim(),
        model: _modelCtrl.text.trim(),
        year: year,
        plateNumber: _plateCtrl.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => OtpScreen(phone: _phoneCtrl.text.trim())));
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Widget _field(String label, TextEditingController ctrl, {TextInputType? type}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          TextField(controller: ctrl, keyboardType: type, decoration: const InputDecoration()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل سائق جديد')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('بيانات السائق', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 10),
              _field('الاسم الكامل', _nameCtrl),
              _field('رقم الهاتف', _phoneCtrl, type: TextInputType.phone),
              _field('الرقم القومي', _idCtrl, type: TextInputType.number),

              const SizedBox(height: 6),
              const Text('بيانات السيارة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: const Text('التطبيق لا يقبل سيارات أقل من موديل 2020',
                    style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              _field('الماركة', _makeCtrl),
              _field('الموديل', _modelCtrl),
              _field('سنة الصنع', _yearCtrl, type: TextInputType.number),
              _field('رقم اللوحة', _plateCtrl),

              if (_error != null) ...[
                Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 13)),
                const SizedBox(height: 10),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent))
                      : const Text('متابعة'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
