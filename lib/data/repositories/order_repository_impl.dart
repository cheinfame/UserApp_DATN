import 'dart:io';
import 'package:flutter/services.dart';
import 'package:packare/data/models/order_feedback_model.dart';

import '../models/order_model.dart';
import '../models/package_model.dart';
import '../repositories/order_repository.dart';
import '../services/shared_preferences_service.dart';
import '../services/order_service.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderService _orderService;
  final SharedPreferencesService _sharedPreferencesService;

  OrderRepositoryImpl({
    required OrderService orderApiService,
    required SharedPreferencesService sharedPreferencesService,
  })  : _orderService = orderApiService,
        _sharedPreferencesService = sharedPreferencesService;

  @override
  Future<Order> createOrder(Order order) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }
      final response = await _orderService.createOrder(token, order);
      final createdOrder = Order.fromJson(response['order']);

      

      return createdOrder;
    } catch (error) {
      print('Error creating order: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<Order> getOrderById(String orderId) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _orderService.getOrderById(token, orderId);
      return Order.fromJson(response['order']);
    } catch (error) {
      print('Error accepting order: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<List<Order>> getOrdersByUser(String userId) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _orderService.getOrdersByUser(token, userId);

      List<Order> orders = [];

      for (var order in response['orders']) {
        orders.add(Order.fromJson(order));
      }

      return orders;
    } catch (error) {
      print('Error retrieving orders for user: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<void> orderFeedback(String orderId, OrderFeedback feedback) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      await _orderService.orderFeedback(token, orderId, feedback);
    } catch (error) {
      print('Error providing order feedback: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<Order> acceptOrder(String orderId) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _orderService.acceptOrder(token, orderId);
      return Order.fromJson(response['order']);
    } catch (error) {
      print('Error accepting order: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<void> verifyOrder(String orderId) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      await _orderService.verifyOrder(token, orderId);
    } catch (error) {
      print('Error verifying order: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<void> declineOrder(String orderId) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      await _orderService.declineOrder(token, orderId);
    } catch (error) {
      print('Error declining order: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<void> confirmPickup(String orderId) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      await _orderService.confirmPickup(token, orderId);
    } catch (error) {
      print('Error confirming pickup: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<void> confirmDelivered(String orderId) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      await _orderService.confirmDelivered(token, orderId);
    } catch (error) {
      print('Error confirming delivered: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<void> completeOrder(String orderId) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      await _orderService.completeOrder(token, orderId);
    } catch (error) {
      print('Error completing order: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      await _orderService.cancelOrder(token, orderId);
    } catch (error) {
      print('Error canceling order: $error');
      if (error is SocketException) {
        throw PlatformException(
            code: 'NETWORK_ERROR', message: 'Network error occurred.');
      }
      rethrow;
    }
  }

  @override
  Future<List<Order>> viewOrderHistory() async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _orderService.viewOrderHistory(token);
      final List<Order> orderHistory = List<Order>.from(
        response['orders'].map((order) => Order.fromJson(order)),
      );

      return orderHistory;
    } catch (error) {
      print('Error viewing order history: $error');
      if (error is SocketException) {
        throw PlatformException(
          code: 'NETWORK_ERROR',
          message: 'Network error occurred.',
        );
      }
      rethrow;
    }
  }

  @override
  Future<List<Package>> getOrderPackages(String orderId) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _orderService.getOrderPackages(token, orderId);

      final List<Package> packages = List<Package>.from(
        response['packages'].map((package) => Package.fromJson(package)),
      );

      return packages;
    } catch (error) {
      print('Error retrieving order packages: $error');
      if (error is SocketException) {
        throw PlatformException(
          code: 'NETWORK_ERROR',
          message: 'Network error occurred.',
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> updatePackage(
      String orderId, String packageId, Package package) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      await _orderService.updatePackage(token, orderId, packageId, package);
    } catch (error) {
      print('Error updating package: $error');
      if (error is SocketException) {
        throw PlatformException(
          code: 'NETWORK_ERROR',
          message: 'Network error occurred.',
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> deletePackage(String orderId, String packageId) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      await _orderService.deletePackage(token, orderId, packageId);
    } catch (error) {
      print('Error deleting package: $error');
      if (error is SocketException) {
        throw PlatformException(
          code: 'NETWORK_ERROR',
          message: 'Network error occurred.',
        );
      }
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> calculateShippingPrice(
      Map<String, dynamic> coordinates) async {
    try {
      final token = _sharedPreferencesService.getStringValue('token');
      if (token == null) {
        throw Exception('Token not found');
      }

      final response =
          await _orderService.calculateShippingPrice(token, coordinates);

      final double shippingPrice =
          (response['shippingPrice'] as num).toDouble();
      final double distance = double.parse(
          ((response['distance'] as num).toDouble()).toStringAsFixed(2));

      // Return the extracted data
      return {
        'distance': distance,
        'shippingPrice': shippingPrice,
      };
    } catch (error) {
      print('Error calculating shipping price: $error');
      if (error is SocketException) {
        throw PlatformException(
          code: 'NETWORK_ERROR',
          message: 'Network error occurred.',
        );
      }
      rethrow;
    }
  }
}
