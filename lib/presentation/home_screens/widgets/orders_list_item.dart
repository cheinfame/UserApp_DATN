import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:packare/data/models/order_model.dart';
import 'package:packare/presentation/feedback_screen/screen/feedback_screen.dart';
import 'package:packare/presentation/map_screen/screen/map_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../blocs/account_bloc/account_bloc.dart';
import '../../../blocs/order_bloc/order_bloc.dart';
import '../../../config/path.dart';
import '../../../config/typography.dart';
import '../../global_widgets/image_screen.dart';
import 'location_icon_column.dart';

class OrdersListItem extends StatelessWidget {
  final Order order;
  const OrdersListItem({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> packagesWithImages = order.packages
        .where((package) =>
            package.packageImageUrl != null &&
            package.packageImageUrl!.isNotEmpty)
        .map((package) => package.packageImageUrl!)
        .toList();

    List<String> packageNamesWithImages = order.packages
        .where((package) =>
            package.packageImageUrl != null &&
            package.packageImageUrl!.isNotEmpty)
        .map((package) => package.packageName)
        .toList();

    List<String> packagesName = [];
    double holdingFee = 0;
    for (var e in order.packages) {
      holdingFee += e.packagePrice;
      packagesName.add(e.packageName);
    }

    final cardTextStyle = AppTypography(context: context).bodyText.copyWith(
          fontSize: 14.0,
        );

    bool isShipping = (order.status == OrderStatus.startShipping ||
        order.status == OrderStatus.shipperAccepted ||
        order.status == OrderStatus.shipperPickedUp ||
        order.status == OrderStatus.delivered ||
        order.status == OrderStatus.completed);

    bool haveCancelButton = order.status == OrderStatus.waiting;

    bool haveDelivered = order.status == OrderStatus.delivered;

    bool haveFeedback = order.feedback != null;

    return Material(
      elevation: 2.0,
      color: Theme.of(context).colorScheme.background,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: isShipping
            ? haveDelivered
                ? 425
                : 375
            : haveCancelButton
                ? 350
                : 300,
        padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isShipping)
              Row(
                children: [
                  CircleAvatar(
                    radius: 18.0,
                    child: SvgPicture.asset(user_avatar),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Shipper",
                          style: cardTextStyle.copyWith(
                              fontWeight: FontWeight.w600)),
                      Text(
                          "${order.shipper!.user.firstName} ${order.shipper!.user.lastName}",
                          style: cardTextStyle),
                      Text(order.shipper!.user.phoneNumber,
                          style: cardTextStyle),
                    ],
                  ),
                  const Spacer(),
                  !haveFeedback
                      ? IconButton(
                          onPressed: () {
                            String phoneNumber =
                                order.shipper!.user.phoneNumber;
                            String uri = "tel:$phoneNumber";
                            launchUrl(Uri.parse(uri));
                          },
                          icon: Icon(
                            Icons.phone,
                            color: Colors.blue[800],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Feedback",
                                style: cardTextStyle.copyWith(
                                    fontWeight: FontWeight.w600)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 1; i <= 5; i++)
                                  Icon(
                                    i <= order.feedback!.rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.orange[400],
                                  ),
                              ],
                            ),
                            Text(order.feedback!.comment, style: cardTextStyle),
                          ],
                        ),
                ],
              ),
            if (isShipping) const Divider(),

            // Apart from shipper part
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 52,
                    child: SvgPicture.asset(
                      packare_logo_path,
                      height: 24,
                      width: 24,
                    ),
                  ),
                  SelectableText(
                    order.orderId,
                    style: AppTypography(context: context)
                        .title1
                        .copyWith(fontSize: 18),
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
              height: 5,
            ),
            locationIconColumn(
              context,
              order.sendAddress,
              order.deliveryAddress,
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 52.0),
              child: Text(
                "Packages: ${packagesName.join(', ')}",
                style: cardTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 52.0),
              child: Text(
                "Status: ${orderStatusMapping(order.status)}",
                style: cardTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 52.0),
              child: Text(
                "Shipping Price: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(order.shippingPrice)}",
                style: cardTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 52.0),
              child: Text(
                "Holding Fee: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(holdingFee)}",
                style: cardTextStyle,
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: packagesWithImages.isNotEmpty
                      ? () {
                          // Open PackageImageScreen when button is pressed
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PackageImageScreen(
                                imageUrls: packagesWithImages,
                                packageNames: packageNamesWithImages,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue[300]),
                  ),
                  icon: Icon(
                    Icons.picture_in_picture_alt,
                    color: Colors.blue[900],
                    size: 16.0,
                  ),
                  label: Text(
                    "Packages Picture",
                    style: cardTextStyle.copyWith(color: Colors.blue[900]),
                  ),
                ),
                order.status == OrderStatus.startShipping ||
                        order.status == OrderStatus.shipperPickedUp
                    ? const SizedBox(
                        width: 8,
                      )
                    : const SizedBox.shrink(),
                order.status == OrderStatus.startShipping ||
                        order.status == OrderStatus.shipperPickedUp
                    ? TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapScreen(
                                        order: order,
                                      )));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue[300]),
                        ),
                        icon: Icon(
                          Icons.map,
                          color: Colors.blue[900],
                          size: 16.0,
                        ),
                        label: Text(
                          "Track Shipper",
                          style:
                              cardTextStyle.copyWith(color: Colors.blue[900]),
                        ),
                      )
                    : const SizedBox.shrink(),
                order.status == OrderStatus.completed || haveFeedback
                    ? const SizedBox(
                        width: 8,
                      )
                    : const SizedBox.shrink(),
                order.status == OrderStatus.completed && !haveFeedback
                    ? TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FeedbackScreen(order: order)));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue[300]),
                        ),
                        icon: Icon(
                          Icons.map,
                          color: Colors.blue[900],
                          size: 16.0,
                        ),
                        label: Text(
                          "Feedback",
                          style:
                              cardTextStyle.copyWith(color: Colors.blue[900]),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(
              height: 5,
            ),

            !haveDelivered
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          context
                              .read<OrderBloc>()
                              .add(CompleteOrderEvent(orderId: order.orderId));

                       final account = context.read<AccountBloc>().state.account;

                          context
                  .read<OrderBloc>()
                  .add(GetOrdersByUserEvent(userId: account!.user.userId));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue[300]),
                        ),
                        icon: Icon(
                          Icons.check,
                          color: Colors.blue[900],
                          size: 16.0,
                        ),
                        label: Text(
                          "Complete Order",
                          style:
                              cardTextStyle.copyWith(color: Colors.blue[900]),
                        ),
                      ),
                    ],
                  ),

            // If the order status is these, the order cannot be cancelled
            !haveCancelButton
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          context.read<OrderBloc>().add(CancelOrderEvent(orderId: order.orderId));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red[200]),
                        ),
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.red[900],
                          size: 16.0,
                        ),
                        label: Text(
                          "Cancel",
                          style: cardTextStyle.copyWith(color: Colors.red[900]),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
