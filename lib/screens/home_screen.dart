import 'dart:async';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/driver_trip.dart';
import '../services/trip_service.dart';
import 'active_trip_screen.dart';
import 'profile_screen.dart';
import 'earnings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DriverTrip> _trips = [];
  bool _loading = true;
  String? _error;
  bool _online = true;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _refresh();
    _poll = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_online) _refresh();
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() { _loading = _trips.isEmpty; _error = null; });
    try {
      final trips = await TripService.available();
      setState(() { _trips = trips; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _accept(DriverTrip trip) async {
    try {
      final accepted = await TripService.accept(trip.id);
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ActiveTripScreen(trip: accepted)))
          .then((_) => _refresh());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        _refresh();
      }
    }
  }

  String _categoryLabel(String c) => switch (c) {
        'economy' => 'اقتصادية بريميوم',
        'plus' => 'بلس',
        'family' => 'فاخرة',
        _ => c,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرحلات المتاحة'),
        actions: [
          IconButton(icon: const Icon(Icons.account_balance_wallet_outlined), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EarningsScreen()))),
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()))),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          children: [
            SwitchListTile(
              title: Text(_online ? 'متصل - جاهز لاستقبال الرحلات' : 'غير متصل'),
              value: _online,
              activeColor: AppColors.accent,
              onChanged: (v) => setState(() => _online = v),
            ),
            Expanded(
              child: !_online
                  ? const Center(child: Text('فعّل الاتصال عشان تشوف الرحلات المتاحة', style: TextStyle(color: AppColors.textSecondary)))
                  : _loading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                      : _error != null
                          ? Center(child: Text(_error!, style: const TextStyle(color: AppColors.danger)))
                          : _trips.isEmpty
                              ? const Center(child: Text('مفيش رحلات متاحة دلوقتي', style: TextStyle(color: AppColors.textSecondary)))
                              : ListView.separated(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _trips.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                                  itemBuilder: (context, i) {
                                    final t = _trips[i];
                                    return Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(_categoryLabel(t.category), style: const TextStyle(fontWeight: FontWeight.w700)),
                                                const SizedBox(height: 4),
                                                Text('${t.pickupText ?? "نقطة الانطلاق"} ← ${t.dropoffText ?? "الوجهة"}',
                                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                                if (t.distanceKm != null)
                                                  Text('${t.distanceKm!.toStringAsFixed(1)} كم', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                              ],
                                            ),
                                          ),
                                          ElevatedButton(onPressed: () => _accept(t), child: const Text('قبول')),
                                        ],
                                      ),
                                    );
                                  },
                                ),
            ),
          ],
        ),
      ),
    );
  }
}
