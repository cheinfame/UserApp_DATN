// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      accountId: json['account_id'] as String?,
      username: json['username'] as String,
      password: json['password'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      shipper: json['shipper'] == null
          ? null
          : Shipper.fromJson(json['shipper'] as Map<String, dynamic>),
      wallet: Wallet.fromJson(json['wallet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'account_id': instance.accountId,
      'username': instance.username,
      'password': instance.password,
      'created_at': instance.createdAt?.toIso8601String(),
      'user': instance.user,
      'shipper': instance.shipper,
      'wallet': instance.wallet,
    };
