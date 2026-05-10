// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:packare/data/models/package_model.dart';

class CreateOrderProcessState {
  final String sendLocation;
  final double sendLat;
  final double sendLng;
  final String receiveLocation;
  final double receiveLat;
  final double receiveLng;
  final DateTime preferredPickupStartTime;
  final DateTime preferredPickupEndTime;
  final String receiverName;
  final String receiverPhone;
  final DateTime preferredDeliveryStartTime;
  final DateTime preferredDeliveryEndTime;
  final List<Package> packages;
  final double shippingPrice;
  final double orderDistance;
  final DateTime orderLastingTime;

  CreateOrderProcessState({
    required this.sendLocation,
    required this.sendLat,
    required this.sendLng,
    required this.receiveLocation,
    required this.receiveLat,
    required this.receiveLng,
    required this.preferredPickupStartTime,
    required this.preferredPickupEndTime,
    required this.receiverName,
    required this.receiverPhone,
    required this.preferredDeliveryStartTime,
    required this.preferredDeliveryEndTime,
    required this.packages,
    required this.shippingPrice,
    required this.orderDistance,
    required this.orderLastingTime,
  });

  CreateOrderProcessState copyWith({
    String? sendLocation,
    double? sendLat,
    double? sendLng,
    String? receiveLocation,
    double? receiveLat,
    double? receiveLng,
    DateTime? preferredPickupStartTime,
    DateTime? preferredPickupEndTime,
    String? receiverName,
    String? receiverPhone,
    DateTime? preferredDeliveryStartTime,
    DateTime? preferredDeliveryEndTime,
    List<Package>? packages,
    double? shippingPrice,
    double? orderDistance,
    DateTime? orderLastingTime,
  }) {
    return CreateOrderProcessState(
      sendLocation: sendLocation ?? this.sendLocation,
      sendLat: sendLat ?? this.sendLat,
      sendLng: sendLng ?? this.sendLng,
      receiveLocation: receiveLocation ?? this.receiveLocation,
      receiveLat: receiveLat ?? this.receiveLat,
      receiveLng: receiveLng ?? this.receiveLng,
      preferredPickupStartTime:
          preferredPickupStartTime ?? this.preferredPickupStartTime,
      preferredPickupEndTime:
          preferredPickupEndTime ?? this.preferredPickupEndTime,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      preferredDeliveryStartTime:
          preferredDeliveryStartTime ?? this.preferredDeliveryStartTime,
      preferredDeliveryEndTime:
          preferredDeliveryEndTime ?? this.preferredDeliveryEndTime,
      packages: packages ?? this.packages,
      shippingPrice: shippingPrice ?? this.shippingPrice,
      orderDistance: orderDistance ?? this.orderDistance,
      orderLastingTime: orderLastingTime ?? this.orderLastingTime,
    );
  }
}
