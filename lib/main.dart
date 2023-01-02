import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reproducible_login/router.dart';

import 'auth.dart';
import 'firebase_options.dart';
import 'locator.dart';

/// Whether the emulator is used.
const bool useEmulator = false;

void main() async {
  setupLocator();
  runZonedGuarded(() async {
    final WidgetsBinding widgetsBinding =
        WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (useEmulator) {
      final String emulatorHost =
          (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
              ? '10.0.2.2'
              : 'localhost';
      await FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
    }
    final AuthModel authModel = locator<AuthModel>();
    //authModel.setPersistence();
    //authModel.checkLoggedIn();
    authModel.checkLoggedIn();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]).then((_) {
      usePathUrlStrategy();
      runApp(MultiProvider(
          // ignore: always_specify_types
          providers: [
            ChangeNotifierProvider<AuthModel>(
                create: (BuildContext context) => authModel),
            Provider<MyRouter>(
              lazy: false,
              create: (BuildContext createContext) => MyRouter(authModel),
            ),
          ],
          child: Consumer<AuthModel>(
              builder:
                  (BuildContext context, AuthModel authModel, Widget? child) =>
                      const LoginReproducible())));
    });
  }, (Object error, StackTrace stack) {
    //myErrorsHandler.onError(error, stack);
  });
}

class LoginReproducible extends StatefulWidget {
  const LoginReproducible({super.key});

  @override
  State<LoginReproducible> createState() => _LoginReproducibleState();
}

class _LoginReproducibleState extends State<LoginReproducible> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter router = context.read<MyRouter>().router;
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
    );
  }
}
