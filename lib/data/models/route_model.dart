// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'geojson_model.dart';

part 'route_model.g.dart';

enum RouteDirection {
  startToEnd,
  endToStart,
  twoWay,
}

String routeDirectionToString(RouteDirection direction) {
  switch (direction) {
    case RouteDirection.startToEnd:
      return "Start to End";
    case RouteDirection.endToStart:
      return "End to Start";
    case RouteDirection.twoWay:
      return "Two Way";
    default:
      return "Unknown";
  }
}

RouteDirection stringToRouteDirection(String direction) {
  switch (direction) {
    case "Start to End" || "start_to_end":
      return RouteDirection.startToEnd;
    case "End to Start" || "end_to_start":
      return RouteDirection.endToStart;
    case "Two Way" || "two_way":
      return RouteDirection.twoWay;
    default:
      return RouteDirection
          .startToEnd; // Default to start_to_end if unknown direction
  }
}

@JsonSerializable()
class Route {
  @JsonKey(name: '_id')
  String? routeId;

  @JsonKey(name: 'shipper_id')
  String shipperId;

  @JsonKey(name: 'route_name')
  String? routeName;

  @JsonKey(defaultValue: true)
  bool isActive;

  @JsonKey(name: 'route_direction', required: true)
  RouteDirection routeDirection;

  @JsonKey(name: 'start_location', required: true)
  String startLocation;

  @JsonKey(name: 'start_coordinates')
  GeoJson startCoordinates;

  @JsonKey(name: 'end_location', required: true)
  String endLocation;

  @JsonKey(name: 'end_coordinates')
  GeoJson endCoordinates;

  @JsonKey(defaultValue: false)
  bool isVirtual;

  double distance;

  double duration;

  List<List<double>> geometry;

  Route({
    this.routeId,
    required this.shipperId,
    this.routeName,
    this.isActive = true,
    required this.routeDirection,
    required this.startLocation,
    required this.startCoordinates,
    required this.endLocation,
    required this.endCoordinates,
    this.isVirtual = false,
    required this.distance,
    required this.duration,
    required this.geometry,
  });

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);

  Map<String, dynamic> toJson() => _$RouteToJson(this);

  Route copyWith({
    String? routeId,
    String? shipperId,
    String? routeName,
    bool? isActive,
    RouteDirection? routeDirection,
    String? startLocation,
    GeoJson? startCoordinates,
    String? endLocation,
    GeoJson? endCoordinates,
    bool? isVirtual,
    double? distance,
    double? duration,
    List<List<double>>? geometry,
  }) {
    return Route(
      routeId: routeId ?? this.routeId,
      shipperId: shipperId ?? this.shipperId,
      routeName: routeName ?? this.routeName,
      isActive: isActive ?? this.isActive,
      routeDirection: routeDirection ?? this.routeDirection,
      startLocation: startLocation ?? this.startLocation,
      startCoordinates: startCoordinates ?? this.startCoordinates,
      endLocation: endLocation ?? this.endLocation,
      endCoordinates: endCoordinates ?? this.endCoordinates,
      isVirtual: isVirtual ?? this.isVirtual,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      geometry: geometry ?? this.geometry,
    );
  }
}
