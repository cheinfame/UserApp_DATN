import 'package:latlong2/latlong.dart';

import '../models/route_model.dart';

abstract class MapRepository {
  Future<Route> createRoute({
    required LatLng startCoords,
    required LatLng endCoords,
    List<LatLng> waypoints = const [],
  });

  Future<Route> saveRoute(Route routeData);

  Future<List<Route>> getShipperRoutes(String shipperId);

  Future<Route> getRouteById(String routeId);

  Future<Route> updateRouteById(String routeId, Route updatedData);

  Future<void> deleteRouteById(String routeId);
}
