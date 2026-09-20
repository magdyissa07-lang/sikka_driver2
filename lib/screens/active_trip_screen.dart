import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/driver_trip.dart';
import '../services/trip_service.dart';
import 'rating_screen.dart';

/// دورة حياة الرحلة عند السائق: accepted -> in_progress -> completed.
/// عند الإنهاء، السائق يدخل السعر النهائي يدويًا (لسه مفيش عداد آلي مربوط
/// بمسافة GPS فعلية - ده تحسين للمرحلة الجاية).
class ActiveTripScreen extends StatefulWidget {
  final DriverTrip trip;
  const ActiveTripScreen({super.key, required this.trip});

  @override
  State<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends State<ActiveTripScreen> {
  late DriverTrip _trip;
  final _fareCtrl = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _trip = widget.trip;
    _fareCtrl.text = _trip.estimatedFare?.toStringAsFixed(0) ?? '';
  }

  Future<void> _start() async {
    setState(() { _busy = true; _error = null; });
    try {
      final t = await TripService.start(_trip.id);
      setState(() => _trip = t);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _complete() async {
    final fare = double.tryParse(_fareCtrl.text.trim());
    if (fare == null) {
      setState(() => _error = 'أدخل السعر النهائي');
      return;
    }
    setState(() { _busy = true; _error = null; });
    try {
      final t = await TripService.complete(_trip.id, fare);
      setState(() => _trip = t);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الرحلة الحالية')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الحالة: ${_statusLabel(_trip.status)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 6),
            Text('${_trip.pickupText ?? ""} ← ${_trip.dropoffText ?? ""}', style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 20),

            if (_trip.status == 'accepted')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _busy ? null : _start, child: const Text('بدء الرحلة')),
              ),

            if (_trip.status == 'in_progress') ...[
              const Text('السعر النهائي (ج.م)', style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              TextField(controller: _fareCtrl, keyboardType: TextInputType.number),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _busy ? null : _complete, child: const Text('إنهاء الرحلة')),
              ),
            ],

            if (_trip.status == 'completed') ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('السعر النهائي: ${_trip.finalFare} ج.م'),
                      Text('عمولة سِكّة: ${_trip.commissionAmount} ج.م', style: const TextStyle(color: AppColors.textSecondary)),
                      Text('صافيك: ${_trip.driverNetAmount} ج.م', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(
                        _trip.paymentMethod == 'cash'
                            ? 'تحصيل كاش - العمولة اتضافت كدين يتسدد يوم الأحد'
                            : 'تم إضافة صافيك لمحفظتك فورًا',
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => RatingScreen(tripId: _trip.id)),
                  ),
                  child: const Text('قيّم الراكب وارجع للرحلات'),
                ),
              ),
            ],

            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 13)),
            ],
          ],
        ),
      ),
    );
  }

  String _statusLabel(String s) => switch (s) {
        'accepted' => 'في الطريق للراكب',
        'in_progress' => 'الرحلة جارية',
        'completed' => 'انتهت',
        _ => s,
      };
}
