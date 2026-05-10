// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'order_bloc.dart';

enum OrderBlocStatus {
  initial,
  loading,
  success,
  failure,
}

enum OrderFeedbackStatus {
  initial,
  loading,
  success,
  failure,
}

enum CreateOrderStatus {
  initial,
  loading,
  success,
  failure,
}

class OrderState {
  OrderBlocStatus status;
  Order? currentOrder;
  OrderFeedbackStatus feedbackStatus;
  CreateOrderStatus createOrderStatus;
  List<Order> orders;
  List<Order> ordersNotCompleted;
  String? error;

  OrderState({
    this.createOrderStatus = CreateOrderStatus.initial,
    this.status = OrderBlocStatus.initial,
    this.currentOrder,
    this.feedbackStatus = OrderFeedbackStatus.initial,
    this.orders = const [],
    this.ordersNotCompleted = const [],
    this.error,
  });

  OrderState copyWith({
    OrderBlocStatus? status,
    Order? currentOrder,
    OrderFeedbackStatus? feedbackStatus,
    CreateOrderStatus? createOrderStatus,
    List<Order>? orders,
    List<Order>? ordersNotCompleted,
    String? error,
  }) {
    return OrderState(
      status: status ?? this.status,
      currentOrder: currentOrder ?? this.currentOrder,
      feedbackStatus: feedbackStatus ?? this.feedbackStatus,
      createOrderStatus: createOrderStatus ?? this.createOrderStatus,
      orders: orders ?? this.orders,
      ordersNotCompleted: ordersNotCompleted ?? this.ordersNotCompleted,
      error: error ?? this.error,
    );
  }
}
