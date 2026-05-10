import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packare/blocs/account_bloc/account_bloc.dart';
import '../widgets/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Access the AccountBloc instance
    final accountBloc = BlocProvider.of<AccountBloc>(context);
    // Dispatch the GetNotificationsEvent to fetch notifications
    accountBloc.add(GetNotificationsEvent(userId: 'user_id_here'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          return _buildNotificationList(state);
        },
      ),
    );
  }

  Widget _buildNotificationList(AccountState state) {
    if (state.status == AccountStatus.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state.status == AccountStatus.success) {
      final notifications = state.account?.user.notifications ?? [];
      if (notifications.isEmpty) {
        return Center(
          child: Text('No notifications'),
        );
      } else {
        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationItem(notification: notification);
          },
        );
      }
    } else if (state.status == AccountStatus.failed) {
      return Center(
        child: Text('Failed to load notifications'),
      );
    } else {
      return Container();
    }
  }
}
