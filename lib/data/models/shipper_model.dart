// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'shipper_model.g.dart';

@JsonSerializable()
class Shipper {
  @JsonKey(name: 'shipper_id')
  String shipperId;

  @JsonKey(name: 'shipped_orders')
  List<String> shippedOrders;

  List<String> routes;

  @JsonKey(name: 'max_distance_allowance', defaultValue: 2.0)
  double maxDistanceAllowance;

  Shipper({
    required this.shipperId,
    required this.shippedOrders,
    required this.routes,
    this.maxDistanceAllowance = 2.0,
  });

  factory Shipper.fromJson(Map<String, dynamic> json) =>
      _$ShipperFromJson(json);

  Map<String, dynamic> toJson() => _$ShipperToJson(this);

  Shipper copyWith({
    String? shipperId,
    List<String>? shippedOrders,
    List<String>? routes,
    double? maxDistanceAllowance,
  }) {
    return Shipper(
      shipperId: shipperId ?? this.shipperId,
      shippedOrders: shippedOrders ?? this.shippedOrders,
      routes: routes ?? this.routes,
      maxDistanceAllowance: maxDistanceAllowance ?? this.maxDistanceAllowance,
    );
  }
}
