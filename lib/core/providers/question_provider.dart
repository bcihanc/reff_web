import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_shared/core/services/api.dart';
import 'package:reff_web/core/locator.dart';
import 'package:reff_web/core/models/Unions.dart';

final questionChangeNotifierProvider =
    ChangeNotifierProvider((ref) => QuestionChangeNotifier(ref));

final filterChangeNotifierProvider =
    ChangeNotifierProvider((ref) => FilterChangeNotifier());

class FilterChangeNotifier with ChangeNotifier {
  DateTime _dateTime = DateTime.now();
  DateTime get dateTime => this._dateTime;
  void setDateTime(DateTime dateTime) {
    this._dateTime = dateTime;
    notifyListeners();
  }
}

class QuestionChangeNotifier with ChangeNotifier {
  final _logger = Logger("QuestionProvider");
  final api = locator<BaseApi>();

  QuestionModel question;
  List<AnswerModel> answers;
  QuestionExistsState questionExistsState;
  final ProviderReference ref;

  QuestionChangeNotifier(this.ref);

  void initialize(
      {@required QuestionModel question, @required List<AnswerModel> answers}) {
    this.question = question;
    this.answers = answers;

    this.questionExistsState = (question?.id != null)
        ? QuestionExistsState.exsist()
        : QuestionExistsState.notExsist();
    _logger.info("initialized complete");
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
    this.question = this.question.copyWith.call(startDate: startDate);
    notifyListeners();
    _logger.info("updateStartDate | tarih değişti");
  }

  void updateEndDate(int endDate) {
    this.question = this.question.copyWith.call(endDate: endDate);
    notifyListeners();
    _logger.info("updateEndDate | tarih değişti");
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

  void updateActive(bool value) {
    this.question = this.question.copyWith.call(isActive: value);
    notifyListeners();
    _logger.info("updateActive | $value");
  }

  void updateCity(CityModel city) {
    this.question = this.question.copyWith.call(city: city);
    notifyListeners();
    _logger.info("updateCity | ${city.name}");
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

  Future<bool> saveToFirebase({@required bool validation}) async {
    if (this.answers.isNotEmpty && validation) {
      await this.questionExistsState.when(
        // yeni bir question kaydedilirken
        notExsist: () async {
          final ids = await api.answer.adds(this.answers);
          _logger.info('saveAll : ${ids.length} adet tercih kaydedildi');

          final question = this.question.copyWith.call(answers: ids);
          final questionID = await api.question.add(question);
          _logger.info('saveAll : yeni bir soru yaratıldı $questionID');
        },

        // varolan bir question güncellenirken
        exsist: () async {
          final newAnswers = <AnswerModel>[];

          for (final answer in this.answers) {
            if (answer.id != null) {
              await api.answer.update(answer.id, answer);
              await api.question.update(this.question.id, this.question);
            } else {
              newAnswers.add(answer);
              this.answers.remove(answer);
            }
            if (newAnswers.isNotEmpty) {
              final ids = await api.answer.adds(newAnswers);
              this.question.answers.addAll(ids);
            }

            await api.question.update(this.question.id, this.question);
          }
          _logger.info('updateAnswerToFirebase tercihler güncellendi');
        },
      );
      return true;
    } else
      _logger.warning("saveToFirebase validaston hatası");
    return false;
  }
}
