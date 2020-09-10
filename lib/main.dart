import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reff_web/core/services/firestore_api.dart';
import 'package:reff_web/core/utils/locator.dart';
import 'package:reff_web/core/utils/logger.dart';
import 'package:reff_web/view/screens/login_screen.dart';
import 'package:reff_web/view/screens/questions_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  loggerSetup();
  await setupLocator();
  runApp(ProviderScope(child: MyApp()));
}

final authState = StreamProvider.autoDispose<User>(
    (_) => FirebaseAuth.instance.authStateChanges());

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final auth = useProvider(authState);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reff Panel',
      theme: ThemeData(accentColor: Colors.blueGrey),
      darkTheme: ThemeData.dark().copyWith(accentColor: Colors.blueGrey),
      home: kDebugMode
          ? QuestionsScreen()
          : auth.when(
              data: (data) {
                return data != null
                    ? QuestionsScreen()
                    : Scaffold(body: LoginScreen());
              },
              loading: () =>
                  Scaffold(body: Center(child: CircularProgressIndicator())),
              error: (err, stack) => Text('$err')),
    );
  }
}
