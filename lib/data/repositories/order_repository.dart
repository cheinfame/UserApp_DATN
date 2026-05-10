import 'package:packare/data/models/order_feedback_model.dart';

import '../models/order_model.dart';
import '../models/package_model.dart';

abstract class OrderRepository {
  // Create a new order
  Future<Order> createOrder(Order order);

  // Get an order
  Future<Order> getOrderById(String orderId);

  // Get user's orders
  Future<List<Order>> getOrdersByUser(String userId);

  // Provide order feedback
  Future<void> orderFeedback(String orderid, OrderFeedback feedback);

  // Accept an order
  Future<Order> acceptOrder(String orderId);

  // Verify an order
  Future<void> verifyOrder(String orderId);

  // Decline an order
  Future<void> declineOrder(String orderId);

  // Confirm pickup
  Future<void> confirmPickup(String orderId);

  // Confirm delivered
  Future<void> confirmDelivered(String orderId);

  // Complete an order
  Future<void> completeOrder(String orderId);

  // Cancel an order
  Future<void> cancelOrder(String orderId);

  // View order history
  Future<List<Order>> viewOrderHistory();

  // Get order packages
  Future<List<Package>> getOrderPackages(String orderId);

  // Update a package within an order
  Future<void> updatePackage(String orderId, String packageId, Package package);

  // Delete a package from an order
  Future<void> deletePackage(String orderId, String packageId);

  Future<Map<String, dynamic>> calculateShippingPrice(Map<String, dynamic> coordinates);
}
