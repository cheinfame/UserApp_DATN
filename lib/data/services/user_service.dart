import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:packare/.const.dart';
import '../models/user_model.dart';

class UserProfileNotFoundException implements Exception {
  final String message;

  UserProfileNotFoundException(this.message);

  @override
  String toString() => message;
}

class PasswordChangeFailedException implements Exception {
  final String message;

  PasswordChangeFailedException(this.message);

  @override
  String toString() => message;
}

class UserService {
  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else if (response.statusCode == 404) {
      throw UserProfileNotFoundException(data['message'] ?? 'User not found');
    } else if (response.statusCode == 400) {
      throw PasswordChangeFailedException(data['message'] ?? 'Bad request');
    } else {
      throw Exception(
          'Request failed with status: ${response.statusCode}. Response: ${response.body}');
    }
  }

Future<List<Map<String, dynamic>>> getNotifications(String token, String userId) async {
  final url = Uri.parse('$baseUri/user/$userId/get-notifications');
  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'},
  );

  final Map<String, dynamic> data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    final notifications = List<Map<String, dynamic>>.from(data['notifications']);
    return notifications;
  } else {
    throw Exception('Failed to fetch notifications: ${data['message']}');
  }
}


Future<Map<String, dynamic>> getUserProfile(String token, String userId) async {
    final url = Uri.parse('$baseUri/user/$userId/get-profile');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return await _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateUserProfile(
      String token, User user) async {
    final url = Uri.parse('$baseUri/user/profile/update');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    return await _handleResponse(response);
  }

  Future<void> changePassword(
      String token, String currentPassword, String newPassword) async {
    final url = Uri.parse('$baseUri/user/profile/change-password');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    await _handleResponse(response);
  }
}
