class DriverTrip {
  final int id;
  final String status;
  final String category;
  final String? pickupText;
  final String? dropoffText;
  final double? distanceKm;
  final double? estimatedFare;
  final double? finalFare;
  final double? commissionAmount;
  final double? driverNetAmount;
  final String paymentMethod;

  DriverTrip({
    required this.id,
    required this.status,
    required this.category,
    this.pickupText,
    this.dropoffText,
    this.distanceKm,
    this.estimatedFare,
    this.finalFare,
    this.commissionAmount,
    this.driverNetAmount,
    required this.paymentMethod,
  });

  factory DriverTrip.fromJson(Map<String, dynamic> json) => DriverTrip(
        id: json['id'],
        status: json['status'],
        category: json['category'],
        pickupText: json['pickup_text'],
        dropoffText: json['dropoff_text'],
        distanceKm: json['distance_km'] != null ? double.tryParse(json['distance_km'].toString()) : null,
        estimatedFare: json['estimated_fare'] != null ? double.tryParse(json['estimated_fare'].toString()) : null,
        finalFare: json['final_fare'] != null ? double.tryParse(json['final_fare'].toString()) : null,
        commissionAmount: json['commission_amount'] != null ? double.tryParse(json['commission_amount'].toString()) : null,
        driverNetAmount: json['driver_net_amount'] != null ? double.tryParse(json['driver_net_amount'].toString()) : null,
        paymentMethod: json['payment_method'] ?? 'cash',
      );
}
