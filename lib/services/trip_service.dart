import '../core/api_client.dart';
import '../models/driver_trip.dart';

class TripService {
  static Future<List<DriverTrip>> available() async {
    final res = await ApiClient.get('/driver/trips/available', auth: true);
    final List trips = res['trips'];
    return trips.map((t) => DriverTrip.fromJson(t)).toList();
  }

  static Future<DriverTrip> accept(int tripId) async {
    final res = await ApiClient.post('/driver/trips/$tripId/accept', {}, auth: true);
    return DriverTrip.fromJson(res['trip']);
  }

  static Future<DriverTrip> start(int tripId) async {
    final res = await ApiClient.post('/driver/trips/$tripId/start', {}, auth: true);
    return DriverTrip.fromJson(res['trip']);
  }

  static Future<DriverTrip> complete(int tripId, double finalFare) async {
    final res = await ApiClient.post('/driver/trips/$tripId/complete', {'final_fare': finalFare}, auth: true);
    return DriverTrip.fromJson(res['trip']);
  }
}
