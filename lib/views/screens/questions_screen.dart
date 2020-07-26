import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_web/core/locator.dart';
import 'package:reff_web/core/providers/main_provider.dart';
import 'package:reff_web/core/services/firebase_api.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/views/screens/edit_question_screen.dart';
import 'package:reff_web/views/shared/custom_card.dart';

class QuestionsScreen extends StatefulWidget {
  static const route = "/questions";

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final api = locator<FirebaseApi>();

  DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    var user = Provider.of<FirebaseUser>(context);

    return (user != null)
        ? Scaffold(
            appBar: AppBar(
                flexibleSpace: Align(
                    alignment: Alignment.centerRight,
                    child: mainProvider.isBusy
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
                        MaterialPageRoute(
                            builder: (context) => EditQuestionScreen()),
                      );
                    }),
              ],
            ),
            body: Container(
              padding: mediumPadding,
              alignment: Alignment.topCenter,
              child: StreamBuilder<List<QuestionModel>>(
                  stream: api.questionsSnaphotsByDay(_dateTime),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final questions = snapshot.data;
                      return CustomCard(
                        child: DataTable(
                            columns: [
                              DataColumn(
                                  label: Text('Document ID',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
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
                                        setState(() {
                                          _dateTime = _dateTime
                                              .subtract(Duration(days: 1));
                                        });
                                      }),
                                  Text('Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  IconButton(
                                      icon: Icon(Icons.chevron_right),
                                      onPressed: () {
                                        setState(() {
                                          _dateTime =
                                              _dateTime.add(Duration(days: 1));
                                        });
                                      }),
                                ],
                              )),
                              DataColumn(label: Text('')),
                            ],
                            rows: questions
                                .map(
                                  (questionModel) => DataRow(cells: [
                                    DataCell(
                                        Text(questionModel.id ?? "id null")),
                                    DataCell(Text(questionModel.header)),
                                    DataCell(Text(
                                        DateFormat("HH:mm - dd.MM.yyyy")
                                            .format(questionModel.timeStamp))),
                                    DataCell(Wrap(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            mainProvider.busy();
                                            final api = locator<FirebaseApi>();
                                            final answers =
                                                await api.getAnswersByIDs(
                                                    questionModel.answers);
                                            mainProvider.notBusy();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditQuestionScreen(
                                                        questionModel:
                                                            questionModel,
                                                        answers: answers,
                                                      )),
                                            );
                                          },
                                          icon: Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            mainProvider.busy();

                                            await locator<FirebaseApi>()
                                                .removeQuestion(
                                                    questionModel.id);
                                            mainProvider.notBusy();
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
                    return Center(child: CircularProgressIndicator());
                  }),
            ),
          )
        : Container(
            color: Colors.blueGrey,
            child: Center(
              child: RaisedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/");
                  },
                  icon: Icon(Icons.group),
                  label: Text('Login')),
            ),
          );
  }
}
