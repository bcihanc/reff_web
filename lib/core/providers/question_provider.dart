import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_shared/core/services/api.dart';
import 'package:reff_web/core/locator.dart';
import 'package:reff_web/core/models/Unions.dart';
import 'package:reff_web/core/providers/main_provider.dart';

final questionStateProvider =
    ChangeNotifierProvider((ref) => QuestionProvider(ref));

class QuestionProvider with ChangeNotifier {
  final _logger = Logger("QuestionProvider");
  final api = locator<BaseApi>();

  final ProviderReference _ref;

  QuestionExistsState questionExistsState;

  QuestionModel question;
  List<AnswerModel> answers;

  QuestionProvider(this._ref);

//  QuestionProvider({QuestionModel question, List<AnswerModel> answers}) {
//    this.question =
//        question ?? QuestionModel(header: "", timeStamp: DateTime.now());
//    this.answers = answers ?? <AnswerModel>[];
//  }

  void initialize({QuestionModel question, List<AnswerModel> answers}) {
    _logger.info("initialize");
    this.question =
        question ?? QuestionModel(header: "", timeStamp: DateTime.now());
    this.answers = answers ?? <AnswerModel>[];

    this.questionExistsState = (question?.id != null)
        ? QuestionExistsState.exsist()
        : QuestionExistsState.notExsist();
  }

  void onReorderAnswerListToModel(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = answers.removeAt(oldIndex);
    answers.insert(newIndex, item);
    _logger.info("onReorderAnswerList | tercih sırası değiştirildi");
  }

  void updateDate(DateTime dateTime) {
    this.question = this.question.copyWith.call(timeStamp: dateTime);
    notifyListeners();
    _logger.info("changeDate | tarih değişti");
  }

  void updateImageUrl(String imageUrl) {
    this.question = this.question.copyWith.call(imageUrl: imageUrl);
    notifyListeners(); // resim için build çalışması şart
    _logger.info("changeImageUrl | imageUrl değişti");
  }

  void updateHeader(String header) {
    this.question = this.question.copyWith.call(header: header);
    _logger.info("changeHeader | header değişti");
  }

  void updateContent(String content) {
    this.question = this.question.copyWith.call(content: content);
    _logger.info("changeContent | content değişti");
  }

  void addAnswer(AnswerModel answer) {
    this.answers.add(answer);
    notifyListeners();
    _logger.info("addAnswer | yeni tercih eklendi");
  }

  void removeAnswer(AnswerModel answer) {
    if (this.answers.contains(answer)) {
      final result = this.answers.remove(answer);

      if (answer.id != null) {
        final willRemoveAnswerID =
            this.question.answers.firstWhere((element) => element == answer.id);

        this.question.answers.remove(willRemoveAnswerID);
      }

      result
          ? _logger.info("removeAnswer | tercih kaldırıldı")
          : _logger.info("removeAnswer | tercih kaldırılamadı");
    }
    notifyListeners();
  }

  void updateAnswer(AnswerModel original, AnswerModel newAnswer) {
    final index = this.answers.indexOf(original);
    if (!index.isNegative && original != newAnswer) {
      answers.removeAt(index);
      answers.insert(index, newAnswer);
      notifyListeners();
      _logger.info("updateAnswer | tercih değiştirildi");
    } else {
      _logger.info("updateAnswer | tercih değiştirilMEDI");
    }
  }

  Future<bool> saveToFirebase() async {
    if (this.answers.isNotEmpty &&
        _ref.read(headerFormKey).currentState.validate() &&
        _ref.read(contentFormKey).currentState.validate() &&
        _ref.read(imageUrlFormKey).currentState.validate()) {
      await this.questionExistsState.when(
        // yeni bir question kaydedilirken
        notExsist: () async {
          final ids = await api.answer.add(answers);
          _logger.info('saveAll : ${ids.length} adet tercih kaydedildi');

          final question = this.question.copyWith.call(answers: ids);
          final questionID = await api.question.add(question);
          _logger.info('saveAll : yeni bir soru yaratıldı $questionID');
        },

        // varolan bir question güncellenirken
        exsist: () async {
          var newAnswers = <AnswerModel>[];

          for (final answer in this.answers) {
            if (answer.id != null) {
              await api.answer.update(answer.id, answer);
              await api.question.update(this.question.id, this.question);
            } else {
              newAnswers.add(answer);
              this.answers.remove(answer);
            }
            if (newAnswers.isNotEmpty) {
              final ids = await api.answer.add(newAnswers);
              this.question.answers.addAll(ids);
            }

            await api.question.update(this.question.id, this.question);
          }
          _logger.info('updateAnswerToFirebase tercihler güncellendi');
        },
      );
      return true;
    } else
      return false;
  }
}
