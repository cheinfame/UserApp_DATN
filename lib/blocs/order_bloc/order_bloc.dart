import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:packare/data/repositories/user_repository_impl.dart';

import '../../data/models/order_feedback_model.dart';
import '../../data/models/package_model.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../data/models/order_model.dart';
import '../../data/services/image_service.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepositoryImpl orderRepository;
  final ImageService imageService;
  final UserRepositoryImpl userRepository;

  OrderBloc(
      {required this.orderRepository,
      required this.imageService,
      required this.userRepository})
      : super(OrderState(status: OrderBlocStatus.initial, orders: [])) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<GetOrderByIdEvent>(_onGetOrderById);
    on<GetOrdersByUserEvent>(_onGetOrdersByUser);
    on<ProvideOrderFeedbackEvent>(_onProvideOrderFeedback);
    on<AcceptOrderEvent>(_onAcceptOrder);
    on<VerifyOrderEvent>(_onVerifyOrder);
    on<DeclineOrderEvent>(_onDeclineOrder);
    on<ConfirmPickupEvent>(_onConfirmPickup);
    on<ConfirmDeliveredEvent>(_onConfirmDelivered);
    on<CompleteOrderEvent>(_onCompleteOrder);
    on<CancelOrderEvent>(_onCancelOrder);
    on<ViewOrderHistory>(_onViewOrderHistory);
    on<GetOrderPackages>(_onGetOrderPackages);
    on<UpdatePackageEvent>(_onUpdatePackage);
    on<DeletePackageEvent>(_onDeletePackage);
    on<OrderStateLoadingEvent>(_onOrderStateLoadingEvent);
  }

  void _onOrderStateLoadingEvent(
      OrderStateLoadingEvent event, Emitter<OrderState> emit) {
    emit(state.copyWith(status: OrderBlocStatus.loading));
  }

  void _onCreateOrder(CreateOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(
        createOrderStatus: CreateOrderStatus.loading));
    try {
      final orderInfo = event.order;
      final List<Package> updatedPackages = [];

      for (final package in orderInfo.packages) {
        if (package.packageImageUrl != null &&
            package.packageImageUrl!.isNotEmpty) {
          // Upload each package image and get the download URL
          final downloadUrl = await imageService
              .uploadPackageImage(package.packageImageUrl!)
              .timeout(const Duration(seconds: 30));

          // Create a new Package instance with the updated packageImageUrl
          final updatedPackage = package.copyWith(packageImageUrl: downloadUrl);

          // Add the updated package to the list of packages
          updatedPackages.add(updatedPackage);
        } else {
          // If packageImageUrl is null, add the original package to the list of packages
          updatedPackages.add(package);
        }
      }
      await orderRepository
          .createOrder(orderInfo.copyWith(packages: updatedPackages))
          .timeout(const Duration(seconds: 30));


      emit(state.copyWith(
          createOrderStatus: CreateOrderStatus.success,
));
    } catch (error) {
      emit(state.copyWith(
          createOrderStatus: CreateOrderStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onGetOrderById(
      GetOrderByIdEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      final currentOrder = await orderRepository
          .getOrderById(event.orderId)
          .timeout(const Duration(seconds: 30));
      emit(state.copyWith(
          status: OrderBlocStatus.success, currentOrder: currentOrder));
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onGetOrdersByUser(
      GetOrdersByUserEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      // Call the getUncompletedOrdersByUser method from OrderRepository
      final List<Order> orders = await orderRepository
          .getOrdersByUser(event.userId)
          .timeout(const Duration(seconds: 30));

      final List<Order> ordersNotCompleted = [];

      // Fetch shipper data for each order asynchronously and check for completed orders
      final List<Future<Order>> updatedOrders = orders.map((order) async {
        if (order.status != OrderStatus.completed) {
          ordersNotCompleted.add(order);
        }

        if (order.shipperId != null && order.shipperId!.isNotEmpty) {
          // Fetch shipper data for the order
          final shipper = await userRepository.getUserProfile(order.shipperId!);
          // Update the order with shipper data
          return order.copyWith(shipper: shipper);
        } else {
          return order;
        }
      }).toList();

      // Wait for all asynchronous fetches to complete
      final List<Order> updatedOrdersWithShipperData =
          await Future.wait(updatedOrders);

      emit(state.copyWith(
          status: OrderBlocStatus.success,
          ordersNotCompleted: ordersNotCompleted,
          orders: updatedOrdersWithShipperData));
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onProvideOrderFeedback(
      ProvideOrderFeedbackEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(feedbackStatus: OrderFeedbackStatus.loading));
    try {
      List<Order> orders = state.orders;
      for (var order in orders) {
        if (order.orderId == event.feedback.orderId) {
          order.feedback = event.feedback;
        }
      }
      await orderRepository
          .orderFeedback(event.orderId, event.feedback)
          .timeout(const Duration(seconds: 30));
      emit(state.copyWith(
          feedbackStatus: OrderFeedbackStatus.success, orders: orders));
    } catch (error) {
      emit(state.copyWith(
          feedbackStatus: OrderFeedbackStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onAcceptOrder(AcceptOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      final acceptedOrder = await orderRepository
          .acceptOrder(event.orderId)
          .timeout(const Duration(seconds: 30));
      emit(state.copyWith(
          status: OrderBlocStatus.success, currentOrder: acceptedOrder));
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onVerifyOrder(VerifyOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      await orderRepository
          .verifyOrder(event.orderId)
          .timeout(const Duration(seconds: 30));
      emit(state.copyWith(status: OrderBlocStatus.success));
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onDeclineOrder(
      DeclineOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      await orderRepository
          .declineOrder(event.orderId)
          .timeout(const Duration(seconds: 30));
      emit(state.copyWith(status: OrderBlocStatus.success));
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onConfirmPickup(
      ConfirmPickupEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      await orderRepository
          .confirmPickup(event.orderId)
          .timeout(const Duration(seconds: 30));
      emit(state.copyWith(status: OrderBlocStatus.success));
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onConfirmDelivered(
      ConfirmDeliveredEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      await orderRepository
          .confirmDelivered(event.orderId)
          .timeout(const Duration(seconds: 30));
      emit(state.copyWith(status: OrderBlocStatus.success));
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : 'An unexpected error occurred while confirming delivered. Please try again later.'));
    }
  }

  void _onCompleteOrder(
      CompleteOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      await orderRepository
          .completeOrder(event.orderId)
          .timeout(const Duration(seconds: 30));
      emit(state.copyWith(status: OrderBlocStatus.success));
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onCancelOrder(CancelOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      await orderRepository
          .cancelOrder(event.orderId)
          .timeout(const Duration(seconds: 30));
      emit(state.copyWith(status: OrderBlocStatus.success));
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onViewOrderHistory(
      ViewOrderHistory event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      final orderHistory = await orderRepository
          .viewOrderHistory()
          .timeout(const Duration(seconds: 30));
      emit(state.copyWith(
          status: OrderBlocStatus.success, orders: orderHistory));
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onGetOrderPackages(
      GetOrderPackages event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      final packages = await orderRepository
          .getOrderPackages(event.orderId)
          .timeout(const Duration(seconds: 30));
      if (state.currentOrder != null) {
        emit(state.copyWith(
            status: OrderBlocStatus.success,
            currentOrder: state.currentOrder!.copyWith(packages: packages)));
      } else {
        throw ('Current order not found, please try again');
      }
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onUpdatePackage(
      UpdatePackageEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      await orderRepository
          .updatePackage(event.orderId, event.packageId, event.package)
          .timeout(const Duration(seconds: 30));
      emit(state.copyWith(status: OrderBlocStatus.success));
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onDeletePackage(
      DeletePackageEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderBlocStatus.loading));
    try {
      await orderRepository
          .deletePackage(event.orderId, event.packageId)
          .timeout(const Duration(seconds: 30));
      emit(state.copyWith(status: OrderBlocStatus.success));
    } catch (error) {
      emit(state.copyWith(
          status: OrderBlocStatus.failure,
          error: (error is SocketException)
              ? 'Network error occurred. Please check your internet connection and try again.'
              : error.toString()));
    }
  }
}
