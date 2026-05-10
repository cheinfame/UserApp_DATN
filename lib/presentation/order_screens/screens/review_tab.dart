import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:packare/blocs/account_bloc/account_bloc.dart';
import 'package:packare/blocs/order_bloc/order_bloc.dart';
import 'package:packare/config/typography.dart';

import '../../../blocs/order_bloc/create_order_process_cubit.dart';
import '../../../blocs/order_bloc/create_order_process_state.dart';
import '../../../data/models/geojson_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/package_model.dart';

class ReviewTab extends StatefulWidget {
  const ReviewTab({Key? key}) : super(key: key);

  @override
  State<ReviewTab> createState() => _ReviewTabState();
}

class _ReviewTabState extends State<ReviewTab> {
  late CreateOrderProcessCubit _orderProcessCubit;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _orderProcessCubit = context.read<CreateOrderProcessCubit>();
    _orderProcessCubit.calculateShippingPrice();
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat vndFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, orderState) {
        return BlocBuilder<CreateOrderProcessCubit, CreateOrderProcessState>(
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSectionTitle(
                            'Order Summary', Icons.receipt, context),
                        _buildOrderSummary(state, context),
                        const Divider(
                          thickness: 2,
                          height: 32,
                        ),
                        _buildSectionTitle('Shipping Information',
                            Icons.local_shipping, context),
                        _buildShippingInfo(state, context),
                        const Divider(
                          thickness: 2,
                          height: 32,
                        ),
                        _buildSectionTitle(
                            'Order Lasting Time', Icons.timer, context),
                        _buildOrderLastingTime(state, context),
                        const Divider(
                          thickness: 2,
                          height: 32,
                        ),
                        _buildSectionTitle(
                            'Payment Method', Icons.attach_money, context),
                        _buildPaymentMethod(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(left: 16),
                    height: 64,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Order Distance: ${state.orderDistance} km',
                              style: AppTypography(context: context)
                                  .bodyText
                                  .copyWith(fontSize: 16.0),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              'Shipping Fee: ${vndFormat.format(state.shippingPrice)}',
                              style: AppTypography(context: context)
                                  .bodyText
                                  .copyWith(fontSize: 16.0),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            _debounceTimer =
                                Timer(const Duration(milliseconds: 500), () {
                              if (mounted) {
                                // Execute the action after the delay
                                final order = createOrderFromState(state);
                                context
                                    .read<OrderBloc>()
                                    .add(CreateOrderEvent(order: order));
                              }
                            });

                            if (orderState.createOrderStatus == CreateOrderStatus.failure) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Error"),
                                    content: Text(orderState.error!),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (orderState.createOrderStatus == CreateOrderStatus.success) {
 
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Success"),
                                            content: const Text("Order created successfully"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("OK"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    
                                  }

                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            color: Theme.of(context).colorScheme.primary,
                            child: Center(
                              child: Text(
                                'Confirm Order',
                                style: AppTypography(context: context)
                                    .title3
                                    .copyWith(
                                      fontSize: 16.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if (orderState.createOrderStatus == CreateOrderStatus.loading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Order createOrderFromState(CreateOrderProcessState state) {
    List<Package> packages = state.packages;
    // current user will be sender
    final sender = context.read<AccountBloc>().state.account;

    // Create the new Order Instance
    Order order = Order(
      orderId: '', // Placeholder, it will be generated in the backend
      packages: packages,
      senderId: sender!.user.userId,
      receiverName: state.receiverName,
      receiverPhone: '+84${state.receiverPhone}',
      sendAddress: state.sendLocation,
      sendCoordinates: GeoJson(
        type: 'Point',
        coordinates: [state.sendLng, state.sendLat],
      ),
      deliveryAddress: state.receiveLocation,
      deliveryCoordinates: GeoJson(
        type: 'Point',
        coordinates: [state.receiveLng, state.receiveLat],
      ),
      preferredPickupStartTime: state.preferredPickupStartTime,
      preferredPickupEndTime: state.preferredPickupEndTime,
      preferredDeliveryStartTime: state.preferredDeliveryStartTime,
      preferredDeliveryEndTime: state.preferredDeliveryEndTime,
      orderLastingTime: state.orderLastingTime,
      shippingPrice: state.shippingPrice,
      status: OrderStatus.waiting,
    );

    return order;
  }

  Widget _buildSectionTitle(String title, IconData icon, BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20.0,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: AppTypography(context: context).title3,
        ),
      ],
    );
  }

  Widget _buildOrderLastingTime(
      CreateOrderProcessState state, BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final String formattedTime = dateFormat.format(state.orderLastingTime);

    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: Row(
        children: [
          Text(
            'Order Lasting Time: $formattedTime',
            style: AppTypography(context: context)
                .bodyText
                .copyWith(fontSize: 14.0),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              _selectTime(context, state);
            },
            icon: const Icon(
              Icons.access_time,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(
      BuildContext context, CreateOrderProcessState state) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.preferredDeliveryEndTime,
      firstDate: state.preferredDeliveryEndTime,
      lastDate: DateTime.now().add(const Duration(days: 14)),
    );

    if (picked != null) {
      // Update the preferred delivery end time
      _orderProcessCubit.updatePreferredDeliveryEndTime(picked);
    }
  }

  Widget _buildOrderSummary(
      CreateOrderProcessState state, BuildContext context) {
    final NumberFormat vndFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: state.packages.asMap().entries.map((entry) {
          final Package package = entry.value;

          return Row(
            children: [
              Text(
                package.packageName,
                style: AppTypography(context: context)
                    .bodyText
                    .copyWith(fontSize: 14.0),
              ),
              const Spacer(),
              Text(
                'Holding Fee ${vndFormat.format(package.packagePrice)}',
                style: AppTypography(context: context)
                    .bodyText
                    .copyWith(fontSize: 14.0),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildShippingInfo(
      CreateOrderProcessState state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextWithOverflow(
              'Pickup Address: ${state.sendLocation}', context),
          const SizedBox(height: 8),
          _buildTextWithOverflow(
              'Receiver Address: ${state.receiveLocation}', context),
          const SizedBox(height: 8),
          _buildTextWithOverflow(
              'Receiver Name: ${state.receiverName}', context),
          const SizedBox(height: 8),
          _buildTextWithOverflow(
              'Receiver Phone: +84 ${state.receiverPhone}', context),
        ],
      ),
    );
  }

  Widget _buildTextWithOverflow(String text, BuildContext context) {
    return Text(
      text,
      maxLines: 2, // Adjust as needed
      overflow: TextOverflow.ellipsis,
      style: AppTypography(context: context).bodyText.copyWith(fontSize: 14.0),
    );
  }

  Widget _buildPaymentMethod() {
    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Credit Card ending in 1234'),
        ],
      ),
    );
  }
}
