import 'dart:async'; // Import dart:async for timeout
import 'dart:io'; // Import for SocketException
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/models/account_model.dart';
import 'package:flutter/services.dart';
import '../../data/services/user_service.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AuthRepositoryImpl authRepository;
  final UserRepositoryImpl userRepository;

  AccountBloc({
    required this.authRepository,
    required this.userRepository,
  }) : super(AccountState(
          status: AccountStatus.initial,
          error: null,
        )) {
    on<LoginEvent>(_onLoginEvent);
    on<SignUpEvent>(_onSignUpEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<LoginWithCache>(_onLoginWithCache);
    on<UpdateUserProfileEvent>(_onUpdateUserProfileEvent);
    on<ChangePasswordEvent>(_onChangePasswordEvent);
    on<GetNotificationsEvent>(_onGetNotificationsEvent);
    on<GetUserProfileEvent>(_onGetUserProfileEvent);
  }

  void _onGetUserProfileEvent (GetUserProfileEvent event, Emitter<AccountState> emit) async {
     emit(state.copyWith(status: AccountStatus.loading));
    try {
      final account = await userRepository
          .getUserProfile(event.userId)
          .timeout(const Duration(seconds: 30));

      emit(state.copyWith(status: AccountStatus.success, account: account));
    } catch (error) {
      emit(state.copyWith(
          status: AccountStatus.failed,
          error: (error is TimeoutException)
              ? 'The request timed out. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onGetNotificationsEvent(
  GetNotificationsEvent event, Emitter<AccountState> emit) async {
  emit(state.copyWith(status: AccountStatus.loading));
  try {
    final userId = event.userId;

    // Fetch notifications from the repository
    List<Notification> notifications = await userRepository.getNotifications(userId);

    // Sort notifications by timestamp in descending order
    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Update the account state with sorted notifications
    emit(state.copyWith(
        status: AccountStatus.success,
        notifications: notifications,
        account: state.account?.copyWith(
            user: state.account?.user.copyWith(notifications: notifications))));
  } catch (error) {
    emit(state.copyWith(
        status: AccountStatus.failed,
        error: (error is TimeoutException)
            ? 'The request timed out. Please check your internet connection and try again.'
            : (error is SocketException)
                ? 'Network error occurred. Please check your internet connection and try again.'
                : 'An unexpected error occurred while fetching notifications. Please try again later.'));
  }
}


  void _onLoginEvent(LoginEvent event, Emitter<AccountState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    try {
      final account = await authRepository
          .login(event.username, event.password)
          .timeout(const Duration(seconds: 30));

      emit(state.copyWith(loginStatus: LoginStatus.login, account: account));
    } catch (error) {
      emit(state.copyWith(
          loginStatus: LoginStatus.failed,
          error: (error is TimeoutException)
              ? 'The request timed out. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onSignUpEvent(SignUpEvent event, Emitter<AccountState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    try {
      final account = await authRepository
          .signUp(event.account)
          .timeout(const Duration(seconds: 30));

      emit(state.copyWith(loginStatus: LoginStatus.login, account: account));
    } catch (error) {
      emit(state.copyWith(
          loginStatus: LoginStatus.failed,
          error: (error is TimeoutException)
              ? 'The request timed out. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onLogoutEvent(LogoutEvent event, Emitter<AccountState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    try {
      await authRepository.logout().timeout(const Duration(seconds: 30));

      emit(state.copyWith(loginStatus: LoginStatus.notLogin));
    } catch (error) {
      emit(state.copyWith(
          loginStatus: LoginStatus.failed,
          error: (error is TimeoutException)
              ? 'The request timed out. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onLoginWithCache(
      LoginWithCache event, Emitter<AccountState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    try {
      final account = await authRepository.loginWithCache();

      emit(state.copyWith(loginStatus: LoginStatus.login, account: account));
    } catch (error) {
      emit(state.copyWith(
          loginStatus: LoginStatus.failed,
          error: (error is TimeoutException)
              ? 'The request timed out. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onUpdateUserProfileEvent(
      UpdateUserProfileEvent event, Emitter<AccountState> emit) async {
    emit(state.copyWith(status: AccountStatus.loading));
    try {
      final updatedAccount = await userRepository
          .updateUserProfile(event.account)
          .timeout(const Duration(seconds: 30));

      emit(state.copyWith(
          status: AccountStatus.success, account: updatedAccount));
    } catch (error) {
      emit(state.copyWith(
          status: AccountStatus.failed,
          error: (error is TimeoutException)
              ? 'The request timed out. Please check your internet connection and try again.'
              : (error is SocketException)
                  ? 'Network error occurred. Please check your internet connection and try again.'
                  : (error is PlatformException)
                      ? 'Failed to update user profile. Please try again later.'
                      : 'An unexpected error occurred while updating user profile. Please try again later.'));
    }
  }

  void _onChangePasswordEvent(
      ChangePasswordEvent event, Emitter<AccountState> emit) async {
    emit(state.copyWith(status: AccountStatus.loading));
    try {
      await userRepository
          .changePassword(event.currentPassword, event.newPassword)
          .timeout(const Duration(seconds: 30));

      emit(state.copyWith(status: AccountStatus.success));
    } catch (error) {
      emit(state.copyWith(
          status: AccountStatus.failed,
          error: (error is TimeoutException)
              ? 'The request timed out. Please check your internet connection and try again.'
              : (error is SocketException)
                  ? 'Network error occurred. Please check your internet connection and try again.'
                  : (error is PasswordChangeFailedException)
                      ? error.message
                      : 'An unexpected error occurred while changing password. Please try again later.'));
    }
  }
}
