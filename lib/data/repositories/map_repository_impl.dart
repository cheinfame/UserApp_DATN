// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:latlong2/latlong.dart';

import '../models/route_model.dart';
import '../services/map_service.dart';
import '../services/shared_preferences_service.dart';
import 'map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  final MapService mapService;
  final SharedPreferencesService _sharedPreferencesService;

  MapRepositoryImpl({
    required this.mapService,
    required SharedPreferencesService sharedPreferencesService,
  }) : _sharedPreferencesService = sharedPreferencesService;

  @override
  Future<Route> createRoute({
    required LatLng startCoords,
    required LatLng endCoords,
    List<LatLng> waypoints = const [],
  }) async {
    final token = _sharedPreferencesService.getStringValue('token');
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await mapService.createRoute(
      token,
      startCoords: startCoords,
      endCoords: endCoords,
      waypoints: waypoints,
    );

    // Create a JSON structure that mimics the expected format of the Route object
    final jsonRoute = {
      '_id': 'placeholder',
      'shipper_id': 'placeholder',
      'route_name': 'placeholder',
      'isActive': false,
      'route_direction': 'start_to_end',
      'start_location': 'placeholder',
      'start_coordinates': {
        "type": "Point",
        "coordinates": [startCoords.longitude, startCoords.latitude]
      },
      'end_location': 'placeholder',
      "end_coordinates": {
        "type": "Point",
        "coordinates": [endCoords.longitude, endCoords.latitude]
      },
      'isVirtual': false,
      'distance': response['route']['distance'],
      'duration': response['route']['duration'],
      'geometry': response['route']['geometry'],
    };
 

    // Parse the JSON object into a Route object
    Route createdRoute = Route.fromJson(jsonRoute);

    return createdRoute;
  }

  @override
  Future<Route> saveRoute(Route routeData) async {
    final token = _sharedPreferencesService.getStringValue('token');
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await mapService.saveRoute(token, routeData);
    // Map the response to your Route model
    return Route.fromJson(response['route']);
  }

  @override
  Future<List<Route>> getShipperRoutes(String shipperId) async {
    final token = _sharedPreferencesService.getStringValue('token');
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await mapService.getShipperRoutes(token, shipperId);
    // Map the response to a list of Route models
    return (response['routes'] as List)
        .map((routeJson) => Route.fromJson(routeJson))
        .toList();
  }

  @override
  Future<Route> getRouteById(String routeId) async {
    final token = _sharedPreferencesService.getStringValue('token');
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await mapService.getRouteById(token, routeId);
    // Map the response to your Route model
    return Route.fromJson(response['route']);
  }

  @override
  Future<Route> updateRouteById(String routeId, Route updatedData) async {
    final token = _sharedPreferencesService.getStringValue('token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response =
        await mapService.updateRouteById(token, routeId, updatedData);
    // Map the response to your Route model
    return Route.fromJson(response['route']);
  }

  @override
  Future<void> deleteRouteById(String routeId) async {
    final token = _sharedPreferencesService.getStringValue('token');
    if (token == null) {
      throw Exception('Token not found');
    }

    await mapService.deleteRouteById(token, routeId);
  }
}
