import 'package:get_it/get_it.dart';
import 'package:reff_shared/core/services/services.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton<BaseQuestionApi>(() => QuestionFirestoreApi());
  locator.registerLazySingleton<BaseAnswerApi>(() => AnswerFirestoreApi());
  locator.registerLazySingleton<BaseUserApi>(() => UserFirebaseApi());
  locator.registerLazySingleton<BaseResultApi>(() => ResultFirestoreApi());
  locator.registerLazySingleton<BaseVoteApi>(() => VoteFirebaseApi());

  await locator.allReady();
}
