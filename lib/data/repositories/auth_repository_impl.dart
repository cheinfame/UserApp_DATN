import 'dart:convert';
import 'dart:io'; // Import SocketException
import '../models/account_model.dart';
import '../repositories/auth_repository.dart';
import '../services/auth_service.dart';
import '../services/shared_preferences_service.dart';
import 'package:flutter/services.dart'; // Import Flutter's PlatformException

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService; // Use AuthService
  final SharedPreferencesService sharedPreferencesService;

  AuthRepositoryImpl({
    required this.sharedPreferencesService,
    required AuthService authService, // Inject AuthService
  }) : _authService = authService; // Initialize AuthService

  @override
  Future<Account> loginWithCache() async {
    try {
      final token = sharedPreferencesService.getStringValue('token');
      final expirationTimeString =
          sharedPreferencesService.getStringValue('expirationTime');
      final accountData = sharedPreferencesService.getStringValue('account');

      if (token != null &&
          token.isNotEmpty &&
          accountData != null &&
          accountData.isNotEmpty) {
        final expirationTime = DateTime.parse(expirationTimeString!);

        if (DateTime.now().isBefore(expirationTime)) {
          final decodedAccount = Account.fromJson(jsonDecode(accountData));
          return decodedAccount;
        } else {
          // Token has expired, remove it from SharedPreferences
          await sharedPreferencesService.removeValue('token');
          await sharedPreferencesService.removeValue('expirationTime');
          await sharedPreferencesService.removeValue('account');
          throw PlatformException(
              code: 'TOKEN_EXPIRED', message: 'Token has expired.');
        }
      } else {
        throw Exception('Session has ended, please login again.');
      }
    } catch (error) {
      print('Error during login with cache: $error');
      throw Exception('Session has ended, please login again.');
    }
  }

  @override
  Future<Account> login(String username, String password) async {
    try {
      final response =
          await _authService.login(username, password); // Use AuthService

      // Parse account data and return
      final account = Account.fromJson(response['account']);
      account.password = '';

      final token = response['token'];
      final expirationTime = DateTime.now().add(const Duration(hours: 24));

      await sharedPreferencesService.setStringValue('token', token);
      await sharedPreferencesService.setStringValue(
          'expirationTime', expirationTime.toIso8601String());
      await sharedPreferencesService.setStringValue(
          'account', jsonEncode(account.toJson()));

      return account;
    } catch (error) {
      print('Error during login: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<Account> signUp(Account signUpAccount) async {
    try {
      final response =
          await _authService.signUp(signUpAccount); // Use AuthService

      // Parse account data and return
      final account = Account.fromJson(response['account']);
      account.password = '';

      final token = response['token'];
      final expirationTime = DateTime.now().add(const Duration(hours: 24));

      await sharedPreferencesService.setStringValue('token', token);
      await sharedPreferencesService.setStringValue(
          'expirationTime', expirationTime.toIso8601String());
      await sharedPreferencesService.setStringValue(
          'account', jsonEncode(account.toJson()));

      return account;
    } catch (error) {
      print('Error during signup: $error');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Clear token and account data from SharedPreferences
      await sharedPreferencesService.removeValue('token');
      await sharedPreferencesService.removeValue('account');
      await sharedPreferencesService.removeValue('expirationTime');
    } catch (error) {
      rethrow;
    }
  }
}
