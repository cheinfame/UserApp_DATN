// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:packare/presentation/home_screens/widgets/location_icon_column.dart';
import 'package:packare/presentation/home_screens/widgets/order_status_bar.dart';

import '../../../config/typography.dart';
import '../../../data/models/order_model.dart';

class HomeCurrentOrderListItem extends StatelessWidget {
  final Order order;

  const HomeCurrentOrderListItem({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final typo = AppTypography(context: context);
    double holdingFee = 0.00;
    List<String> packagesName = [];

    for (var e in order.packages) {
      holdingFee += e.packagePrice;
      packagesName.add(e.packageName);
    }

    return Material(
      elevation: 4.0,
      color: Theme.of(context).colorScheme.background,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: size.width * 0.8,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SelectableText(
                    order.orderId,
                    style: typo.title1.copyWith(fontSize: 18),
                  ),
                  IconButton(
                    onPressed: () {
                      // Copy order ID to clipboard
                      Clipboard.setData(ClipboardData(text: order.orderId));
                      // Show a snackbar or toast to indicate that the order ID is copied
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Order ID copied to clipboard'),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.copy,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    iconSize: 16,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            locationIconColumn(
              context,
              order.sendAddress,
              order.deliveryAddress,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              "Packages: ${packagesName.join(', ')}",
              style: typo.bodyText.copyWith(fontSize: 14),
            ),
            Text(
              'Shipping fee: ${order.shippingPrice}',
              style: typo.bodyText.copyWith(fontSize: 14),
            ),
            Text(
              'Holding fee: $holdingFee',
              style: typo.bodyText.copyWith(fontSize: 14),
            ),
            Text(
              'Order ${orderStatusMapping(order.status)} at ${DateFormat('yyyy-MM-dd HH:mm::ss').format(order.statusChangeTime ?? order.createTime!)} ',
              style: typo.bodyText.copyWith(fontSize: 14),
            ),
            OrderStatusBar(
              status: order.status,
            ),
          ],
        ),
      ),
    );
  }
}
