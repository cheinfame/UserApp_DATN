import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class Notification {
  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'timestamp')
  DateTime timestamp;

  @JsonKey(name: 'isSent')
  bool isSent;

  @JsonKey(name: 'isRead')
  bool isRead;

  Notification({
    required this.title,
    required this.content,
    required this.timestamp,
    required this.isSent,
    required this.isRead,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}