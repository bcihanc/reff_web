import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reff_web/core/utils/locator.dart';
import 'package:reff_web/core/utils/logger.dart';
import 'package:reff_web/view/screens/login_screen.dart';
import 'package:reff_web/view/screens/questions_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  loggerSteup();
  await setupLocator();
  runApp(ProviderScope(child: MyApp()));
}

final authState = StreamProvider<User>((_) {
  return FirebaseAuth.instance.authStateChanges();
});

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final auth = useProvider(authState);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reff Panel',
      theme: ThemeData.dark()
          .copyWith(primaryColor: Colors.blueGrey, accentColor: Colors.cyan),
      home: !kDebugMode
          ? auth.when(
              data: (data) => (data?.uid != null)
                  ? QuestionsScreen()
                  : Scaffold(body: LoginScreen()),
              loading: () =>
                  Scaffold(body: Center(child: CircularProgressIndicator())),
              error: (err, stack) => Text('$err'))
          : QuestionsScreen(),
    );
  }
}
