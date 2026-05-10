// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:packare/config/typography.dart';

import '../../../data/models/order_model.dart';

class ShipperHomeOrderListItem extends StatelessWidget {
  final Order order;
  final double distance;

  const ShipperHomeOrderListItem({
    super.key,
    required this.order,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    double holdingFee = 0.00;
    List<String> packagesName = [];

    for (var e in order.packages) {
      holdingFee += e.packagePrice;
      packagesName.add(e.packageName);
    }

    final cardTextStyle = AppTypography(context: context).bodyText.copyWith(
          fontSize: 14.0,
        );
    final cardTextStyleBold = AppTypography(context: context)
        .bodyText
        .copyWith(fontSize: 14.0, fontWeight: FontWeight.w600);

    String _formatDateTime(
      DateTime dateTime,
    ) {
      return DateFormat('M/d HH:mm').format(dateTime);
    }

    return Material(
      elevation: 2.0,
      color: Theme.of(context).colorScheme.background,
      borderRadius: BorderRadius.circular(12.0),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.fromLTRB(0, 15.0, 15.0, 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                  height: 82,
                  width: 48,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Center(
                    child: Icon(
                      Icons.local_shipping_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32.0,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Holding Fee: ",
                        style: cardTextStyle,
                        children: [
                          TextSpan(
                              text: NumberFormat.currency(
                                      locale: 'vi_VN', symbol: '₫')
                                  .format(holdingFee),
                              style: cardTextStyleBold),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Shipping Price: ",
                        style: cardTextStyle,
                        children: [
                          TextSpan(
                              text: NumberFormat.currency(
                                      locale: 'vi_VN', symbol: '₫')
                                  .format(order.shippingPrice),
                              style: cardTextStyleBold),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Expanding Distance: ",
                        style: cardTextStyle,
                        children: [
                          TextSpan(
                            text: distance < 1
                                ? '${(distance * 1000).toStringAsFixed(0)} m'
                                : '${distance.toStringAsFixed(2)} km',
                            style: cardTextStyleBold,
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Pick Up Time: ",
                        style: cardTextStyle,
                        children: [
                          TextSpan(
                            text:
                                "${_formatDateTime(order.preferredPickupStartTime!)}",
                            style: cardTextStyleBold,
                          ),
                          TextSpan(
                            text: " - ",
                            style: cardTextStyle,
                          ),
                          TextSpan(
                            text:
                                "${_formatDateTime(order.preferredPickupEndTime!)}",
                            style: cardTextStyleBold,
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Delivery Time: ",
                        style: cardTextStyle,
                        children: [
                          TextSpan(
                            text:
                                "${_formatDateTime(order.preferredDeliveryStartTime!)}",
                            style: cardTextStyleBold,
                          ),
                          TextSpan(
                            text: " - ",
                            style: cardTextStyle,
                          ),
                          TextSpan(
                            text:
                                "${_formatDateTime(order.preferredDeliveryEndTime!)}",
                            style: cardTextStyleBold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 0,
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Take Order",
                style: cardTextStyle.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
