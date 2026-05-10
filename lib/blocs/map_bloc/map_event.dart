part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class SetMapStatusLoadingEvent extends MapEvent {}

class DeleteCurrentCreatingRouteEvent extends MapEvent {}

class GetShipperRoutesEvent extends MapEvent {
  final String shipperId;

  const GetShipperRoutesEvent(this.shipperId);

  @override
  List<Object?> get props => [shipperId];
}

class CreateRouteEvent extends MapEvent {
  final LatLng startCoords;
  final LatLng endCoords;
  final List<LatLng> waypoints;

  const CreateRouteEvent({
    required this.startCoords,
    required this.endCoords,
    this.waypoints = const [],
  });

  @override
  List<Object?> get props => [startCoords, endCoords, waypoints];
}

class SaveRouteEvent extends MapEvent {
  final Route routeData;

  const SaveRouteEvent(this.routeData);

  @override
  List<Object?> get props => [routeData];
}

class GetRouteByIdEvent extends MapEvent {
  final String routeId;

  const GetRouteByIdEvent(this.routeId);

  @override
  List<Object?> get props => [routeId];
}

class UpdateRouteByIdEvent extends MapEvent {
  final String routeId;
  final Route updateData;

  const UpdateRouteByIdEvent(this.routeId, this.updateData);

  @override
  List<Object?> get props => [routeId, updateData];
}

class DeleteRouteByIdEvent extends MapEvent {
  final String routeId;

  const DeleteRouteByIdEvent(this.routeId);

  @override
  List<Object?> get props => [routeId];
}
