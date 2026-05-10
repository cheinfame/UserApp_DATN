import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:packare/blocs/order_bloc/order_bloc.dart';
import 'package:packare/config/path.dart';
import 'package:packare/config/typography.dart';
import 'package:packare/presentation/home_screens/widgets/order_status_bar.dart';
import '../../../data/models/order_model.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrderByIdEvent(orderId: widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.status == OrderBlocStatus.loading ||
              state.currentOrder == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSectionTitle('Order Summary', Icons.receipt, context),
                    _buildOrderSummary(state.currentOrder!, context),
                    const Divider(
                      thickness: 2,
                      height: 32,
                    ),
                    _buildSectionTitle(
                        'Shipping Information', Icons.local_shipping, context),
                    _buildShippingInfo(state.currentOrder!, context),
                    const Divider(
                      thickness: 2,
                      height: 32,
                    ),
                    _buildSectionTitle(
                        'Order Lasting Time', Icons.timer, context),
                    _buildOrderLastingTime(state.currentOrder!, context),
                    const Divider(
                      thickness: 2,
                      height: 32,
                    ),
                    _buildSectionTitle(
                        'Order Status', Icons.attach_money, context),
                    _buildOrderStatus(state.currentOrder!, context),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
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

  Widget _buildOrderLastingTime(Order order, BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final String formattedTime = dateFormat.format(order.orderLastingTime!);

    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: Text(
        'Order Lasting Time: $formattedTime',
        style:
            AppTypography(context: context).bodyText.copyWith(fontSize: 14.0),
      ),
    );
  }

  Widget _buildOrderSummary(Order order, BuildContext context) {
    final NumberFormat vndFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display each package
          ...order.packages.map((package) {
            if (package.packageImageUrl != null) {
              return _buildPackageRow(
                packageName: package.packageName,
                packagePrice: package.packagePrice,
                imageUrl: package.packageImageUrl!, // Actual image path
              );
            } else {
              // If packageImageUrl is null, use placeholder directly
              return _buildPackageRow(
                packageName: package.packageName,
                packagePrice: package.packagePrice,
                imageUrl: '',
              );
            }
          }),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(child: Divider()),
              Text(
                'Shipping Fee ${vndFormat.format(order.shippingPrice)}',
                style: AppTypography(context: context)
                    .bodyText
                    .copyWith(fontSize: 14.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPackageRow({
    required String packageName,
    required double packagePrice,
    required String imageUrl,
  }) {
    final NumberFormat vndFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () {
              _showZoomedImage(imageUrl);
            },
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                      no_image_holder,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : Image.asset(
                    no_image_holder,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Text(
          packageName,
          style:
              AppTypography(context: context).bodyText.copyWith(fontSize: 14.0),
        ),
        const Spacer(),
        Text(
          'Holding Fee ${vndFormat.format(packagePrice)}',
          style:
              AppTypography(context: context).bodyText.copyWith(fontSize: 14.0),
        ),
      ],
    );
  }

  void _showZoomedImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShippingInfo(Order order, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextWithOverflow(
              'Pickup Address: ${order.sendAddress}', context),
          const SizedBox(height: 8),
          _buildTextWithOverflow(
              'Receiver Address: ${order.deliveryAddress}', context),
          const SizedBox(height: 8),
          const SizedBox(height: 8),
          _buildTextWithOverflow(
              'Receiver Name: ${order.receiverName}', context),
          const SizedBox(height: 8),
          _buildTextWithOverflow(
              'Receiver Phone: ${order.receiverPhone}', context),
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

  Widget _buildOrderStatus(Order order, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextWithOverflow(
              'Order ${orderStatusMapping(order.status)} at ${DateFormat('yyyy-MM-dd HH:mm::ss').format(order.statusChangeTime ?? order.createTime!)} ',
              context),
          const SizedBox(
            height: 8,
          ),
          OrderStatusBar(status: order.status),
        ],
      ),
    );
  }
}
