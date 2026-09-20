/// باك إند وهمي لتطبيق السائق، بنفس فكرة تطبيق الراكب تمامًا.
/// ملحوظة مهمة: الوضع ده شغال جوه كل تطبيق لوحده في الذاكرة، يعني رحلة
/// وهمية بتظهر هنا مش هي نفسها اللي بيطلبها تطبيق الراكب - مفيش سيرفر
/// حقيقي بيربط بينهم دلوقتي. التزامن الفعلي بين التطبيقين هيحصل أول ما
/// نوصل السيرفر الحقيقي (sikka-backend) ونقفل demoMode في التطبيقين.
library;

class DemoBackend {
  DemoBackend._();

  static int _idSeq = 2000;
  static int _nextId() => _idSeq++;
  static final DateTime _startedAt = DateTime.now();

  static final Map<int, Map<String, dynamic>> _trips = {};
  static bool _incomingTripCreated = false;

  static final List<Map<String, dynamic>> _documents = [
    {'id': 1, 'type': 'license', 'status': 'approved', 'expiry_date': '2027-03-01'},
    {'id': 2, 'type': 'car_registration', 'status': 'approved', 'expiry_date': '2027-01-15'},
    {'id': 3, 'type': 'insurance', 'status': 'pending', 'expiry_date': null},
  ];

  static double _walletBalance = 340.0;
  static final List<Map<String, dynamic>> _walletTx = [
    {'id': 1, 'type': 'credit', 'amount': 210.0, 'reason': 'trip_payment', 'created_at': '2026-09-18'},
    {'id': 2, 'type': 'debit', 'amount': 42.0, 'reason': 'commission_deduction', 'created_at': '2026-09-18'},
  ];

  static final List<Map<String, dynamic>> _supportTickets = [];

  static Future<Map<String, dynamic>> handle(String method, String path, Map<String, dynamic>? body) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();

    if (method == 'POST' && path == '/driver/register') {
      return {'message': 'تم الإرسال، كود التجربة هو 1234', 'phone': body?['phone']};
    }
    if (method == 'POST' && path == '/driver/verify-otp') {
      return {
        'token': 'demo-token-driver',
        'driver': {'id': 1, 'full_name': 'كريم عادل', 'status': 'active'},
      };
    }
    if (method == 'POST' && path == '/driver/resend-otp') {
      return {'message': 'تم إعادة الإرسال، كود التجربة هو 1234'};
    }

    if (method == 'POST' && path == '/driver/documents') {
      return {'message': 'تم رفع المستند، في انتظار المراجعة'};
    }
    if (method == 'GET' && path == '/driver/documents') {
      return {'documents': _documents};
    }

    if (method == 'GET' && path == '/driver/trips/available') {
      final elapsed = DateTime.now().difference(_startedAt).inSeconds;
      if (!_incomingTripCreated && elapsed >= 3) {
        _incomingTripCreated = true;
        final id = _nextId();
        _trips[id] = {
          'id': id,
          'status': 'requested',
          'category': 'economy',
          'pickup_text': 'بيفرلي هيلز، فيلا 12',
          'dropoff_text': 'مول مصر',
          'distance_km': 6.2,
          'estimated_fare': 38,
          'final_fare': null,
          'commission_amount': null,
          'driver_net_amount': null,
          'payment_method': 'cash',
        };
      }
      final available = _trips.values.where((t) => t['status'] == 'requested').toList();
      return {'trips': available};
    }
    if (method == 'POST' && segments.length == 4 && segments[1] == 'trips' && segments[3] == 'accept') {
      final id = int.parse(segments[2]);
      _trips[id]?['status'] = 'accepted';
      return {'trip': _trips[id]};
    }
    if (method == 'POST' && segments.length == 4 && segments[1] == 'trips' && segments[3] == 'start') {
      final id = int.parse(segments[2]);
      _trips[id]?['status'] = 'in_progress';
      return {'trip': _trips[id]};
    }
    if (method == 'POST' && segments.length == 4 && segments[1] == 'trips' && segments[3] == 'complete') {
      final id = int.parse(segments[2]);
      final trip = _trips[id]!;
      final fare = double.tryParse(body?['final_fare'].toString() ?? '') ?? (trip['estimated_fare'] as num).toDouble();
      final commission = fare * 0.20;
      trip['status'] = 'completed';
      trip['final_fare'] = fare;
      trip['commission_amount'] = commission;
      trip['driver_net_amount'] = fare - commission;
      return {'trip': trip};
    }

    if (method == 'GET' && path == '/driver/wallet') {
      return {
        'wallet': {'balance': _walletBalance},
        'transactions': _walletTx,
      };
    }
    if (method == 'POST' && path == '/driver/wallet/withdraw') {
      final amount = double.tryParse(body?['amount'].toString() ?? '0') ?? 0;
      if (amount > _walletBalance) {
        return {'error': 'الرصيد غير كافٍ'};
      }
      _walletBalance -= amount;
      _walletTx.insert(0, {'id': _nextId(), 'type': 'debit', 'amount': amount, 'reason': 'payout', 'created_at': 'الآن'});
      return {'wallet': {'balance': _walletBalance}};
    }

    if (method == 'GET' && path == '/driver/earnings') {
      return {
        'today': {'trips': 5, 'earnings': 210},
        'this_week': {'trips': 28, 'earnings': 1240},
        'pending_commission_debt': 84,
        'next_payout_date': 'الأحد القادم',
      };
    }

    if (method == 'POST' && path == '/driver/ratings') {
      return {'message': 'شكرًا لتقييمك'};
    }

    if (method == 'GET' && path == '/driver/support-tickets') {
      return {'support_tickets': _supportTickets};
    }
    if (method == 'POST' && path == '/driver/support-tickets') {
      final ticket = {
        'id': _nextId(),
        'category': body?['category'],
        'description': body?['description'],
        'status': 'open',
        'created_at': 'الآن',
      };
      _supportTickets.insert(0, ticket);
      return {'support_ticket': ticket};
    }

    return {};
  }
}
