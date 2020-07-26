import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/views/shared/custom_card.dart';
import 'package:reff_web/views/widgets/edit_question/add_answer_button.dart';
import 'package:reff_web/views/widgets/edit_question/new_answer_dialog.dart';

class AnswerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestionProvider>(context);
    return Expanded(
      child: CustomCard(
        child: Padding(
          padding: mediumPadding,
          child: FutureBuilder(builder: (context, snapshot) {
            return ReorderableListView(
                onReorder: provider.onReorderAnswerListToModel,
                header: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Icon(Icons.radio_button_checked),
                              VerticalDivider(color: Colors.transparent),
                              Text('Tercih Listesi'),
                            ],
                          ),
                        ),
                        AddAnswerButton(),
                      ],
                    ),
                    Divider(height: 0)
                  ],
                ),
                children: provider.answers
                    .map((answer) => Card(
                          color: Colors.grey.withOpacity(0.3),
                          key: Key(answer.content),
                          child: Container(
                              height: 70,
                              width: double.infinity,
                              child: Padding(
                                padding: mediumPadding,
                                child: Row(
                                  children: [
                                    Icon(Icons.reorder),
                                    VerticalDivider(
                                      width: 20,
                                      color: Colors.transparent,
                                    ),
                                    Expanded(child: Text(answer.content)),
                                    IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () async {
                                          final editedAnswer = await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AnswerEditDialog(
                                                  answerModel: answer,
                                                );
                                              });
                                          provider.updateAnswer(
                                              answer, editedAnswer);
                                        }),
                                    IconButton(
                                        icon: Icon(Icons.delete_forever),
                                        onPressed: () {
                                          provider.removeAnswer(answer);
                                        }),
                                  ],
                                ),
                              )),
                        ))
                    .toList());
          }),
        ),
      ),
    );
  }
}
