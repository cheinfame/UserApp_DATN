// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:packare/presentation/map_screen/widgets/map_card.dart';
import 'package:packare/presentation/map_screen/widgets/map_widget.dart';

import '../../../config/typography.dart';
import '../../../data/models/order_model.dart';

class MapScreen extends StatefulWidget {
  final Order? order;
  const MapScreen({
    super.key,
    this.order,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool haveOrder = widget.order != null;

    LatLng startCoords = LatLng(
        widget.order?.sendCoordinates.coordinates[1] ?? 0,
        widget.order?.sendCoordinates.coordinates[0] ?? 0);
    LatLng endCoords = LatLng(
        widget.order?.deliveryCoordinates.coordinates[1] ?? 0,
        widget.order?.deliveryCoordinates.coordinates[0] ?? 0);

    return Scaffold(
      body: SafeArea(
        child: SlidingUpPanel(
          minHeight: size.height * 0.125,
          maxHeight: size.height * 0.125,
          borderRadius: BorderRadius.circular(12.0),
          color: Theme.of(context).colorScheme.background,
          boxShadow: const [
            BoxShadow(
              blurRadius: 20.0,
              color: Colors.grey,
            ),
          ],
          margin: const EdgeInsets.all(24.0),
          panelBuilder: (sc) => haveOrder
              ? MapCard(order: widget.order!)
              : const SizedBox.shrink(),
          body: Stack(
            children: [
              haveOrder
                  ? MapWidget(
                      startCoords: startCoords,
                      endCoords: endCoords,
                      orderId: widget.order!.orderId,
                      userId: widget.order!.senderId,
                      shipperId: widget.order!.shipperId,
                    )
                  : MapWidget(),
              haveOrder
                  ? _buildStatusBar(context, widget.order!.status)
                  : const SizedBox.shrink(),
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar(BuildContext context, OrderStatus status) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(45.0),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 2.0,
                  color: Colors.grey,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  orderStatusMapping(status),
                  style: AppTypography(context: context).bodyText,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                CircleAvatar(
                  backgroundColor: Colors.blue[600],
                  radius: 4,
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
