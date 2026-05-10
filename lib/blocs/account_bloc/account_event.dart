part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AccountEvent {
  final String username;
  final String password;

  LoginEvent({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class SignUpEvent extends AccountEvent {
  final Account account;

  SignUpEvent({required this.account});

  @override
  List<Object?> get props => [account];
}

class LogoutEvent extends AccountEvent {}

class LoginWithCache extends AccountEvent {}

class UpdateUserProfileEvent extends AccountEvent {
  final Account account;

  UpdateUserProfileEvent({required this.account});

  @override
  List<Object?> get props => [account];
}

class GetUserProfileEvent extends AccountEvent {
  final String userId;

  GetUserProfileEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ChangePasswordEvent extends AccountEvent {
  final String currentPassword;
  final String newPassword;

  ChangePasswordEvent(
      {required this.currentPassword, required this.newPassword});

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class GetNotificationsEvent extends AccountEvent {
  final String userId;

  GetNotificationsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}