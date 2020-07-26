import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_web/core/locator.dart';
import 'package:reff_web/core/models/Unions.dart';
import 'package:reff_web/core/services/firebase_api.dart';

class QuestionProvider with ChangeNotifier {
  final _logger = Logger("QuestionProvider");
  final _firestore = locator<FirebaseApi>();

  QuestionExistsState questionExistsState;

  final headerFormKey = GlobalKey<FormState>();
  final contentFormKey = GlobalKey<FormState>();
  final imageUrlFormKey = GlobalKey<FormState>();

  QuestionModel questionModel;
  List<AnswerModel> answers;

  bool isBusy;

  static final questionModelForNew =
      QuestionModel(header: "", timeStamp: DateTime.now());

  static final answersForNew = <AnswerModel>[];

  QuestionProvider({QuestionModel questionModel, List<AnswerModel> answers}) {
    this.questionModel = questionModel ?? questionModelForNew;
    this.answers = answers ?? answersForNew;

    this.questionExistsState = (questionModel != null && answers != null)
        ? QuestionExistsState.exsist()
        : QuestionExistsState.notExsist();

    this.isBusy = false;
  }

  busy() {
    isBusy = true;
    notifyListeners();
  }

  notBusy() {
    isBusy = false;
    notifyListeners();
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
    this.questionModel = this.questionModel.copyWith.call(timeStamp: dateTime);
    notifyListeners();
    _logger.info("changeDate | tarih değişti");
  }

  void updateImageUrl(String imageUrl) {
    this.questionModel = this.questionModel.copyWith.call(imageUrl: imageUrl);
    notifyListeners(); // resim için build çalışması şart
    _logger.info("changeImageUrl | imageUrl değişti");
  }

  void updateHeader(String header) {
    this.questionModel = this.questionModel.copyWith.call(header: header);
    _logger.info("changeHeader | header değişti");
  }

  void updateContent(String content) {
    this.questionModel = this.questionModel.copyWith.call(content: content);
    _logger.info("changeContent | content değişti");
  }

  void addAnswer(AnswerModel answerModel) {
    this.answers.add(answerModel);
    notifyListeners();
    _logger.info("addAnswer | yeni tercih eklendi");
  }

  void removeAnswer(AnswerModel answerModel) {
    if (this.answers.contains(answerModel)) {
      final result = this.answers.remove(answerModel);

      if (answerModel.id != null) {
        final willRemoveAnswerID = this
            .questionModel
            .answers
            .firstWhere((element) => element == answerModel.id);

        this.questionModel.answers.remove(willRemoveAnswerID);
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

  Future<void> saveToFirebase() async {
    if (this.answers.isNotEmpty &&
        this.headerFormKey.currentState.validate() &&
        this.contentFormKey.currentState.validate() &&
        this.imageUrlFormKey.currentState.validate()) {
      await this.questionExistsState.when(
        // yeni bir question kaydedilirken
        notExsist: () async {
          final ids = await _firestore.addAnswersToFirebase(answers);
          _logger.info('saveAll : ${ids.length} adet tercih kaydedildi');

          final questionModel = this.questionModel.copyWith.call(answers: ids);
          final questionID = await _firestore.addQuestion(questionModel);
          _logger.info('saveAll : yeni bir soru yaratıldı $questionID');
        },

        // varolan bir question güncellenirken
        exsist: () async {
          var newAnswers = <AnswerModel>[];

          for (final answer in this.answers) {
            if (answer.id != null) {
              await _firestore.updateAnswer(answer.id, answer);
              await _firestore.updateQuestion(
                  this.questionModel.id, this.questionModel);
            } else {
              newAnswers.add(answer);
              this.answers.remove(answer);
            }
            if (newAnswers.isNotEmpty) {
              final ids = await _firestore.addAnswersToFirebase(newAnswers);
              this.questionModel.answers.addAll(ids);
            }

            await _firestore.updateQuestion(
                this.questionModel.id, this.questionModel);
          }
          _logger.info('updateAnswerToFirebase tercihler güncellendi');
        },
      );
    }
  }
}
