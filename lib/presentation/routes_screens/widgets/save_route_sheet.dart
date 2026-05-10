import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:packare/config/typography.dart';
import 'package:packare/presentation/global_widgets/big_button.dart';
import 'package:packare/presentation/map_screen/widgets/map_widget.dart';

import '../../../blocs/account_bloc/account_bloc.dart';
import '../../../blocs/map_bloc/map_bloc.dart';
import '../../../data/models/geojson_model.dart';
import '../../../data/models/route_model.dart' as RouteModel;
import '../../../locator.dart';
import '../../global_widgets/info_text_field.dart';

class SaveRouteSheet extends StatefulWidget {
  final TextEditingController routeNameController;
  final TextEditingController startLocationController;
  final TextEditingController endLocationController;
  final GeoJson startCoords;
  final GeoJson endCoords;
  final double distance;
  final double duration;
  final bool? isActive; // Nullable bool
  final List<List<double>> geometry;
  final bool? isUpdate;
  final String? routeId;

  const SaveRouteSheet({
    super.key,
    this.isUpdate = false,
    this.isActive,
    this.routeId,
    required this.routeNameController,
    required this.startLocationController,
    required this.endLocationController,
    required this.startCoords,
    required this.endCoords,
    required this.distance,
    required this.duration,
    required this.geometry,
  });

  @override
  _SaveRouteSheetState createState() => _SaveRouteSheetState();
}

class _SaveRouteSheetState extends State<SaveRouteSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isActive = false; // Default value

  RouteModel.RouteDirection selectedDirection =
      RouteModel.RouteDirection.startToEnd;

  @override
  void initState() {
    super.initState();
    // Initialize isActive to widget.isActive or false if it's null
    isActive = widget.isActive ?? false;
  }

  @override
  void dispose() {
    locator<MapBloc>().add(DeleteCurrentCreatingRouteEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typo = AppTypography(context: context);

    // Define the enum values for RouteDirection
    const List<RouteModel.RouteDirection> routeDirections =
        RouteModel.RouteDirection.values;

    return BlocListener<MapBloc, MapState>(
      listener: (context, state) {
        if (state.status == MapBlocStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Save Route Successful!'),
              duration: Duration(
                  seconds: 2), // Duration for which the SnackBar is visible
            ),
          );

          if (widget.isUpdate == true) {
            return;
          } else {
            Navigator.pop(context, true);
          }
        } else if (state.status == MapBlocStatus.failed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Save Route Failed!'),
              duration: Duration(
                  seconds: 2), // Duration for which the SnackBar is visible
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Save Route', style: typo.title2),
                const SizedBox(height: 16.0),
                InfoTextField(
                  context: context,
                  isObscure: false,
                  isValid: true,
                  hintText: 'Route Name',
                  label: 'Route Name',
                  textFieldController: widget.routeNameController,
                  formValidator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a route name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                InfoTextField(
                  context: context,
                  isObscure: false,
                  isValid: true,
                  readOnly: true,
                  hintText: 'Start Location',
                  label: 'Start Location',
                  textFieldController: widget.startLocationController,
                ),
                const SizedBox(height: 8.0),
                InfoTextField(
                  context: context,
                  isObscure: false,
                  isValid: true,
                  readOnly: true,
                  hintText: 'End Location',
                  label: 'End Location',
                  textFieldController: widget.endLocationController,
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Text('Route Direction', style: typo.bodyText),
                    const SizedBox(width: 8.0),
                    DropdownButton<RouteModel.RouteDirection>(
                      value: selectedDirection,
                      onChanged: (RouteModel.RouteDirection? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedDirection =
                                newValue; // Update selectedDirection
                          });
                        }
                      },
                      items: routeDirections
                          .map<DropdownMenuItem<RouteModel.RouteDirection>>(
                        (RouteModel.RouteDirection value) {
                          return DropdownMenuItem<RouteModel.RouteDirection>(
                            value: value,
                            child:
                                Text(RouteModel.routeDirectionToString(value)),
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
                widget.isUpdate == true
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: MapWidget(
                          geometry: widget.geometry,
                          startCoords: LatLng(widget.startCoords.coordinates[1],
                              widget.startCoords.coordinates[0]),
                          endCoords: LatLng(widget.endCoords.coordinates[1],
                              widget.endCoords.coordinates[0]),
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 16.0),
                bigButton(context, 'Save', () {
                  if (formKey.currentState!.validate()) {
                    final shipperId = context
                        .read<AccountBloc>()
                        .state
                        .account!
                        .shipper!
                        .shipperId;

                    // Create a new Route instance
                    final newRoute = RouteModel.Route(
                      routeId: widget.routeId ?? "",
                      shipperId: shipperId,
                      routeName: widget.routeNameController.text,
                      startLocation: widget.startLocationController.text,
                      endLocation: widget.endLocationController.text,
                      isActive: isActive,
                      routeDirection: selectedDirection,
                      startCoordinates: widget.startCoords,
                      endCoordinates: widget.endCoords,
                      isVirtual: false,
                      distance: widget.distance,
                      duration: widget.duration,
                      geometry: widget.geometry,
                    );

                    if (widget.isUpdate == true) {
                      context
                          .read<MapBloc>()
                          .add(UpdateRouteByIdEvent(widget.routeId!, newRoute));
                    } else {
                      context.read<MapBloc>().add(SaveRouteEvent(newRoute));
                    }
                    Navigator.pop(context);
                  } else {
                    return;
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
