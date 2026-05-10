// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'package_model.g.dart';

@JsonSerializable()
class Package {
  @JsonKey(name: 'package_name')
  String packageName;

  @JsonKey(name: 'package_description')
  String? packageDescription;

  @JsonKey(name: 'package_price')
  double packagePrice;

  @JsonKey(name: 'package_image_url')
  String? packageImageUrl;

  Package({
    required this.packageName,
    this.packageDescription,
    required this.packagePrice,
    this.packageImageUrl,
  });

  factory Package.fromJson(Map<String, dynamic> json) =>
      _$PackageFromJson(json);

  Map<String, dynamic> toJson() => _$PackageToJson(this);

  Package copyWith({
    String? packageName,
    String? packageDescription,
    double? packagePrice,
    String? packageImageUrl,
  }) {
    return Package(
      packageName: packageName ?? this.packageName,
      packageDescription: packageDescription ?? this.packageDescription,
      packagePrice: packagePrice ?? this.packagePrice,
      packageImageUrl: packageImageUrl ?? this.packageImageUrl,
    );
  }
}
