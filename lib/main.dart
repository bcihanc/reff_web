import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:reff_web/core/locator.dart';
import 'package:reff_web/core/providers/main_provider.dart';
import 'package:reff_web/view/screens/login_screen.dart';
import 'package:reff_web/view/screens/questions_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.ALL;
  hierarchicalLoggingEnabled = true;
  Logger.root.onRecord.listen((record) => debugPrint(
      '${record.level.name}: ${record.loggerName}: ${record.message}'));

  await setupLocator();
  runApp(MultiProvider(
    providers: [
      StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged),
      ChangeNotifierProvider(create: (context) => locator<MainProvider>()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reff',
      initialRoute: '/',
      routes: {
        QuestionsScreen.route: (context) => QuestionsScreen(),
      },
      theme: ThemeData.dark()
          .copyWith(primaryColor: Colors.blueGrey, accentColor: Colors.cyan),
      home: Builder(builder: (context) {
        final user = Provider.of<FirebaseUser>(context);
        return Scaffold(
          body:
              (user != null || kDebugMode) ? QuestionsScreen() : LoginScreen(),
        );
      }),
    );
  }
}
