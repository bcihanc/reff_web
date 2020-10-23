import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_shared/core/services/services.dart';
import 'package:reff_web/core/models/Unions.dart';
import 'package:reff_web/core/providers/busy_state_notifier.dart';
import 'package:reff_web/core/utils/locator.dart';

class FilterChangeNotifier extends ChangeNotifier {
  static final provider =
      ChangeNotifierProvider((ref) => FilterChangeNotifier());
  DateTime _dateTime = DateTime.now();
  DateTime get dateTime => _dateTime;
  void setDateTime(DateTime dateTime) {
    _dateTime = dateTime;
    notifyListeners();
  }
}

class QuestionWithAnswersChangeNotifier extends ChangeNotifier {
  QuestionWithAnswersChangeNotifier(this.ref);

  static final provider =
      ChangeNotifierProvider((ref) => QuestionWithAnswersChangeNotifier(ref));

  final _logger = Logger("QuestionProvider");

  QuestionModel question;
  List<AnswerModel> answers;
  QuestionExistsState questionExistsState;
  final ProviderReference ref;

  void initialize(
      {@required QuestionModel question, @required List<AnswerModel> answers}) {
    this.question = question;
    this.answers = answers;

    questionExistsState = (question?.id != null)
        ? QuestionExistsState.exsist()
        : QuestionExistsState.notExsist();
    _logger.info("initialized complete : ${question.toString()}");
  }

//  void onReorderAnswerListToModel(int oldIndex, int newIndex) {
//    if (newIndex > oldIndex) {
//      newIndex -= 1;
//    }
//    final item = answers.removeAt(oldIndex);
//    answers.insert(newIndex, item);
//    notifyListeners();
//
//    _logger.info("$answers");
//    _logger.info("onReorderAnswerList | tercih sırası değiştirildi");
//  }

  void updateStartDate(int startDate) {
    question = question.copyWith.call(startDate: startDate);
    notifyListeners();
    _logger.info("updateStartDate | tarih değişti");
  }

  void updateEndDate(int endDate) {
    question = question.copyWith.call(endDate: endDate);
    notifyListeners();
    _logger.info("updateEndDate | tarih değişti");
  }

  void updateImageUrl(String imageUrl) {
    question = question.copyWith.call(imageUrl: imageUrl);
    notifyListeners(); // resim için build çalışması şart
    _logger.info("changeImageUrl | imageUrl değişti");
  }

  void updateHeader(String header) {
    question = question.copyWith.call(header: header);
    _logger.info("changeHeader | header değişti");
  }

  void updateContent(String content) {
    question = question.copyWith.call(content: content);
    _logger.info("changeContent | content değişti");
  }

  void addAnswer(AnswerModel answer) {
    answers.add(answer);
    notifyListeners();
    _logger.info("addAnswer | yeni tercih eklendi");
  }

  void updateActive({bool activate}) {
    question = question.copyWith.call(isActive: activate);
    notifyListeners();
    _logger.info("updateActive | $activate");
  }

  void updateCity(CityModel city) {
    question = question.copyWith.call(city: city);
    notifyListeners();
    _logger.info("updateCity | ${city.name}");
  }

  void removeAnswer(AnswerModel answer) {
    if (answers.contains(answer)) {
      final result = answers.remove(answer);

      if (answer.id != null) {
        final willRemoveAnswerID =
            question.answers.firstWhere((element) => element == answer.id);

        question.answers.remove(willRemoveAnswerID);
      }

      result
          ? _logger.info("removeAnswer | tercih kaldırıldı")
          : _logger.info("removeAnswer | tercih kaldırılamadı");
    }
    notifyListeners();
  }

  void updateAnswer(AnswerModel original, AnswerModel newAnswer) {
    final index = answers.indexOf(original);
    if (!index.isNegative && original != newAnswer) {
      answers.removeAt(index);
      answers.insert(index, newAnswer);
      notifyListeners();
      _logger.info("updateAnswer | tercih değiştirildi");
    } else {
      _logger.info("updateAnswer | tercih değiştirilMEDI");
    }
  }

  Future<void> initializeWithAnswers(QuestionModel question) async {
    ref.read(BusyState.provider).busy();
    final answerApi = locator<BaseAnswerApi>();
    final answers = await answerApi.gets(question.answers);
    initialize(answers: answers, question: question);
    ref.read(BusyState.provider).notBusy();
  }

  Future<void> removeQuestionWithAnswers(String questionID) async {
    ref.read(BusyState.provider).busy();
    await locator<BaseQuestionApi>().remove(questionID);
    ref.read(BusyState.provider).notBusy();
  }

  Future<bool> saveToFirebase({@required bool validation}) async {
    final answerApi = locator<BaseAnswerApi>();
    final questionApi = locator<BaseQuestionApi>();

    if (answers.isNotEmpty && validation) {
      ref.read(BusyState.provider).busy();

      await questionExistsState.when(
        // yeni bir question kaydedilirken
        notExsist: () async {
          final ids = await answerApi.adds(answers);
          _logger.info('saveAll : ${ids.length} adet tercih kaydedildi');

          final newQuestion = question.copyWith.call(answers: ids);
          final questionID = await questionApi.add(newQuestion);
          _logger.info('saveAll : yeni bir soru yaratıldı $questionID');
        },

        // varolan bir question güncellenirken
        exsist: () async {
          final newAnswers = <AnswerModel>[];

          for (final answer in answers) {
            if (answer.id != null) {
              await answerApi.update(answer.id, answer);
              await questionApi.update(question.id, question);
            } else {
              newAnswers.add(answer);
              answers.remove(answer);
            }
            if (newAnswers.isNotEmpty) {
              final ids = await answerApi.adds(newAnswers);
              question.answers.addAll(ids);
            }

            await questionApi.update(question.id, question);
          }
          _logger.info('updateAnswerToFirebase tercihler güncellendi');
        },
      );

      ref.read(BusyState.provider).notBusy();
      return true;
    } else {
      _logger.warning("saveToFirebase validaston hatası");
      ref.read(BusyState.provider).notBusy();
      return false;
    }
  }
}
