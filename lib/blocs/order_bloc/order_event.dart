part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {}

class CreateOrderEvent extends OrderEvent {
  final Order order;

  CreateOrderEvent({required this.order});

  @override
  List<Object?> get props => [order];
}

class ProvideOrderFeedbackEvent extends OrderEvent {
  final String orderId;
  final OrderFeedback feedback;

  ProvideOrderFeedbackEvent({required this.orderId, required this.feedback});

  @override
  List<Object?> get props => [orderId, feedback];
}

class OrderStateLoadingEvent extends OrderEvent {
  @override
  List<Object?> get props => [];
}

class GetOrderByIdEvent extends OrderEvent {
  final String orderId;

  GetOrderByIdEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class GetOrdersByUserEvent extends OrderEvent {
  final String userId;

  GetOrdersByUserEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class AcceptOrderEvent extends OrderEvent {
  final String orderId;

  AcceptOrderEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class VerifyOrderEvent extends OrderEvent {
  final String orderId;

  VerifyOrderEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class DeclineOrderEvent extends OrderEvent {
  final String orderId;

  DeclineOrderEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class ConfirmPickupEvent extends OrderEvent {
  final String orderId;

  ConfirmPickupEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class ConfirmDeliveredEvent extends OrderEvent {
  final String orderId;

  ConfirmDeliveredEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class CompleteOrderEvent extends OrderEvent {
  final String orderId;

  CompleteOrderEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class CancelOrderEvent extends OrderEvent {
  final String orderId;

  CancelOrderEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class ViewOrderHistory extends OrderEvent {
  @override
  List<Object?> get props => [];
}

class GetOrderPackages extends OrderEvent {
  final String orderId;

  GetOrderPackages({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class UpdatePackageEvent extends OrderEvent {
  final String orderId;
  final String packageId;
  final Package package;

  UpdatePackageEvent({
    required this.orderId,
    required this.packageId,
    required this.package,
  });

  @override
  List<Object?> get props => [orderId, packageId, package];
}

class DeletePackageEvent extends OrderEvent {
  final String orderId;
  final String packageId;

  DeletePackageEvent({required this.orderId, required this.packageId});

  @override
  List<Object?> get props => [orderId, packageId];
}
