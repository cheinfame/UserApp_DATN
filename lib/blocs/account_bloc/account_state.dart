// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'account_bloc.dart';

enum AccountStatus { initial, loading, success, failed }

enum NotificationStatus { initial, loading, success, failed }

enum LoginStatus { login, loading, notLogin, failed }

class AccountState {
  AccountStatus status;
  Account? account;
  LoginStatus loginStatus;
  NotificationStatus notificationStatus;
  List<Notification> notifications;
  String? error;

  AccountState({
    this.status = AccountStatus.initial,
    this.account,
    this.loginStatus = LoginStatus.notLogin,
    this.notificationStatus = NotificationStatus.initial,
    this.notifications = const [],
    this.error,
  });

  AccountState copyWith({
    AccountStatus? status,
    Account? account,
    LoginStatus? loginStatus,
    NotificationStatus? notificationStatus,
    List<Notification>? notifications,
    String? error,
  }) {
    return AccountState(
      status: status ?? this.status,
      account: account ?? this.account,
      loginStatus: loginStatus ?? this.loginStatus,
      notificationStatus: notificationStatus ?? this.notificationStatus,
      notifications: notifications ?? this.notifications,
      error: error ?? this.error,
    );
  }
}
