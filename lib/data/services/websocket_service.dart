import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import '../../.const.dart';
import '../models/notification_model.dart';

class WebSocketService {
  late WebSocketChannel _channel;
  late Timer _heartbeatTimer;
  static const int _heartbeatTimeout = 15000; // 15 seconds

  // Map to store StreamControllers for shipper location updates of each order
  final Map<String, StreamController<List<double>>>
      _shipperLocationStreamControllers = {};

  WebSocketService() {
    _channel = IOWebSocketChannel.connect(wsUri);
    _channel.stream.listen(_handleMessage);
    _startHeartbeatTimer();
  }

  void _startHeartbeatTimer() {
    _heartbeatTimer =
        Timer.periodic(Duration(milliseconds: _heartbeatTimeout), (timer) {
      // Handle heartbeat timeout
      print('Heartbeat timeout: No ping received from server.');
      // _handleHeartbeatTimeout();
    });
  }

  void sendUserId(String userId) {
    // Send user ID to the server
    Map<String, dynamic> userIdMessage = {
      'type': 'user-id',
      'userId': userId,
    };
    _channel.sink.add(jsonEncode(userIdMessage));
  }

  void _resetHeartbeatTimer() {
    _heartbeatTimer.cancel(); // Cancel the existing timer
    _startHeartbeatTimer(); // Start a new timer
  }

  void _handleMessage(dynamic message) {
    // Reset the heartbeat timer when any message is received
    _resetHeartbeatTimer();

    // Parse the incoming message
    Map<String, dynamic> parsedMessage = jsonDecode(message);

    // Check if it's a heartbeat message
    if (parsedMessage.containsKey('type') && parsedMessage['type'] == 'ping') {
      // Respond with a pong
      _channel.sink.add(jsonEncode({'type': 'pong'}));
      return; // Exit the method, don't process further
    }

    // Handle other message types
    String messageType = parsedMessage['type'];
    switch (messageType) {
      case 'order-status-notification':
        _handleOrderStatusNotification(parsedMessage);
        break;
      case 'shipper-location-update':
        _handleShipperLocationUpdate(parsedMessage);
        break;
      default:
        print('Unknown message type: $messageType');
    }
  }

  void _handleOrderStatusNotification(Map<String, dynamic> message) {
    // Extract relevant data from the message
    String orderId = message['orderId'];
    String status = message['status'];
    DateTime timestamp =
        DateTime.parse(message['timestamp']); // Parse timestamp

    // Create a Notification object
    Notification notification = Notification(
      title: 'Order Status Update',
      content: 'Your order $orderId is now $status',
      timestamp: timestamp,
      // We achieved our message so isSent is true
      isSent: true,
      // We haven't read the message cause it has just been sent
      isRead: false,
    );

    // Add further logic here, such as updating the UI or storing the status
    print('Received order status notification: $notification');
  }

  void _handleShipperLocationUpdate(Map<String, dynamic> message) {
    // Extract relevant data from the message
    String orderId = message['orderId'];
    String shipperId = message['shipperId'];
    double latitude = message['latitude'];
    double longitude = message['longitude'];

    // Get the StreamController for this order
    StreamController<List<double>>? controller =
        _shipperLocationStreamControllers[orderId];
    if (controller != null) {
      // Pass shipper location data to the stream
      controller.add([latitude, longitude]);
    } else {
      print('Stream controller not found for order $orderId');
    }

    // Implement the logic to handle shipper location update
    print(
        'Shipper $shipperId for order $orderId is at ($latitude, $longitude)');
    // Add further logic here, such as updating the UI with the new location
  }

  void initializeStreamController(String orderId) {
    if (!_shipperLocationStreamControllers.containsKey(orderId)) {
      print('Stream controller inited for order $orderId');
      _shipperLocationStreamControllers[orderId] =
          StreamController<List<double>>();
    }
  }

  Stream<List<double>> shipperLocationStream(String orderId) {
    // If initialized, return the stream from the server
    return _shipperLocationStreamControllers[orderId]!.stream;
  }

  void unsubscribeFromShipperLocation(String orderId, String shipperId) {
    // Send an unsubscribe message to the server
    Map<String, dynamic> unsubscribeMessage = {
      'type': 'unsubscribe-shipper-location',
      'orderId': orderId,
      'shipperId': shipperId,
    };
    _channel.sink.add(jsonEncode(unsubscribeMessage));

    // Cancel the stream and remove the stream controller associated with the orderId
    if (_shipperLocationStreamControllers.containsKey(orderId)) {
      _shipperLocationStreamControllers[orderId]?.close();
      _shipperLocationStreamControllers.remove(orderId);
    }
  }

  void subscribeToShipperLocation(String orderId, String userId) {
    // Send a subscription message to the server
    Map<String, dynamic> subscriptionMessage = {
      'type': 'subscribe-shipper-location',
      'orderId': orderId,
      'userId': userId,
    };
    _channel.sink.add(jsonEncode(subscriptionMessage));
  }

  void close() {
    _heartbeatTimer
        .cancel(); // Cancel the heartbeat timer when closing the connection
    _channel.sink.close();

    // Close all StreamControllers
    _shipperLocationStreamControllers.forEach((orderId, controller) {
      controller.close();
    });
  }
}
