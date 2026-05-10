// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:packare/config/typography.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/path.dart';
import '../../../data/models/order_model.dart';

class MapCard extends StatelessWidget {
  final Order order;
  const MapCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final cardTextStyle = AppTypography(context: context).bodyText.copyWith(
          fontSize: 14.0,
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0),
      child: Row(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Shipper",
                  style: cardTextStyle.copyWith(fontWeight: FontWeight.w600)),
              Text(
                  "${order.shipper!.user.firstName} ${order.shipper!.user.lastName}",
                  style: cardTextStyle),
              Text(order.shipper!.user.phoneNumber, style: cardTextStyle),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              String phoneNumber = order.shipper!.user.phoneNumber;
              String uri = "tel:$phoneNumber";
              launchUrl(Uri.parse(uri));
            },
            icon: Icon(
              Icons.phone,
              color: Colors.blue[800],
            ),
          ),
        ],
      ),
    );
  }
}
