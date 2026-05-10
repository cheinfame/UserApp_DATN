import 'package:flutter/material.dart';
import '../../../data/models/notification_model.dart' as NotificationModel;

class NotificationItem extends StatelessWidget {
  final NotificationModel.Notification notification;

  const NotificationItem({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.notifications, 
        color: Theme.of(context).colorScheme.primary, 
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification.content),
          SizedBox(height: 8),
          Text(
            'Sent: ${_formatTimestamp(notification.timestamp)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      onTap: () {
        // Handle tap event here
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    // Format timestamp as desired
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}
