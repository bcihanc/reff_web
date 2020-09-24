import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reff_shared/core/services/services.dart';
import 'package:reff_web/core/providers/providers.dart';
import 'package:reff_web/core/utils/locator.dart';
import 'package:reff_web/core/utils/logger.dart';
import 'package:reff_web/view/screens/home_screen.dart';
import 'package:reff_web/view/screens/login_screen.dart';
import 'package:reff_web/view/screens/questions_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  loggerSetup();
  await setupLocator();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final authState = useProvider(Providers.authStateStreamProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reff Panel',
      theme: ThemeData(
          accentColor: Colors.blueGrey,
          buttonColor: Colors.blueGrey,
          appBarTheme: AppBarTheme(color: Colors.blueGrey),
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.blueGrey,
              textTheme: ButtonTextTheme.primary)),
      darkTheme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.blueGrey),
        brightness: Brightness.dark,
        accentColor: Colors.blueGrey,
        buttonColor: Colors.blueGrey,
      ),
      home: kDebugMode
          ? HomeScreen()
          : authState.when(
              data: (user) {
                return user != null ? HomeScreen() : LoginScreen();
              },
              loading: () => Material(
                  child: Center(child: SpinKitWave(color: Colors.grey))),
              error: (err, stack) =>
                  Material(child: Center(child: Text('$err')))),
    );
  }
}
