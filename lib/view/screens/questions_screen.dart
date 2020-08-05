import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_shared/core/services/api.dart';
import 'package:reff_web/core/locator.dart';
import 'package:reff_web/core/providers/main_provider.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/view/screens/edit_question_screen.dart';
import 'package:reff_web/view/shared/custom_card.dart';

class QuestionsScreen extends HookWidget {
  static const route = "/questions";
  final api = locator<BaseApi>();

  @override
  Widget build(BuildContext context) {
    final _dateTime = useState(DateTime.now());
    final busyState = useProvider(busyStateProvider.state);

    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Align(
              alignment: Alignment.centerRight,
              child: busyState
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : null),
          title: Text('Reff Panel', style: GoogleFonts.pacifico())),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
              heroTag: "date",
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.date_range),
              onPressed: () {}),
          Divider(color: Colors.transparent),
          FloatingActionButton(
              heroTag: "add",
              child: Icon(Icons.add),
              backgroundColor: Colors.blueGrey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditQuestionScreen()),
                );
              }),
        ],
      ),
      body: Container(
        padding: mediumPadding,
        alignment: Alignment.topCenter,
        child: StreamBuilder<List<QuestionModel>>(
            stream: api.question.getsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final questions = snapshot.data;
                return CustomCard(
                  child: DataTable(
                      columns: [
                        DataColumn(
                            label: Text('Document ID',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text(
                          'Header',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.chevron_left),
                                onPressed: () {
                                  _dateTime.value = _dateTime.value
                                      .subtract(Duration(days: 1));
                                }),
                            Text(
                                DateFormat("dd.MM.yyyy")
                                    .format(_dateTime.value),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {
                                  _dateTime.value =
                                      _dateTime.value.add(Duration(days: 1));
                                }),
                          ],
                        )),
                        DataColumn(label: Text('')),
                      ],
                      rows: questions
                          .map(
                            (question) => DataRow(cells: [
                              DataCell(Text(question.id ?? "id null")),
                              DataCell(Text(question.header)),
                              DataCell(Text(DateFormat("HH:mm - dd.MM.yyyy")
                                  .format(question.timeStamp))),
                              DataCell(Wrap(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      busyStateProvider.read(context).busy();
                                      final api = locator<BaseApi>();
                                      final answers = await api.answer
                                          .gets(question.answers);
                                      busyStateProvider.read(context).notBusy();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditQuestionScreen(
                                                  question: question,
                                                  answers: answers,
                                                )),
                                      );
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      busyStateProvider.read(context).busy();

                                      await locator<BaseApi>()
                                          .question
                                          .remove(question.id);
                                      busyStateProvider.read(context).notBusy();
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              )),
                            ]),
                          )
                          .toList()),
                );
              }
              return Center(child: Text('no question data'));
            }),
      ),
    );
  }
}
