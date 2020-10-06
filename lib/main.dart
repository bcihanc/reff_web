import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_shared/core/services/services.dart';
import 'package:reff_web/core/providers/providers.dart';
import 'package:reff_web/core/utils/locator.dart';
import 'package:reff_web/core/utils/logger.dart';
import 'package:reff_web/view/screens/home_screen.dart';
import 'package:reff_web/view/screens/login_screen.dart';
import 'package:reff_web/view/screens/questions_screen.dart';
import 'package:reff_web/view/screens/result_screen/result_info.dart';

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

// final agesMap = ResultModelHelper.createAgeMap({
//   "1": randomVotes(),
//   "2": randomVotes(),
//   "3": randomVotes(),
//   "4": randomVotes(),
// });
//
// final gendersMap = ResultModelHelper.createGenderMap({
//   "1": randomVotes(),
//   "2": randomVotes(),
//   "3": randomVotes(),
//   "4": randomVotes(),
// });
//
// final cityMap = ResultModelHelper.createCityNameMap({
//   "1": randomVotes(),
//   "2": randomVotes(),
//   "3": randomVotes(),
//   "4": randomVotes(),
// });
//
// final educationMap = ResultModelHelper.createEducationMap({
//   "1": randomVotes(),
//   "2": randomVotes(),
//   "3": randomVotes(),
//   "4": randomVotes(),
// });
//
// final result = ResultModel(
//     questionID: "1",
//     answers: answers.map((e) => e.id).toList(),
//     agesMap: agesMap,
//     gendersMap: gendersMap,
//     cityNameMap: cityMap,
//     educationMap: educationMap);

// final answers = [
//   AnswerModel(id: "1", content: "Seçenek A"),
//   AnswerModel(id: "2", content: "Seçenek B"),
//   AnswerModel(id: "3", content: "Seçenek C"),
//   AnswerModel(id: "4", content: "Seçenek D"),
// ];
//
// List<VoteModel> randomVotes() {
//   final votes = <VoteModel>[];
//
//   for (var i = 0; i < 10000; i++) {
//     final randomAnswer = () {
//       final randomIndex = Random().nextInt(answers.length);
//       return answers[randomIndex].id;
//     }();
//
//     final randomAge = Random().nextInt(88) + 10;
//     final randomCity = () {
//       final citiesLength = CityModel.cities.length;
//       final randomIndex = Random().nextInt(citiesLength);
//       return CityModel.cities[randomIndex];
//     }();
//
//     final randomGender = () {
//       final randomIndex = Random().nextInt(Gender.values.length);
//       return Gender.values[randomIndex];
//     }();
//
//     final randomEducation = () {
//       final randomIndex = Random().nextInt(Education.values.length);
//       return Education.values[randomIndex];
//     }();
//
//     final randomVote = VoteModel(
//         userID: Random().nextInt(99).toString(),
//         age: randomAge,
//         gender: randomGender,
//         city: randomCity,
//         questionID: "1",
//         answerID: randomAnswer,
//         createdDate: DateTime.now().millisecondsSinceEpoch,
//         education: randomEducation);
//
//     votes.add(randomVote);
//   }
//   return votes;
// }
