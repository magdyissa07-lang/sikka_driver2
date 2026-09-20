import '../core/api_client.dart';

class AuthService {
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String phone,
    required String nationalId,
    required String make,
    required String model,
    required int year,
    required String plateNumber,
    String category = 'economy',
    int seats = 4,
    String language = 'ar',
  }) async {
    return await ApiClient.post('/driver/register', {
      'full_name': fullName,
      'phone': phone,
      'national_id_number': nationalId,
      'language': language,
      'vehicle': {
        'make': make,
        'model': model,
        'year': year,
        'plate_number': plateNumber,
        'category': category,
        'seats': seats,
      },
    });
  }

  static Future<Map<String, dynamic>> verifyOtp(String phone, String code) async {
    final res = await ApiClient.post('/driver/verify-otp', {
      'phone': phone,
      'code': code,
    });
    if (res['token'] != null) {
      await ApiClient.saveToken(res['token']);
    }
    return res;
  }

  static Future<void> resendOtp(String phone) async {
    await ApiClient.post('/driver/resend-otp', {'phone': phone});
  }

  static Future<void> logout() async {
    await ApiClient.clearToken();
  }
}
