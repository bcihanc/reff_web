import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/view/widgets/edit_question/edit_answer_dialog.dart';

class AddAnswerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestionProvider>(context);

    return Container(
      alignment: Alignment.centerRight,
      padding: xsmallPadding,
      child: RaisedButton.icon(
          color: Colors.blueGrey,
          onPressed: () async {
            final answer = await showDialog<AnswerModel>(
                context: context, builder: (context) => EditAnswerDialog());
            if (answer != null) {
              provider.addAnswer(answer);
            }
          },
          icon: Icon(Icons.add),
          label: Text('Ekle')),
    );
  }
}
