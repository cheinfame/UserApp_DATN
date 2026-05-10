import 'package:flutter/material.dart';
import '../../../data/models/order_model.dart';

class OrderStatusBar extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBar({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusIcon(
                context, OrderStatus.waiting, Icons.timer, 'Waiting'),
            _buildStatusDivider(context, OrderStatus.waiting),
            status != OrderStatus.declined
                ? _buildStatusIcon(
                    context, OrderStatus.verified, Icons.check, 'Verified')
                : Container(),
            status != OrderStatus.declined
                ? _buildStatusDivider(context, OrderStatus.verified)
                : Container(),
            status != OrderStatus.declined && status != OrderStatus.cancelled
                ? _buildStatusIcon(context, OrderStatus.shipperAccepted,
                    Icons.drive_eta, 'Shipper Accepted')
                : Container(),
            status != OrderStatus.declined && status != OrderStatus.cancelled
                ? _buildStatusDivider(context, OrderStatus.shipperAccepted)
                : Container(),
            status != OrderStatus.declined && status != OrderStatus.cancelled
                ? _buildStatusIcon(context, OrderStatus.startShipping,
                    Icons.route, 'On The Way')
                : Container(),
            status != OrderStatus.declined && status != OrderStatus.cancelled
                ? _buildStatusDivider(context, OrderStatus.startShipping)
                : Container(),
            status != OrderStatus.declined && status != OrderStatus.cancelled
                ? _buildStatusIcon(context, OrderStatus.shipperPickedUp,
                    Icons.local_shipping, 'Picked Up')
                : Container(),
            status != OrderStatus.declined && status != OrderStatus.cancelled
                ? _buildStatusDivider(context, OrderStatus.shipperPickedUp)
                : Container(),
            status != OrderStatus.declined && status != OrderStatus.cancelled
                ? _buildStatusIcon(context, OrderStatus.completed,
                    Icons.check_circle_outline, 'Completed')
                : Container(),
            status == OrderStatus.declined
                ? _buildStatusIcon(
                    context, OrderStatus.declined, Icons.close, 'Declined')
                : Container(),
            status == OrderStatus.cancelled
                ? _buildStatusIcon(
                    context, OrderStatus.cancelled, Icons.cancel, 'Cancelled')
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(
      BuildContext context, OrderStatus status, IconData icon, String label) {
    return Tooltip(
      message: label,
      child: Column(
        children: [
          Icon(
            icon,
            color: (this.status.index >= status.index)
                ? Theme.of(context).colorScheme.primary
                : Colors
                    .grey, // Use primary color for current and previous statuses
          ),
          const SizedBox(
            height: 4,
          ),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStatusDivider(BuildContext context, OrderStatus status) {
    return Container(
      height: 3,
      width: MediaQuery.of(context).size.width * 0.08,
      decoration: BoxDecoration(
        gradient: (this.status.index >= status.index)
            ? LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  Theme.of(context).colorScheme.primary,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : const LinearGradient(colors: [Colors.grey, Colors.grey]),
      ),
    );
  }
}
