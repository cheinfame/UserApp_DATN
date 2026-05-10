// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      userId: json['user_id'] as String,
      balance: (json['balance'] as num).toDouble(),
      transactionHistory: (json['transaction_history'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      'user_id': instance.userId,
      'balance': instance.balance,
      'transaction_history': instance.transactionHistory,
    };
