import 'package:get_it/get_it.dart';
import 'package:reff_shared/core/services/answer_api.dart';
import 'package:reff_shared/core/services/api.dart';
import 'package:reff_shared/core/services/question_api.dart';
import 'package:reff_web/core/services/firestore_api.dart';

final locator = GetIt.instance;

setupLocator() async {
  locator.registerLazySingleton<BaseQuestionApi>(() => QuestionFirestoreApi());
  locator.registerLazySingleton<BaseAnswerApi>(() => AnswerFirestoreApi());

  locator.registerLazySingleton<BaseApi>(() => FirestoreApi());

//  locator.registerFactory<MainProvider>(() => MainProvider());
//
//  locator.registerFactoryParam<QuestionProvider, QuestionModel,
//          List<AnswerModel>>(
//      (QuestionModel param1, List<AnswerModel> param2) => QuestionProvider());

  await locator.allReady();
}
