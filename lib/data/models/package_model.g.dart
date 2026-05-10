// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Package _$PackageFromJson(Map<String, dynamic> json) => Package(
      packageName: json['package_name'] as String,
      packageDescription: json['package_description'] as String?,
      packagePrice: (json['package_price'] as num).toDouble(),
      packageImageUrl: json['package_image_url'] as String?,
    );

Map<String, dynamic> _$PackageToJson(Package instance) => <String, dynamic>{
      'package_name': instance.packageName,
      'package_description': instance.packageDescription,
      'package_price': instance.packagePrice,
      'package_image_url': instance.packageImageUrl,
    };
