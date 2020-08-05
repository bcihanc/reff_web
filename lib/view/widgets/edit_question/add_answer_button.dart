import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/view/widgets/edit_question/edit_answer_dialog.dart';

class AddAnswerButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final questionProvider = useProvider(questionStateProvider);

    return Container(
      alignment: Alignment.centerRight,
      padding: xsmallPadding,
      child: RaisedButton.icon(
          color: Colors.blueGrey,
          onPressed: () async {
            final answer = await showDialog<AnswerModel>(
                context: context, builder: (context) => EditAnswerDialog());
            if (answer != null) {
              questionProvider.addAnswer(answer);
            }
          },
          icon: Icon(Icons.add),
          label: Text('Ekle')),
    );
  }
}
