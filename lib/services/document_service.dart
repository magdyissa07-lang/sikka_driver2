import '../core/api_client.dart';

class DocumentService {
  static Future<void> upload({required String type, required String filePath, String? expiryDate}) async {
    await ApiClient.uploadFile('/driver/documents', filePath, {
      'type': type,
      if (expiryDate != null) 'expiry_date': expiryDate,
    });
  }

  static Future<List<dynamic>> list() async {
    final res = await ApiClient.get('/driver/documents', auth: true);
    return res['documents'];
  }
}
