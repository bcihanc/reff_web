import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:reff_web/core/locator.dart';
import 'package:reff_web/view/screens/questions_screen.dart';

final authState = StreamProvider<FirebaseUser>(
    (_) => FirebaseAuth.instance.onAuthStateChanged);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.ALL;
  hierarchicalLoggingEnabled = true;
  Logger.root.onRecord.listen((record) => debugPrint(
      '${record.level.name}: ${record.loggerName}: ${record.message}'));

  await setupLocator();
//  runApp(MultiProvider(
//    providers: [
//      StreamProvider<FirebaseUser>.value(
//          value: FirebaseAuth.instance.onAuthStateChanged),
//      ChangeNotifierProvider(create: (context) => locator<MainProvider>()),
//    ],
//    child: MyApp(),
//  ));
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final auth = useProvider(authState);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reff',
//      initialRoute: '/',
//      routes: {
//        QuestionsScreen.route: (context) => QuestionsScreen(),
//      },
      theme: ThemeData.dark()
          .copyWith(primaryColor: Colors.blueGrey, accentColor: Colors.cyan),
//      home: auth.when(
//          data: (data) => QuestionsScreen(),
//          loading: () => Text('auth loading'),
//          error: (err, stack) => Text('$err')),
      home: QuestionsScreen(),
    );
  }
}
