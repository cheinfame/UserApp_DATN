import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:packare/blocs/map_bloc/map_bloc.dart';
import 'package:packare/config/typography.dart';
import 'package:packare/locator.dart';
import 'package:packare/presentation/global_widgets/info_text_field.dart';

import '../../../data/services/location_search_service.dart';
import '../../map_screen/widgets/map_widget.dart';
import '../widgets/save_route_sheet.dart';

class CreateRouteScreen extends StatefulWidget {
  const CreateRouteScreen({super.key});

  @override
  State<CreateRouteScreen> createState() => _CreateRouteScreenState();
}

class _CreateRouteScreenState extends State<CreateRouteScreen> {
  final TextEditingController _startLocationSearchController =
      TextEditingController();
  final TextEditingController _endLocationSearchController =
      TextEditingController();
  final TextEditingController _routeNameController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LatLng? startCoords;
  LatLng? endCoords;

  List<Map<String, dynamic>> _searchResults = [];
  Timer? _debounceTimer;

  List<List<double>>? routeGeometry;

  late FocusNode _startLocationFocusNode;
  late FocusNode _endLocationFocusNode;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _startLocationFocusNode = FocusNode();
    _endLocationFocusNode = FocusNode();

    // Add listeners to focus nodes
    _startLocationFocusNode.addListener(_handleFocusChange);
    _endLocationFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _startLocationSearchController.dispose();
    _endLocationSearchController.dispose();
    _routeNameController.dispose();

    _startLocationFocusNode.removeListener(_handleFocusChange);
    _endLocationFocusNode.removeListener(_handleFocusChange);

    locator<MapBloc>().add(DeleteCurrentCreatingRouteEvent());

