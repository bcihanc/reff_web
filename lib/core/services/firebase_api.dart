import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_shared/core/utils/constants.dart' as constants;

class FirebaseApi {
  final _logger = Logger("FirebaseApi");

  Firestore _firestore;

  FirebaseApi() {
    _firestore = Firestore.instance;
  }

  Stream<List<QuestionModel>> questionsSnaphotsByDay(DateTime dateTime) {
    final streamTransformer =
        StreamTransformer<QuerySnapshot, List<QuestionModel>>.fromHandlers(
            handleData: (snapshots, sink) {
      sink.add(snapshots.documents.map((e) {
        final fromSnapshot = QuestionModel.fromJson(e.data);
        return fromSnapshot.copyWith.call(id: e.documentID);
      }).toList());
    });

    final today = dateTime.toIso8601String().substring(0, 10);
    final nextDay =
        dateTime.add(Duration(days: 1)).toIso8601String().substring(0, 10);

    return _firestore
        .collection(constants.collectionNameQuestions)
        .where("timeStamp", isGreaterThan: today, isLessThan: nextDay)
        .snapshots()
        .transform(streamTransformer);
  }

  Future<void> removeAnswer(String id) async {
    await _firestore
        .collection(constants.collectionNameAnswers)
        .document(id)
        .delete()
        .catchError((e) => throw Exception(e));

    _logger.finer("removeAnswer");
  }

  Future<void> removeQuestion(String id) async {
    await _removeAllAnswersByQuestionID(id);

    await _firestore
        .collection(constants.collectionNameQuestions)
        .document(id)
        .delete()
        .catchError((e) => throw Exception(e));

    _logger.finer("removeQuestion");
  }

  Future<void> _removeAllAnswersByQuestionID(String questionID) async {
    final questionFromFirebase = await this.getQuestion(questionID);

    for (final answer in questionFromFirebase.answers) {
      await this.removeAnswer(answer);
    }

    _logger
        .finer("removed ${questionFromFirebase.answers.length} from firebase");
  }

  Future<bool> deleteQuestion(String id) async {
    assert(id != null);
    await _firestore
        .collection(constants.collectionNameQuestions)
        .document(id)
        .delete()
        .catchError((e) => throw Exception(e));

    final document = await _firestore
        .collection(constants.collectionNameQuestions)
        .document(id)
        .get()
        .catchError((e) => throw Exception(e));

    return document == null;
  }

  Future<void> updateQuestion(String id, QuestionModel newQuestionModel) async {
    await _firestore
        .collection(constants.collectionNameQuestions)
        .document(id)
        .updateData(newQuestionModel.toJson());
    _logger.info("updateQuestion");
  }

  Future<void> updateAnswer(String id, AnswerModel newAnswerModel) async {
    await _firestore
        .collection(constants.collectionNameAnswers)
        .document(id)
        .updateData(newAnswerModel.toJson());
    _logger.info("updateAnswer");
  }

  /// return created documentID
  Future<QuestionModel> getQuestion(String id) async {
    assert(id != null);

    final document = await _firestore
        .collection(constants.collectionNameQuestions)
        .document(id)
        .get()
        .catchError((e) => throw Exception(e));

    return QuestionModel.fromJson(document.data);
  }

  /// return documentID
  Future<String> addQuestion(QuestionModel questionModel) async {
    assert(questionModel != null);

    final document = await _firestore
        .collection(constants.collectionNameQuestions)
        .add(questionModel.toJson())
        .catchError((e) => throw Exception(e));

    return document != null ? document.documentID : null;
  }

  Future<List<AnswerModel>> getAnswersByIDs(List<String> ids) async {
    assert(ids != null);
    var answers = <AnswerModel>[];
    for (final id in ids) {
      final answer = await getAnswerByID(id);
      answers.add(answer);
    }
    return answers;
  }

  Future<AnswerModel> getAnswerByID(String id) async {
    assert(id != null);
    final snapshot = await _firestore
        .collection(constants.collectionNameAnswers)
        .document(id)
        .get();

    if (!snapshot.exists) {
      throw Exception("selam");
    }

    final answer = AnswerModel.fromJson(snapshot.data);
    return answer.copyWith.call(id: snapshot.documentID);
  }

  /// return created documentIDs
  Future<List<String>> addAnswersToFirebase(List<AnswerModel> answers) async {
    assert(answers != null && answers.isNotEmpty);

    var answersIDs = <String>[];

    for (final answer in answers) {
      final id = await _firestore
          .collection(constants.collectionNameAnswers)
          .add(answer.toJson())
          .catchError((e) => print(e.toString()));

      if (id != null) {
        answersIDs.add(id.documentID);
      }
    }
    return answersIDs;
  }
}
