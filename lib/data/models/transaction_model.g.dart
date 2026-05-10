// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      type: json['type'] as String,
      status: json['status'] as String,
      transactionTime: json['transaction_time'] == null
          ? null
          : DateTime.parse(json['transaction_time'] as String),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'type': instance.type,
      'status': instance.status,
      'transaction_time': instance.transactionTime?.toIso8601String(),
    };
