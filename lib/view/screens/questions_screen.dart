import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_shared/core/services/result_api.dart';
import 'package:reff_web/core/providers/busy_state_notifier.dart';
import 'package:reff_web/core/providers/providers.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/core/utils/locator.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/view/screens/edit_question_screen.dart';
import 'package:reff_web/view/screens/result_screen/result_screen.dart';
import 'package:reff_web/view/widgets/custom_card.dart';

class QuestionsList extends HookWidget {
  const QuestionsList(this.questions);

  final List<QuestionModel> questions;

  @override
  Widget build(BuildContext context) {
    final questionState =
        useProvider(QuestionWithAnswersChangeNotifier.provider);

    final isBusy = useProvider(BusyState.provider.state);
    final isDarkMode =
        (MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Stack(
        children: [
          Center(
            child: Image.network(
              "images/logo.png",
              color: isDarkMode ? Colors.grey : Colors.white,
              height: 30,
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: isBusy
                  ? LinearProgressIndicator(backgroundColor: Colors.grey)
                  : SizedBox.shrink()),
        ],
      )),
      floatingActionButton: QuestionsScreenFloatingActionButton(),
      body: Padding(
        padding: mediumPadding,
        child: Column(
          children: [
            // FilterBar(),
            Container(
                width: double.maxFinite,
                child: CustomCard(
                  child: DataTable(
                      columns: ["Question", "Start Date", "End Date", ""]
                          .map((e) => DataColumn(
                                label: Text(e,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ))
                          .toList(),
                      rows: questions
                          .map(
                            (question) => DataRow(cells: [
                              DataCell(Text(
                                question.header,
                                style: TextStyle(
                                    fontWeight: question.isActive
                                        ? FontWeight.bold
                                        : FontWeight.w100),
                              )),
                              DataCell(Text(DateFormat("HH:mm - dd.MM.yyyy")
                                  .format(question.startDate.toDateTime()))),
                              DataCell(Text(DateFormat("HH:mm - dd.MM.yyyy")
                                  .format(question.endDate.toDateTime()))),
                              DataCell(Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.sort),
                                    onPressed: () async {
                                      await questionState
                                          .initializeWithAnswers(question);

                                      final result =
                                          await locator<BaseResultApi>()
                                              .getByQuestion(question.id);

                                      if (result != null) {
                                        ResultScreen.show(context);
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CreateNewResultDialog());
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () async {
                                      await questionState
                                          .initializeWithAnswers(question);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditQuestionScreen()),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await questionState
                                          .removeQuestionWithAnswers(
                                              question.id);
                                      context.refresh(
                                          Providers.questionsFutureProvider);
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              )),
                            ]),
                          )
                          .toList()),
                )),
          ],
        ),
      ),
    );
  }
}

class QuestionsScreenFloatingActionButton extends HookWidget {
  const QuestionsScreenFloatingActionButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questionState =
        useProvider(QuestionWithAnswersChangeNotifier.provider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
            heroTag: "add",
            child: Icon(Icons.add),
            onPressed: () {
              questionState.initialize(
                  answers: <AnswerModel>[],
                  question: QuestionModel(
                      city: CityModel.cities.first,
                      header: '',
                      imageUrl: '',
                      startDate: DateTime.now().millisecondsSinceEpoch,
                      endDate: DateTime.now()
                          .add(Duration(days: 2))
                          .millisecondsSinceEpoch));
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditQuestionScreen()),
              );
            }),
      ],
    );
  }
}
