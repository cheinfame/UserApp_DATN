import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../.const.dart';
import '../models/account_model.dart';

class AuthService {
  AuthService();

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final Map<String, dynamic> data = jsonDecode(response.body);
    print(data['token']);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (data['token'] != null && data['account'] != null) {
        return {'account': data['account'], 'token': data['token']};
      } else {
        throw Exception('Invalid response');
      }
    } else if (response.statusCode == 400) {
      throw Exception(data['message'] ?? 'Bad request');
    } else if (response.statusCode == 401) {
      throw Exception(data['message'] ?? 'Unauthorized');
    } else {
      throw Exception(
          'Request failed with status: ${response.statusCode}. Response: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print(jsonEncode({'username': username, 'password': password}));
      final response = await http.post(
        Uri.parse('$baseUri/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'username': username, 'password': password}),
      );

      return await _handleResponse(response);
    } catch (error) {
      print('Error during login: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> signUp(Account account) async {
    try {
      final accountData = jsonEncode({
        'username': account.username,
        'password': account.password,
        'first_name': account.user.firstName,
        'last_name': account.user.lastName,
        'phone_number': account.user.phoneNumber
      });

      print(accountData);

      final response = await http.post(
        Uri.parse('$baseUri/auth/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: accountData,
      );

      return await _handleResponse(response);
    } catch (error) {
      print('Error during signup: $error');
      rethrow;
    }
  }
}
