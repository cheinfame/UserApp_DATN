// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Route _$RouteFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['route_direction', 'start_location', 'end_location'],
  );
  return Route(
    routeId: json['_id'] as String?,
    shipperId: json['shipper_id'] as String,
    routeName: json['route_name'] as String?,
    isActive: json['isActive'] as bool? ?? true,
    routeDirection:
        $enumDecode(_$RouteDirectionEnumMap, json['route_direction']),
    startLocation: json['start_location'] as String,
    startCoordinates:
        GeoJson.fromJson(json['start_coordinates'] as Map<String, dynamic>),
    endLocation: json['end_location'] as String,
    endCoordinates:
        GeoJson.fromJson(json['end_coordinates'] as Map<String, dynamic>),
    isVirtual: json['isVirtual'] as bool? ?? false,
    distance: (json['distance'] as num).toDouble(),
    duration: (json['duration'] as num).toDouble(),
    geometry: (json['geometry'] as List<dynamic>)
        .map((e) =>
            (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
        .toList(),
  );
}

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
      '_id': instance.routeId,
      'shipper_id': instance.shipperId,
      'route_name': instance.routeName,
      'isActive': instance.isActive,
      'route_direction': _$RouteDirectionEnumMap[instance.routeDirection]!,
      'start_location': instance.startLocation,
      'start_coordinates': instance.startCoordinates,
      'end_location': instance.endLocation,
      'end_coordinates': instance.endCoordinates,
      'isVirtual': instance.isVirtual,
      'distance': instance.distance,
      'duration': instance.duration,
      'geometry': instance.geometry,
    };

const _$RouteDirectionEnumMap = {
  RouteDirection.startToEnd: 'startToEnd',
  RouteDirection.endToStart: 'endToStart',
  RouteDirection.twoWay: 'twoWay',
};
