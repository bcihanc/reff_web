import 'package:get_it/get_it.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_web/core/providers/main_provider.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/core/services/firebase_api.dart';

final locator = GetIt.instance;

setupLocator() async {
  locator.registerLazySingleton(() => FirebaseApi());

  locator.registerFactory(() => MainProvider());

  locator
      .registerFactoryParam<QuestionProvider, QuestionModel, List<AnswerModel>>(
          (QuestionModel param1, List<AnswerModel> param2) =>
              QuestionProvider(questionModel: param1, answers: param2));

  await locator.allReady();
}
