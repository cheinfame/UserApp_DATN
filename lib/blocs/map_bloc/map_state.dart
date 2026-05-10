// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'map_bloc.dart';

enum MapBlocStatus { initial, loading, success, failed }

enum LoadMapStatus { initial, loading, success, failed }

enum UpdateRouteStatus { initial, loading, success, failed }

class MapState {

  // For creating new Route
  final Route? currentCreatingRoute;
  final List<Route> routes;
  final MapBlocStatus status;
  final UpdateRouteStatus? updateRouteStatus;
  final String? error;
  final LoadMapStatus? loadingMapStatus;

  MapState({
    this.currentCreatingRoute,
    required this.routes,
    required this.status,
    this.error,
    this.updateRouteStatus,
    this.loadingMapStatus,
  });

  MapState copyWith({
    Route? currentCreatingRoute,
    List<Route>? routes,
    MapBlocStatus? status,
    UpdateRouteStatus? updateRouteStatus,
    String? error,
    LoadMapStatus? loadingMapStatus,
  }) {
    return MapState(
      currentCreatingRoute: currentCreatingRoute ?? this.currentCreatingRoute,
      routes: routes ?? this.routes,
      status: status ?? this.status,
      updateRouteStatus: updateRouteStatus ?? this.updateRouteStatus,
      error: error ?? this.error,
      loadingMapStatus: loadingMapStatus ?? this.loadingMapStatus,
    );
  }
}
