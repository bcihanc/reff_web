import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reff_shared/core/services/services.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/core/utils/locator.dart';
import 'package:reff_web/view/screens/result_screen/question_info.dart';
import 'package:reff_web/view/screens/result_screen/result_info.dart';

class ResultScreen extends HookWidget {
  static Future<void> show(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => ResultScreen()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Sonuçlar')),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.delete),
            onPressed: () async {
              final questionID = context
                  .read(QuestionWithAnswersChangeNotifier.provider)
                  .question
                  .id;
              final result =
                  await locator<BaseResultApi>().getByQuestion(questionID);
              if (result != null) {
                final deleteResult =
                    await locator<BaseResultApi>().remove(result.id);
                if (Navigator.canPop(context) && deleteResult) {
                  Navigator.pop(context);
                }
              } else {
                debugPrint('resultID is null');
              }
            }),
        body: Column(
          children: [
            QuestionInfoAsyncBuilder(),
            const SizedBox(height: 40),
            Expanded(child: ResultInfoAsyncBuilder())
          ],
        ));
  }
}

class CreateNewResultDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final questionID =
        context.read(QuestionWithAnswersChangeNotifier.provider).question.id;

    return AlertDialog(
      title: Text('Hesaplanmış bir sonuç bulunamadı'),
      actions: [
        Center(
          child: RaisedButton.icon(
              label: Text('Yeni bir tane yarat'),
              icon: Icon(Icons.create),
              onPressed: () async {
                await locator<BaseResultApi>().addFromQuestion(questionID);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              }),
        )
      ],
    );
  }
}
