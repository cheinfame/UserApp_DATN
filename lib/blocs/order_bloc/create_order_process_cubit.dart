import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packare/data/models/package_model.dart';

import '../../data/repositories/order_repository.dart';
import 'create_order_process_state.dart';

class CreateOrderProcessCubit extends Cubit<CreateOrderProcessState> {
  final OrderRepository orderRepository;

  CreateOrderProcessCubit({required this.orderRepository})
      : super(CreateOrderProcessState(
          sendLocation: '',
          sendLat: 0.0,
          sendLng: 0.0,
          receiveLocation: '',
          receiveLat: 0.0,
          receiveLng: 0.0,
          preferredPickupStartTime: DateTime.now(),
          preferredPickupEndTime: DateTime.now().add(const Duration(days: 7)),
          receiverName: '',
          receiverPhone: '',
          preferredDeliveryStartTime: DateTime.now(),
          preferredDeliveryEndTime: DateTime.now().add(const Duration(days: 7)),
          packages: [],
          shippingPrice: 0,
          orderDistance: 0,
          orderLastingTime: DateTime.now().add(const Duration(days: 7)),
        ));

  void updateSendLocation(String sendLocation) {
    emit(state.copyWith(sendLocation: sendLocation));
  }

  void updateSendLat(double sendLat) {
    emit(state.copyWith(sendLat: sendLat));
  }

  void updateSendLng(double sendLng) {
    emit(state.copyWith(sendLng: sendLng));
  }

  void updateReceiveLocation(String receiveLocation) {
    emit(state.copyWith(receiveLocation: receiveLocation));
  }

  void updateReceiveLat(double receiveLat) {
    emit(state.copyWith(receiveLat: receiveLat));
  }

  void updateReceiveLng(double receiveLng) {
    emit(state.copyWith(receiveLng: receiveLng));
  }

  void updatePackageImage(int index, String imageUrl) {
    state.packages[index] =
        state.packages[index].copyWith(packageImageUrl: imageUrl);
    emit(state.copyWith(packages: state.packages));
  }

  void updatePreferredPickupStartTime(DateTime? startTime) {
    emit(state.copyWith(preferredPickupStartTime: startTime));
  }

  void updateOrderLastingTime(DateTime? orderLastingTime) {
    emit(state.copyWith(orderLastingTime: orderLastingTime));
  }

  void updatePreferredPickupEndTime(DateTime? endTime) {
    emit(state.copyWith(preferredPickupEndTime: endTime));
  }

  void updateReceiverName(String receiverName) {
    emit(state.copyWith(receiverName: receiverName));
  }

  void updateReceiverPhone(String receiverPhone) {
    emit(state.copyWith(receiverPhone: receiverPhone));
  }

  void updatePreferredDeliveryStartTime(DateTime? startTime) {
    emit(state.copyWith(preferredDeliveryStartTime: startTime));
  }

  void updatePreferredDeliveryEndTime(DateTime? endTime) {
    emit(state.copyWith(preferredDeliveryEndTime: endTime));

    if (endTime != null && endTime.isAfter(state.orderLastingTime)) {
      emit(state.copyWith(orderLastingTime: endTime));
    }
  }

  void deletePackage(int index) {
    state.packages.removeAt(index);
    emit(state.copyWith(packages: state.packages));
  }

  void updatePackage(int index,
      {String? packageName, String? packageDescription, double? price}) {
    state.packages[index] = state.packages[index].copyWith(
        packageName: packageName,
        packageDescription: packageDescription,
        packagePrice: price);
    emit(state.copyWith(packages: state.packages));
  }

  void addPackage(List<Package> packages) {
    packages.add(Package(
        packageName: '',
        packageDescription: '',
        packagePrice: 0,
        packageImageUrl: ''));
    emit(state.copyWith(packages: packages));
  }

  void calculateShippingPrice() async {
    try {
      final coordinates = {
        'sendLat': state.sendLat,
        'sendLng': state.sendLng,
        'receiveLat': state.receiveLat,
        'receiveLng': state.receiveLng,
      };

      final Map<String, dynamic> shippingData =
          await orderRepository.calculateShippingPrice(coordinates);

      final double shippingPrice = shippingData['shippingPrice'] as double;
      final double distance = shippingData['distance'] as double;

      emit(state.copyWith(
        shippingPrice: shippingPrice,
        orderDistance: distance,
      ));
    } catch (error) {
      print('Error calculating shipping price: $error');
    }
  }
  
   // Function to reset the state to its initial values
  void reset() {
    emit(CreateOrderProcessState(
      sendLocation: '',
      sendLat: 0.0,
      sendLng: 0.0,
      receiveLocation: '',
      receiveLat: 0.0,
      receiveLng: 0.0,
      preferredPickupStartTime: DateTime.now(),
      preferredPickupEndTime: DateTime.now().add(const Duration(days: 7)),
      receiverName: '',
      receiverPhone: '',
      preferredDeliveryStartTime: DateTime.now(),
      preferredDeliveryEndTime: DateTime.now().add(const Duration(days: 7)),
      packages: [],
      shippingPrice: 0,
      orderDistance: 0,
      orderLastingTime: DateTime.now().add(const Duration(days: 7)),
    ));
  }
}
