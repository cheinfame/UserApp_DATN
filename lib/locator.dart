import 'package:get_it/get_it.dart';
import 'package:packare/data/repositories/order_repository_impl.dart';
import 'package:packare/data/services/order_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/account_bloc/account_bloc.dart';
import 'blocs/map_bloc/map_bloc.dart';
import 'blocs/order_bloc/create_order_process_cubit.dart';
import 'blocs/order_bloc/order_bloc.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/map_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/services/auth_service.dart';
import 'data/services/image_service.dart';
import 'data/services/map_service.dart';
import 'data/services/shared_preferences_service.dart';
import 'data/services/user_service.dart';
import 'data/services/websocket_service.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Register SharedPreferencesService with error handling
  try {
    final prefs = await SharedPreferences.getInstance();
    locator.registerLazySingleton<SharedPreferencesService>(
      () => SharedPreferencesService(prefs: prefs),
    );
  } catch (error) {
    print('Error getting SharedPreferences: $error');
  }

  // Register ImageService
  locator.registerLazySingleton(() => ImageService());

  // Register WebSocket Service
  locator.registerLazySingleton(() => WebSocketService());

  // Register Auth
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => AuthRepositoryImpl(
        authService: locator<AuthService>(),
        sharedPreferencesService: locator<SharedPreferencesService>(),
      ));

  // Register UserRepositoryImpl
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => UserRepositoryImpl(
        userApiService: locator<UserService>(),
        sharedPreferencesService: locator<SharedPreferencesService>(),
      ));

  // Register OrderRepositoryImpl
  locator.registerLazySingleton(() => OrderService());
  locator.registerLazySingleton(() => OrderRepositoryImpl(
        orderApiService: locator<OrderService>(),
        sharedPreferencesService: locator<SharedPreferencesService>(),
      ));

  // Register Account Bloc
  locator.registerLazySingleton(() => AccountBloc(
        authRepository: locator<AuthRepositoryImpl>(),
        userRepository: locator<UserRepositoryImpl>(),
      ));

  // Register Order Bloc
  locator.registerLazySingleton(() => OrderBloc(
        orderRepository: locator<OrderRepositoryImpl>(),
        imageService: locator<ImageService>(),
        userRepository: locator<UserRepositoryImpl>(),
      ));

  // Register CreateOrderProcessCubit
  locator.registerFactory(() => CreateOrderProcessCubit(
        orderRepository: locator<OrderRepositoryImpl>(),
      ));

  // Register MapRepoImpl
  locator.registerLazySingleton(() => MapService());
  locator.registerLazySingleton(
    () => MapRepositoryImpl(
      mapService: locator<MapService>(),
      sharedPreferencesService: locator<SharedPreferencesService>(),
    ),
  );

  // Register Map Bloc
  locator.registerLazySingleton(() => MapBloc(
        mapRepository: locator<MapRepositoryImpl>(),
      ));
}
