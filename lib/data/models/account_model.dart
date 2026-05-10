// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'shipper_model.dart';
import 'user_model.dart';
import 'wallet_model.dart';

part 'account_model.g.dart';

@JsonSerializable()
class Account {
  @JsonKey(name: 'account_id')
  final String? accountId;

  final String username;
  String password;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  final User user;
  final Shipper? shipper;
  final Wallet wallet;


  Account( {
    this.accountId,
    required this.username,
    required this.password,
    this.createdAt,
    required this.user,
    this.shipper,
    required this.wallet,
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  Account copyWith({
    String? accountId,
    String? username,
    String? password,
    DateTime? createdAt,
    User? user,
    Shipper? shipper,
    Wallet? wallet,
  }) {
    return Account(
      accountId: accountId ?? this.accountId,
      username: username ?? this.username,
      password: password ?? this.password,
      createdAt :createdAt ?? this.createdAt,
      user: user ?? this.user,
      shipper: shipper ?? this.shipper,
      wallet: wallet ?? this.wallet,
    );
  }
}
