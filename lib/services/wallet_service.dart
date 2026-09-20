import '../core/api_client.dart';

class WalletService {
  static Future<Map<String, dynamic>> load() async {
    final res = await ApiClient.get('/driver/wallet', auth: true);
    return {
      'balance': double.tryParse(res['wallet']['balance'].toString()) ?? 0.0,
      'transactions': res['transactions'] as List<dynamic>,
    };
  }

  static Future<Map<String, dynamic>> withdraw(double amount) async {
    return await ApiClient.post('/driver/wallet/withdraw', {'amount': amount}, auth: true);
  }
}

class EarningsService {
  static Future<Map<String, dynamic>> load() async {
    return await ApiClient.get('/driver/earnings', auth: true);
  }
}
