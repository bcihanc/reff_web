import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_shared/core/services/api.dart';
import 'package:reff_shared/core/services/services.dart';
import 'package:reff_web/core/utils/locator.dart';
import 'package:reff_web/core/providers/providers.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/view/screens/edit_question_screen.dart';
import 'package:reff_web/view/screens/result_screen.dart';
import 'package:reff_web/view/widgets/custom_card.dart';
import 'package:reff_web/view/widgets/edit_question_widgets.dart';

final questionsFromApi =
    StreamProvider((_) => locator<BaseApi>().question.gets());

class QuestionsScreen extends HookWidget {
  static const route = "/questions";

  @override
  Widget build(BuildContext context) {
    final questionState = useProvider(QuestionChangeNotifier.provider);
    final questionsStream = useProvider(questionsFromApi);

    return Scaffold(
      appBar: AppBarWithBusyState(),
      floatingActionButton: QuestionsScreenFloatingActionButton(),
      body: Column(
        children: [
          FilterBar(),
          Container(
            padding: mediumPadding,
            width: double.maxFinite,
            child: questionsStream.when(
                data: (questions) => CustomCard(
                      child: DataTable(
                          columns: ["Question", "Start Date", "End Date", ""]
                              .map((e) => DataColumn(
                                    label: Text(e,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
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
                                      .format(
                                          question.startDate.toDateTime()))),
                                  DataCell(Text(DateFormat("HH:mm - dd.MM.yyyy")
                                      .format(question.endDate.toDateTime()))),
                                  DataCell(Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.sort),
                                        onPressed: () async {
                                          context
                                              .read(BusyState.provider)
                                              .busy();

                                          final answerApi =
                                              locator<BaseAnswerApi>();
                                          final answers = await answerApi
                                              .gets(question.answers);
                                          context
                                              .read(BusyState.provider)
                                              .notBusy();

                                          questionState.initialize(
                                              answers: answers,
                                              question: question);

                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ResultScreen()),
                                          );
                                          context
                                              .read(BusyState.provider)
                                              .notBusy();
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () async {
                                          context
                                              .read(BusyState.provider)
                                              .busy();

                                          final answerApi =
                                              locator<BaseAnswerApi>();
                                          final answers = await answerApi
                                              .gets(question.answers);
                                          context
                                              .read(BusyState.provider)
                                              .notBusy();

                                          questionState.initialize(
                                              answers: answers,
                                              question: question);

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
                                          context
                                              .read(BusyState.provider)
                                              .busy();

                                          await locator<BaseApi>()
                                              .question
                                              .remove(question.id);
                                          context
                                              .read(BusyState.provider)
                                              .notBusy();
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                    ],
                                  )),
                                ]),
                              )
                              .toList()),
                    ),
                loading: () => Center(child: LinearProgressIndicator()),
                error: (err, stack) => Text("$err")),
          ),
        ],
      ),
    );
  }
}

// ignore: prefer_mixin
class AppBarWithBusyState extends HookWidget with PreferredSizeWidget {
  const AppBarWithBusyState({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final busyState = useProvider(BusyState.provider.state);
    return AppBar(
        flexibleSpace: Align(
            alignment: Alignment.centerRight,
            child: busyState
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )
                : null),
        title: Text('Reff Panel'));
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}

class QuestionsScreenFloatingActionButton extends HookWidget {
  const QuestionsScreenFloatingActionButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questionState = useProvider(QuestionChangeNotifier.provider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
            heroTag: "add",
            child: Icon(Icons.add),
            backgroundColor: Colors.blueGrey,
            onPressed: () {
              questionState.initialize(
                  answers: <AnswerModel>[],
                  question: QuestionModel(
                      city: CityModel.cities.first,
                      header: "",
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
