import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/view/shared/custom_card.dart';
import 'package:reff_web/view/widgets/edit_question/add_answer_button.dart';
import 'package:reff_web/view/widgets/edit_question/edit_answer_dialog.dart';

class AnswerList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final questionProvider = useProvider(questionStateProvider);

    return Expanded(
      child: CustomCard(
        child: Padding(
          padding: mediumPadding,
          child: FutureBuilder(builder: (context, snapshot) {
            return ReorderableListView(
                onReorder: questionProvider.onReorderAnswerListToModel,
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
                children: questionProvider.answers
                    .map((answer) => Card(
                          color: answer.color.color().withOpacity(0.5),
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
                                                return EditAnswerDialog(
                                                  answer: answer,
                                                );
                                              });
                                          questionProvider.updateAnswer(
                                              answer, editedAnswer);
                                        }),
                                    IconButton(
                                        icon: Icon(Icons.delete_forever),
                                        onPressed: () {
                                          questionProvider.removeAnswer(answer);
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
