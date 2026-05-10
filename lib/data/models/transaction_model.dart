import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class Transaction {
  String type;
  String status;

  @JsonKey(name: 'transaction_time')
  DateTime? transactionTime;

  Transaction({
    required this.type,
    required this.status,
    this.transactionTime,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
