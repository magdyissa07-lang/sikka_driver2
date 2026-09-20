import '../core/api_client.dart';

class RatingService {
  static Future<void> rate({required int tripId, required int stars, String? comment}) async {
    await ApiClient.post('/driver/ratings', {
      'trip_id': tripId,
      'stars': stars,
      'comment': comment,
    }, auth: true);
  }
}

class SupportService {
  static Future<List<dynamic>> list() async {
    final res = await ApiClient.get('/driver/support-tickets', auth: true);
    return res['support_tickets'];
  }

  static Future<void> create({required String category, required String description}) async {
    await ApiClient.post('/driver/support-tickets', {
      'category': category,
      'description': description,
    }, auth: true);
  }
}
