import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_web/core/providers/main_provider.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/view/widgets/edit_question_widgets.dart';

class EditQuestionScreen extends HookWidget {
  final _logger = Logger("EditQuestionScreen");

  final headerFormState = GlobalKey<FormState>();
  final contentFormState = GlobalKey<FormState>();
  final imageURLFormState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool _validation() =>
        headerFormState.currentState.validate() &&
        contentFormState.currentState.validate() &&
        imageURLFormState.currentState.validate();

    _logger.info("build");
    final questionProvider = useProvider(questionChangeNotifierProvider);
    final busyState = useProvider(busyStateProvider);

    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Align(
              alignment: Alignment.centerRight,
              child: busyState.isBusy
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : null),
          title: Text("edit")),
      floatingActionButton: Builder(
          builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                      heroTag: "delete",
                      backgroundColor: Colors.blueGrey,
                      child: Icon(Icons.delete),
                      onPressed: () {}),
                  Divider(color: Colors.transparent),
                  FloatingActionButton(
                      heroTag: "save",
                      child: Icon(Icons.save),
                      backgroundColor: Colors.blueGrey,
                      onPressed: () async {
                        if (questionProvider.answers.length < 2) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('En az 2 tercih eklemelisin')));
                        } else {
                          busyState.busy();
                          final result = await questionProvider.saveToFirebase(
                              validation: _validation());
                          if (result) {
                            Navigator.pop(context);
                          }
                          busyState.notBusy();
                        }
                      }),
                ],
              )),
      body: Container(
        padding: mediumPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CityPicker(
                  cities: CityModel.CITIES,
                  initialCity: CityModel.CITIES.singleWhere(
                      (city) => city == questionProvider.question.city),
                  onChanged: (CityModel city) =>
                      questionProvider.updateCity(city),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DateTimePicker(
                      label: "Start Date",
                      initialDateTime:
                          questionProvider.question.startDate ?? DateTime.now(),
                      initialTimeOfDate: TimeOfDay.fromDateTime(questionProvider
                              .question.startDate
                              .toDateTime()) ??
                          TimeOfDay.now(),
                      onChangedDateTime: (int value) =>
                          questionProvider.updateStartDate(value),
                      onChangedTimeOfDay: (TimeOfDay value) {
                        final date =
                            questionProvider.question.startDate.toDateTime();
                        final pureDate =
                            DateTime(date.year, date.month, date.day);
                        final addedTimeOfDay = pureDate.add(
                            Duration(minutes: value.minute, hours: value.hour));
                        questionProvider.updateStartDate(
                            addedTimeOfDay.millisecondsSinceEpoch);
                      },
                    ),
                    DateTimePicker(
                      label: "End Date",
                      initialDateTime:
                          questionProvider.question.endDate ?? DateTime.now(),
                      initialTimeOfDate: TimeOfDay.fromDateTime(
                              questionProvider.question.endDate.toDateTime()) ??
                          TimeOfDay.now(),
                      onChangedDateTime: (int value) =>
                          questionProvider.updateEndDate(value),
                      onChangedTimeOfDay: (TimeOfDay value) {
                        final date =
                            questionProvider.question.endDate.toDateTime();
                        final pureDate =
                            DateTime(date.year, date.month, date.day);
                        final addedTimeOfDay = pureDate.add(
                            Duration(minutes: value.minute, hours: value.hour));
                        questionProvider.updateEndDate(
                            addedTimeOfDay.millisecondsSinceEpoch);
                      },
                    ),
                    IsActiveQuestion(
                      initialValue: questionProvider.question.isActive,
                      onChanged: (value) =>
                          questionProvider.updateActive(value),
                    )
                  ],
                ),
              ],
            ),
            HeaderField(
              formState: this.headerFormState,
              initialValue: questionProvider.question.header ?? "",
              onChanged: (value) {
                if (value != null && value.isNotEmpty) {
                  questionProvider.updateHeader(value);
                }
              },
            ),
            ContentField(
                formState: this.contentFormState,
                initialValue: questionProvider.question.content ?? "",
                onChanged: (value) {
                  if (value != null && value.isNotEmpty) {
                    questionProvider.updateContent(value);
                  }
                }),
            ImageUrlField(
              formState: this.imageURLFormState,
              initialValue: questionProvider.question.imageUrl ?? "",
              onChanged: (value) {
                if (value != null && value.isNotEmpty) {
                  questionProvider.updateImageUrl(value);
                }
              },
            ),
            Expanded(child: AnswerList()),
          ],
        ),
      ),
    );
  }
}
