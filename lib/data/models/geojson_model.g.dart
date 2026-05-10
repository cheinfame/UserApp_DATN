// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geojson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoJson _$GeoJsonFromJson(Map<String, dynamic> json) => GeoJson(
      type: json['type'] as String? ?? 'Point',
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$GeoJsonToJson(GeoJson instance) => <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };
