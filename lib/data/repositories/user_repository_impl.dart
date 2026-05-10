import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../models/account_model.dart';
import '../services/shared_preferences_service.dart';
import '../services/user_service.dart';
import '../models/notification_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserService _userService;
  final SharedPreferencesService _sharedPreferencesService;

  UserRepositoryImpl({
    required UserService userApiService,
    required SharedPreferencesService sharedPreferencesService,
  })  : _userService = userApiService,
        _sharedPreferencesService = sharedPreferencesService;

  @override
  Future<List<Notification>> getNotifications(String userId) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      final notificationsJsonList =
          await _userService.getNotifications(token, userId);

      final List<Notification> notifications = [];
      for (var notificationJson in notificationsJsonList) {
        notifications.add(Notification.fromJson(notificationJson));
      }

      return notifications;
    } catch (error) {
      print('Error getting notifications: $error');
      if (error is SocketException) {
        throw Exception('Network error occurred');
      }
      rethrow;
    }
  }

  @override
  Future<Account> updateUserProfile(Account account) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      final response =
          await _userService.updateUserProfile(token, account.user);
      final updatedUser = User.fromJson(response['user']);

      // Update the user field in the existing account data
      final accountJson = _sharedPreferencesService.getStringValue('account');
      if (accountJson != null && accountJson.isNotEmpty) {
        final existingAccount = Account.fromJson(jsonDecode(accountJson));

        final updatedAccount = existingAccount.copyWith(user: updatedUser);

        await _sharedPreferencesService.setStringValue(
            'account', jsonEncode(updatedAccount.toJson()));

        return updatedAccount;
      } else {
        throw Exception('Account data not found');
      }
    } catch (error) {
      print('Error updating user profile: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      await _userService.changePassword(token, currentPassword, newPassword);
    } catch (error) {
      print('Error changing password: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<Account> getUserProfile(String id) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _userService.getUserProfile(token, id);

      final account = Account.fromJson(response['account']);

      return account;
    } catch (error) {
      print('Error getting profile: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }
}
