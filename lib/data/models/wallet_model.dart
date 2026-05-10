// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'wallet_model.g.dart';

@JsonSerializable()
class Wallet {
  @JsonKey(name: 'user_id')
  String userId;

  double balance;

  @JsonKey(name: 'transaction_history')
  List<String> transactionHistory;

  Wallet({
    required this.userId,
    required this.balance,
    required this.transactionHistory,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  Map<String, dynamic> toJson() => _$WalletToJson(this);

  Wallet copyWith({
    String? userId,
    double? balance,
    List<String>? transactionHistory,
  }) {
    return Wallet(
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      transactionHistory: transactionHistory ?? this.transactionHistory,
    );
  }
}
