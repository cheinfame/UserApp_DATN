// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'account_model.dart';
import 'geojson_model.dart';
import 'order_feedback_model.dart';
import 'package_model.dart';

part 'order_model.g.dart';

// Define the OrderStatus enum
enum OrderStatus {
  waiting,
  verified,
  declined,
  shipperAccepted,
  startShipping,
  cancelled,
  shipperPickedUp,
  delivered,
  completed,
}

String orderStatusMapping(OrderStatus status) {
  switch (status) {
    case OrderStatus.waiting:
      return "Waiting";
    case OrderStatus.verified:
      return "Verified";
    case OrderStatus.declined:
      return "Declined";
    case OrderStatus.shipperAccepted:
      return "Accepted";
    case OrderStatus.startShipping:
      return "On The Way";
    case OrderStatus.cancelled:
      return "Cancelled";
    case OrderStatus.shipperPickedUp:
      return "Picked Up";
    case OrderStatus.delivered:
      return "Delivered";
    case OrderStatus.completed:
      return "Completed";
    default:
      return "Unknown";
  }
}

@JsonSerializable()
class Order {
  Account? shipper;

  @JsonKey(name: 'order_id')
  final String orderId;

  final List<Package> packages;

  OrderFeedback? feedback;

  @JsonKey(name: 'sender_id')
  final String senderId;

  @JsonKey(name: 'shipper_id')
  final String? shipperId;

  @JsonKey(name: 'receiver_name')
  final String receiverName;

  @JsonKey(name: 'receiver_phone')
  final String receiverPhone;

  @JsonKey(name: 'sender_paid')
  final double? shippingPrice;

  @JsonKey(name: 'send_address')
  final String sendAddress;

  @JsonKey(name: 'send_coordinates')
  final GeoJson sendCoordinates;

  @JsonKey(name: 'delivery_address')
  final String deliveryAddress;

  @JsonKey(name: 'delivery_coordinates')
  final GeoJson deliveryCoordinates;

  @JsonKey(name: 'create_time', defaultValue: null)
  final DateTime? createTime;

  @JsonKey(fromJson: _orderStatusFromJson, toJson: _orderStatusToJson)
   OrderStatus status;

  @JsonKey(name: 'status_change_time', defaultValue: null)
   DateTime? statusChangeTime;

  @JsonKey(name: 'preferred_pickup_start_time', defaultValue: null)
  final DateTime? preferredPickupStartTime;

  @JsonKey(name: 'preferred_pickup_end_time', defaultValue: null)
  final DateTime? preferredPickupEndTime;

  @JsonKey(name: 'preferred_delivery_start_time', defaultValue: null)
  final DateTime? preferredDeliveryStartTime;

  @JsonKey(name: 'preferred_delivery_end_time', defaultValue: null)
  final DateTime? preferredDeliveryEndTime;

  @JsonKey(name: 'order_lasting_time', defaultValue: null)
  final DateTime? orderLastingTime;

  Order({
    this.shipper,
    required this.orderId,
    required this.packages,
    this.feedback,
    required this.senderId,
    this.shipperId,
    required this.receiverName,
    required this.receiverPhone,
    this.shippingPrice,
    required this.sendAddress,
    required this.sendCoordinates,
    required this.deliveryAddress,
    required this.deliveryCoordinates,
    this.createTime,
    required this.status,
    this.statusChangeTime,
    this.preferredPickupStartTime,
    this.preferredPickupEndTime,
    this.preferredDeliveryStartTime,
    this.preferredDeliveryEndTime,
    this.orderLastingTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
  static OrderStatus _orderStatusFromJson(String status) {
    switch (status) {
      case 'waiting':
        return OrderStatus.waiting;
      case 'verified':
        return OrderStatus.verified;
      case 'declined':
        return OrderStatus.declined;
      case 'start_shipping':
        return OrderStatus.startShipping;
      case 'shipper_accepted':
        return OrderStatus.shipperAccepted;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'shipper_picked_up':
        return OrderStatus.shipperPickedUp;
      case 'delivered':
        return OrderStatus.delivered;
      case 'completed':
        return OrderStatus.completed;
      default:
        return OrderStatus.waiting;
    }
  }

  static String _orderStatusToJson(OrderStatus status) {
    switch (status) {
      case OrderStatus.waiting:
        return 'waiting';
      case OrderStatus.verified:
        return 'verified';
      case OrderStatus.declined:
        return 'declined';
      case OrderStatus.shipperAccepted:
        return 'shipper_accepted';
      case OrderStatus.startShipping:
        return 'start_shipping';
      case OrderStatus.cancelled:
        return 'cancelled';
      case OrderStatus.shipperPickedUp:
        return 'shipper_picked_up';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.completed:
        return 'completed';
      default:
        return 'waiting';
    }
  }

  Order copyWith({
    Account? shipper,
    String? orderId,
    List<Package>? packages,
    OrderFeedback? feedback,
    String? senderId,
    String? shipperId,
    String? receiverName,
    String? receiverPhone,
    double? shippingPrice,
    String? sendAddress,
    GeoJson? sendCoordinates,
    String? deliveryAddress,
    GeoJson? deliveryCoordinates,
    DateTime? createTime,
    OrderStatus? status,
    DateTime? statusChangeTime,
    DateTime? preferredPickupStartTime,
    DateTime? preferredPickupEndTime,
    DateTime? preferredDeliveryStartTime,
    DateTime? preferredDeliveryEndTime,
    DateTime? orderLastingTime,
  }) {
    return Order(
      shipper: shipper ?? this.shipper,
      orderId: orderId ?? this.orderId,
      packages: packages ?? this.packages,
      feedback: feedback ?? this.feedback,
      senderId: senderId ?? this.senderId,
      shipperId: shipperId ?? this.shipperId,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      shippingPrice: shippingPrice ?? this.shippingPrice,
      sendAddress: sendAddress ?? this.sendAddress,
      sendCoordinates: sendCoordinates ?? this.sendCoordinates,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryCoordinates: deliveryCoordinates ?? this.deliveryCoordinates,
      createTime: createTime ?? this.createTime,
      status: status ?? this.status,
      statusChangeTime: statusChangeTime ?? this.statusChangeTime,
      preferredPickupStartTime:
          preferredPickupStartTime ?? this.preferredPickupStartTime,
      preferredPickupEndTime:
          preferredPickupEndTime ?? this.preferredPickupEndTime,
      preferredDeliveryStartTime:
          preferredDeliveryStartTime ?? this.preferredDeliveryStartTime,
      preferredDeliveryEndTime:
          preferredDeliveryEndTime ?? this.preferredDeliveryEndTime,
      orderLastingTime: orderLastingTime ?? this.orderLastingTime,
    );
  }
}
