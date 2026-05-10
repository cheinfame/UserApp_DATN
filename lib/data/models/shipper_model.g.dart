// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipper_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shipper _$ShipperFromJson(Map<String, dynamic> json) => Shipper(
      shipperId: json['shipper_id'] as String,
      shippedOrders: (json['shipped_orders'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      routes:
          (json['routes'] as List<dynamic>).map((e) => e as String).toList(),
      maxDistanceAllowance:
          (json['max_distance_allowance'] as num?)?.toDouble() ?? 2.0,
    );

Map<String, dynamic> _$ShipperToJson(Shipper instance) => <String, dynamic>{
      'shipper_id': instance.shipperId,
      'shipped_orders': instance.shippedOrders,
      'routes': instance.routes,
      'max_distance_allowance': instance.maxDistanceAllowance,
    };
