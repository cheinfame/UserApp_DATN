import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import '../../data/repositories/map_repository_impl.dart';
import '../../data/models/route_model.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepositoryImpl mapRepository;

  MapBloc({
    required this.mapRepository,
  }) : super(MapState(
          routes: [],
          status: MapBlocStatus.initial,
        )) {
    on<CreateRouteEvent>(_onCreateRouteEvent);
    on<SaveRouteEvent>(_onSaveRouteEvent);
    on<GetShipperRoutesEvent>(_onGetShipperRoutesEvent);
    on<GetRouteByIdEvent>(_onGetRouteByIdEvent);
    on<UpdateRouteByIdEvent>(_onUpdateRouteByIdEvent);
    on<DeleteRouteByIdEvent>(_onDeleteRouteByIdEvent);
    on<SetMapStatusLoadingEvent>(_onSetMapStatusLoadingEvent);
    on<DeleteCurrentCreatingRouteEvent>(_onDeleteCurrentCreatingRouteEvent);
  }
  void _onDeleteCurrentCreatingRouteEvent(
      DeleteCurrentCreatingRouteEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(
        currentCreatingRoute: null, loadingMapStatus: LoadMapStatus.initial));
  }

  void _onSetMapStatusLoadingEvent(
      SetMapStatusLoadingEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(status: MapBlocStatus.loading));
  }

  void _onCreateRouteEvent(
      CreateRouteEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(
      loadingMapStatus: LoadMapStatus.loading,
    ));
    try {
      final route = await mapRepository
          .createRoute(
            startCoords: event.startCoords,
            endCoords: event.endCoords,
            waypoints: event.waypoints,
          )
          .timeout(const Duration(seconds: 30));

      emit(state.copyWith(
        loadingMapStatus: LoadMapStatus.success,
        currentCreatingRoute: route,
      ));
    } catch (error) {
      emit(state.copyWith(
          loadingMapStatus: LoadMapStatus.failed,
          error: (error is TimeoutException)
              ? 'The request timed out. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onSaveRouteEvent(SaveRouteEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(status: MapBlocStatus.loading));
    try {
      final route = await mapRepository
          .saveRoute(event.routeData)
          .timeout(const Duration(seconds: 30));

      final updatedRoutes = state.routes..add(route);

      emit(
          state.copyWith(status: MapBlocStatus.success, routes: updatedRoutes));
    } catch (error) {
      emit(state.copyWith(
          status: MapBlocStatus.failed,
          error: (error is TimeoutException)
              ? 'The request timed out. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onGetShipperRoutesEvent(
      GetShipperRoutesEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(status: MapBlocStatus.loading));
    try {
      final routes = await mapRepository
          .getShipperRoutes(event.shipperId)
          .timeout(const Duration(seconds: 30));

      routes.sort((a, b) {
        // Sort isActive routes first
        if (a.isActive && !b.isActive) {
          return -1; // a comes before b
        } else if (!a.isActive && b.isActive) {
          return 1; // b comes before a
        } else {
          return 0; // maintain current order
        }
      });

      emit(state.copyWith(status: MapBlocStatus.success, routes: routes));
    } catch (error) {
      emit(state.copyWith(
          status: MapBlocStatus.failed,
          error: (error is TimeoutException)
              ? 'The request timed out. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onGetRouteByIdEvent(
      GetRouteByIdEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(status: MapBlocStatus.loading));
    try {
      final route = await mapRepository
          .getRouteById(event.routeId)
          .timeout(const Duration(seconds: 30));

      emit(state.copyWith(
          status: MapBlocStatus.success, currentCreatingRoute: route));
    } catch (error) {
      emit(state.copyWith(
          status: MapBlocStatus.failed,
          error: (error is TimeoutException)
              ? 'The request timed out. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onUpdateRouteByIdEvent(
      UpdateRouteByIdEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(updateRouteStatus: UpdateRouteStatus.loading));
    try {
      final route = await mapRepository
          .updateRouteById(event.routeId, event.updateData)
          .timeout(const Duration(seconds: 30));

      final updatedRoutes = List<Route>.from(state.routes);
      final index = updatedRoutes
          .indexWhere((element) => element.routeId == route.routeId);
      if (index != -1) {
        updatedRoutes[index] = route;
      }

      emit(state.copyWith(
          routes: updatedRoutes, updateRouteStatus: UpdateRouteStatus.success));
    } catch (error) {
      emit(state.copyWith(
          updateRouteStatus: UpdateRouteStatus.failed,
          error: (error is TimeoutException)
              ? 'The request timed out. Please check your internet connection and try again.'
              : error.toString()));
    }
  }

  void _onDeleteRouteByIdEvent(
      DeleteRouteByIdEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(status: MapBlocStatus.loading));
    try {
      await mapRepository
          .deleteRouteById(event.routeId)
          .timeout(const Duration(seconds: 30));
      final updatedRoutes = List<Route>.from(state.routes);
      final index = updatedRoutes
          .indexWhere((element) => element.routeId == event.routeId);
      if (index != -1) {
        updatedRoutes.removeAt(index);
      }
      emit(
          state.copyWith(status: MapBlocStatus.success, routes: updatedRoutes));
    } catch (error) {
      emit(state.copyWith(
          status: MapBlocStatus.failed,
          error: (error is TimeoutException)
              ? 'The request timed out. Please check your internet connection and try again.'
              : error.toString()));
    }
  }
}