    super.dispose();
  }

  void searchLocations(String query) async {
    if (query.isNotEmpty) {
      if (_debounceTimer?.isActive ?? false) {
        _debounceTimer!.cancel();
      }

      _debounceTimer = Timer(const Duration(seconds: 1), () async {
        try {
          final results = await LocationSearchService.searchPlaces(query);
          if (results.containsKey('predictions')) {
            setState(() {
              _searchResults = List<Map<String, dynamic>>.from(
                results['predictions']
                    .map((prediction) => prediction as Map<String, dynamic>),
              );
            });
          } else {
            setState(() {
              _searchResults.clear();
            });
          }
        } catch (error) {
          print('Error searching places: $error');
        }
      });
    } else {
      setState(() {
        _searchResults.clear();
      });
    }
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused =
          _startLocationFocusNode.hasFocus || _endLocationFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(listener: (context, state) {
      if (state.loadingMapStatus == LoadMapStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Retrieve Route Successful!'),
            duration: Duration(
                seconds: 2), // Duration for which the SnackBar is visible
          ),
        );
      } else if (state.loadingMapStatus == LoadMapStatus.failed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Retrieve Route Failed!'),
            duration: Duration(
                seconds: 2), // Duration for which the SnackBar is visible
          ),
        );
      }
    }, builder: (context, state) {
      if (state.loadingMapStatus == LoadMapStatus.success) {
        routeGeometry = state.currentCreatingRoute!.geometry;
      }

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<MapBloc>().add(DeleteCurrentCreatingRouteEvent());
              Navigator.pop(context);
            },
          ),
          title: const Text('New Route'),
        ),
        body: Stack(
          children: [
            SizedBox.expand(
              child: MapWidget(
                startCoords: startCoords,
                endCoords: endCoords,
                geometry: routeGeometry,
              ),
            ),
            Material(
              elevation: 8.0,
              child: Container(
                color: Theme.of(context).colorScheme.background,
                height: _isFocused ? double.infinity : 170,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InfoTextField(
                      context: context,
                      isObscure: false,
                      isValid: true,
                      hintText: 'Start Location',
                      label: 'Start Location',
                      textFieldController: _startLocationSearchController,
                      focusNode: _startLocationFocusNode,
                      onChanged: (value) {
                        searchLocations(value);
                      },
                      suffixIcon: _startLocationSearchController.text.isNotEmpty
                          ? const Icon(Icons.clear)
                          : _startLocationFocusNode.hasFocus
                              ? const Icon(Icons.search)
                              : null,
                      onSuffixPressed: () {
                        _startLocationSearchController.clear();

                        setState(() {
                          startCoords = null;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    InfoTextField(
                      context: context,
                      isObscure: false,
                      isValid: true,
                      hintText: 'End Location',
                      label: 'End Location',
                      textFieldController: _endLocationSearchController,
                      focusNode: _endLocationFocusNode,
                      onChanged: (value) {
                        searchLocations(value);
                      },
                      suffixIcon: _endLocationSearchController.text.isNotEmpty
                          ? const Icon(Icons.clear)
                          : _endLocationFocusNode.hasFocus
                              ? const Icon(Icons.search)
                              : null,
                      onSuffixPressed: () {
                        _endLocationSearchController.clear();
                        // Clear endCoords
                        setState(() {
                          endCoords = null;
                        });
                      },
                    ),
                    if (_isFocused)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ListView.separated(
                              itemCount: _searchResults.length <= 5
                                  ? _searchResults.length
                                  : 5,
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Divider(),
                                  ),
                              itemBuilder: (context, index) {
                                final place = _searchResults[index];
                                return ListTile(
                                    title: Text(
                                        place['description'] ??
                                            'No address available',
                                        style: AppTypography(context: context)
                                            .bodyText),
                                    leading: const Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.blue,
                                    ),
                                    onTap: () async {
                                      final tappedPlace =
                                          await LocationSearchService
                                              .geocodeAddress(
                                                  place['description']);
                                      _startLocationFocusNode.hasFocus
                                          ? {
                                              _startLocationSearchController
                                                  .text = place['description'],
                                              setState(() {
                                                startCoords = LatLng(
                                                    tappedPlace['results'][0]
                                                            ['geometry']
                                                        ['location']['lat'],
                                                    tappedPlace['results'][0]
                                                            ['geometry']
                                                        ['location']['lng']);
                                              })
                                            }
                                          : {
                                              _endLocationSearchController
                                                  .text = place['description'],
                                              setState(() {
                                                endCoords = LatLng(
                                                    tappedPlace['results'][0]
                                                            ['geometry']
                                                        ['location']['lat'],
                                                    tappedPlace['results'][0]
                                                            ['geometry']
                                                        ['location']['lng']);
                                              })
                                            };

                                      // Check if both startCoords and endCoords are not null
                                      if (startCoords != null &&
                                          endCoords != null &&
                                          context.mounted) {
                                        context.read<MapBloc>().add(
                                            CreateRouteEvent(
                                                startCoords: startCoords!,
                                                endCoords: endCoords!));
                                      }
                                      _startLocationFocusNode.unfocus();
                                      _endLocationFocusNode.unfocus();
                                    });
                              }),
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: state.loadingMapStatus == LoadMapStatus.success
            ? Padding(
                padding: const EdgeInsets.only(bottom: 64.0),
                child: SizedBox(
                  width: 120,
                  height: 48,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return SaveRouteSheet(
                            routeNameController: _routeNameController,
                            geometry: state.currentCreatingRoute!.geometry,
                            startCoords:
                                state.currentCreatingRoute!.startCoordinates,
                            endCoords:
                                state.currentCreatingRoute!.endCoordinates,
                            duration: state.currentCreatingRoute!.duration,
                            distance: state.currentCreatingRoute!.distance,
                            startLocationController:
                                _startLocationSearchController,
                            endLocationController: _endLocationSearchController,
                          );
                        },
                      );
                    },
                    elevation: 8.0,
                    child: Text(
                      'Save Route',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 15.0),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }
}
