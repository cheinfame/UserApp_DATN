// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:packare/blocs/order_bloc/create_order_process_cubit.dart';
import '../../../config/typography.dart';
import '../../../data/services/location_search_service.dart';

class CustomFloatingSearchBar extends StatefulWidget {
  final bool isSend;

  CustomFloatingSearchBar({
    Key? key,
    required this.isSend,
  }) : super(key: key);

  @override
  State<CustomFloatingSearchBar> createState() =>
      _CustomFloatingSearchBarState();
}

class _CustomFloatingSearchBarState extends State<CustomFloatingSearchBar> {
  List<Map<String, dynamic>> _searchResults = [];
  late FloatingSearchBarController _searchBarController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchBarController = FloatingSearchBarController();
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  void searchLocations(String query) async {
    if (query.isNotEmpty) {
      if (_debounceTimer?.isActive ?? false) {
        _debounceTimer!.cancel();
      }

      _debounceTimer = Timer(Duration(seconds: 1), () async {
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

  @override
  Widget build(BuildContext context) {
    final currentLocation = widget.isSend
        ? context.watch<CreateOrderProcessCubit>().state.sendLocation
        : context.watch<CreateOrderProcessCubit>().state.receiveLocation;
    return FloatingSearchBar(
      controller: _searchBarController,
      backdropColor: Colors.transparent,
      elevation: 0,
      height: 62,
      margins: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      border: BorderSide(color: Theme.of(context).colorScheme.outline),
      borderRadius: BorderRadius.circular(12.0),
      body: FloatingSearchBarScrollNotifier(
        child: Container(),
      ),
      transition: CircularFloatingSearchBarTransition(),
      physics: const BouncingScrollPhysics(),
      title: Text(
          currentLocation.isNotEmpty
              ? currentLocation
              : widget.isSend
                  ? 'Send Location'
                  : 'Receive Location',
          style: AppTypography(context: context).bodyText),
      hint: 'Type to start searching...',
      hintStyle: AppTypography(context: context).bodyText,
      automaticallyImplyBackButton: false,
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      onQueryChanged: searchLocations,
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: ListView.builder(
              // limits return to only 5 best location
              itemCount: _searchResults.length <= 5 ? _searchResults.length : 5,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final place = _searchResults[index];
                return ListTile(
                  title: Text(place['description'] ?? 'No address available',
                      style: AppTypography(context: context).bodyText),
                  onTap: () async {
                    final tappedPlace =
                        await LocationSearchService.geocodeAddress(
                            place['description']);

                    if (widget.isSend) {
                      context
                          .read<CreateOrderProcessCubit>()
                          .updateSendLocation(place['description']);
                      context.read<CreateOrderProcessCubit>().updateSendLat(
                          tappedPlace['results'][0]['geometry']['location']
                              ['lat']);
                      context.read<CreateOrderProcessCubit>().updateSendLng(
                          tappedPlace['results'][0]['geometry']['location']
                              ['lng']);
                    } else {
                      context
                          .read<CreateOrderProcessCubit>()
                          .updateReceiveLocation(place['description']);
                      context.read<CreateOrderProcessCubit>().updateReceiveLat(
                          tappedPlace['results'][0]['geometry']['location']
                              ['lat']);
                      context.read<CreateOrderProcessCubit>().updateReceiveLng(
                          tappedPlace['results'][0]['geometry']['location']
                              ['lng']);
                    }
                    _searchBarController.close();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
