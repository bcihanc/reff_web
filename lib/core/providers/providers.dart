import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_shared/core/services/services.dart';
import 'package:reff_web/core/utils/locator.dart';

mixin Providers {
  static final firebaseAuthProvider = Provider((_) => FirebaseAuth.instance);
  static final authStateStreamProvider =
      StreamProvider.autoDispose<User>((ref) {
    final auth = ref.watch(firebaseAuthProvider);
    return auth.authStateChanges();
  });

  static final resultByQuestionIDFutureProvider = FutureProvider.family
      .autoDispose<ResultModel, String>((ref, questionID) =>
          locator<BaseResultApi>().getByQuestion(questionID));

  static final answersFutureProvider =
      FutureProvider.family<List<AnswerModel>, List<String>>(
          (ref, answersIDs) => locator<BaseAnswerApi>().gets(answersIDs));

  static final questionsFutureProvider = FutureProvider.autoDispose((ref) =>
      locator<BaseQuestionApi>().gets(limit: 50, orderByFirstNew: true));

  static final questionFutureProvider =
      FutureProvider.family<QuestionModel, String>(
          (ref, questionID) => locator<BaseQuestionApi>().get(questionID));
}
