//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_test/flutter_test.dart';
//import 'package:reff_shared/core/models/models.dart';
//import 'package:reff_web/core/locator.dart';
//import 'package:reff_web/core/services/firestore_api.dart';
//
//main() async {
//  TestWidgetsFlutterBinding.ensureInitialized();
//  await setupLocator();
//
//  FirebaseApi api;
//  QuestionModel question;
//
//  group("question models", () {
//    setUpAll(() async {
//      question = QuestionModel(
//          header: "header",
//          content: "content",
//          answers: ["id1", "id2"],
//          imageUrl: "google.com",
//          timeStamp: DateTime.now());
//    });
//
//    test(" get metodu", () async {
//      final addedQuestionID = await api.addQuestion(question);
//      final modelFirebase = await api.getQuestion(addedQuestionID);
//      expect(question, modelFirebase);
//      final deleteResult = await api.deleteQuestion(addedQuestionID);
//      expect(deleteResult, true);
//    });
//  });
//}
