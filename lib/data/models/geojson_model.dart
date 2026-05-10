import 'package:json_annotation/json_annotation.dart';

part 'geojson_model.g.dart';

@JsonSerializable()
class GeoJson {
  @JsonKey(name: 'type', defaultValue: 'Point')
  final String type;

  @JsonKey(name: 'coordinates')
  final List<double> coordinates;

  GeoJson({required this.type, required this.coordinates});

  factory GeoJson.fromJson(Map<String, dynamic> json) =>
      _$GeoJsonFromJson(json);

  Map<String, dynamic> toJson() => _$GeoJsonToJson(this);
}
