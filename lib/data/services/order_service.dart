import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:packare/.const.dart';
import 'package:packare/data/models/order_feedback_model.dart';
import '../models/order_model.dart';
import '../models/package_model.dart';

class OrderNotFoundException implements Exception {
  final String message;

  OrderNotFoundException(this.message);

  @override
  String toString() => message;
}

class OrderService {
  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else if (response.statusCode == 404) {
      throw OrderNotFoundException(data['message'] ?? 'Order not found');
    } else if (response.statusCode == 400) {
      throw Exception(data['message'] ?? 'Bad request');
    } else {
      throw Exception(
          'Request failed with status: ${response.statusCode}. Response: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createOrder(String token, Order order) async {
    final url = Uri.parse('$baseUri/order/create-order');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(order.toJson()),
    );
    print(jsonEncode(order.toJson()));

    return await _handleResponse(response);
  }

  Future<Map<String, dynamic>> getOrdersByUser(
      String token, String userId) async {
    final url = Uri.parse('$baseUri/order/user/$userId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return await _handleResponse(response);
  }

  Future<Map<String, dynamic>> getOrderById(
      String token, String orderId) async {
    final url = Uri.parse('$baseUri/order/$orderId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return await _handleResponse(response);
  }

  Future<void> orderFeedback(
      String token, String orderId, OrderFeedback feedback) async {
    final url = Uri.parse('$baseUri/order/$orderId/feedback');

    // Include orderId in feedback JSON
    Map<String, dynamic> requestBody = feedback.toJson();
    requestBody['orderId'] = orderId;

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    await _handleResponse(response);
  }

  Future<Map<String, dynamic>> acceptOrder(String token, String orderId) async {
    final url = Uri.parse('$baseUri/order/$orderId/accept');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return await _handleResponse(response);
  }

  Future<void> verifyOrder(String token, String orderId) async {
    final url = Uri.parse('$baseUri/order/$orderId/verify');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    await _handleResponse(response);
  }

  Future<void> declineOrder(String token, String orderId) async {
    final url = Uri.parse('$baseUri/order/$orderId/decline');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    await _handleResponse(response);
  }

  Future<void> confirmPickup(String token, String orderId) async {
    final url = Uri.parse('$baseUri/order/$orderId/confirm-pickup');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    await _handleResponse(response);
  }

  Future<void> confirmDelivered(String token, String orderId) async {
    final url = Uri.parse('$baseUri/order/$orderId/confirm-delivered');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    await _handleResponse(response);
  }

  Future<void> completeOrder(String token, String orderId) async {
    final url = Uri.parse('$baseUri/order/$orderId/complete');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    await _handleResponse(response);
  }

  Future<void> cancelOrder(String token, String orderId) async {
    final url = Uri.parse('$baseUri/order/$orderId/cancel');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    await _handleResponse(response);
  }

  Future<Map<String, dynamic>> viewOrderHistory(String token) async {
    final url = Uri.parse('$baseUri/order/history');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return await _handleResponse(response);
  }

  Future<Map<String, dynamic>> getOrderPackages(
      String token, String orderId) async {
    final url = Uri.parse('$baseUri/order/$orderId/packages');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return await _handleResponse(response);
  }

  Future<void> updatePackage(
      String token, String orderId, String packageId, Package package) async {
    final url = Uri.parse('$baseUri/order/$orderId/packages/$packageId/update');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(package.toJson()),
    );

    await _handleResponse(response);
  }

  Future<void> deletePackage(
      String token, String orderId, String packageId) async {
    final url = Uri.parse('$baseUri/order/$orderId/packages/$packageId/delete');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    await _handleResponse(response);
  }

  Future<Map<String, dynamic>> calculateShippingPrice(
      String token, Map<String, dynamic> coordinates) async {
    final url = Uri.parse('$baseUri/order/calculate-shipping-price');

    // Modify the coordinates map to match the desired structure
    final Map<String, dynamic> body = {
      'sendCoords': {
        'lat': coordinates['sendLat'],
        'lng': coordinates['sendLng'],
      },
      'receiveCoords': {
        'lat': coordinates['receiveLat'],
        'lng': coordinates['receiveLng'],
      },
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    return await _handleResponse(response);
  }
}
