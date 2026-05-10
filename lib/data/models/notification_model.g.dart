// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      title: json['title'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isSent: json['isSent'] as bool,
      isRead: json['isRead'] as bool,
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
      'isSent': instance.isSent,
      'isRead': instance.isRead,
    };
