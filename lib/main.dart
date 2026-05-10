import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:packare/presentation/authentication_screens/screens/otp_verification_screen.dart';

import 'blocs/account_bloc/account_bloc.dart';
import 'blocs/map_bloc/map_bloc.dart';
import 'blocs/order_bloc/order_bloc.dart';
import 'data/services/shared_preferences_service.dart';
import 'firebase_options.dart';
import 'presentation/authentication_screens/screens/authentication_screen.dart';
import 'presentation/home_screens/screens/main_screen.dart';
import 'presentation/splash_screens/screens/splash_screen.dart';
import 'locator.dart';
import 'utils/notification_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationHandler.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isFirstTime = false;

  @override
  void initState() {
    super.initState();
    _checkFirstTimeLaunch();
  }

  Future<void> _checkFirstTimeLaunch() async {
    final prefs = locator<SharedPreferencesService>();
    final storedIsFirstTime = prefs.getBoolValue('is_first_time') ?? true;

    if (storedIsFirstTime) {
      await prefs.setBoolValue('is_first_time', false);
    }

    setState(() {
      isFirstTime = storedIsFirstTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountBloc>(
          create: (context) => locator<AccountBloc>()..add(LoginWithCache()),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => locator<OrderBloc>(),
        ),
        BlocProvider<MapBloc>(create: (context) => locator<MapBloc>()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        supportedLocales: const [Locale('vi'), Locale('en')],
        home: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            if (isFirstTime) {
              return SplashScreen();
            } else if (state.loginStatus == LoginStatus.login) {
             // return OtpVerificationScreen();
              return MainScreen();
            }  else {
              return AuthenticationScreen();
            }
          },
        ),
      ),
    );
  }
}
