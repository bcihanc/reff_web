import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:future_button/future_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_web/core/models/Unions.dart';
import 'package:reff_web/core/providers/busy_state_notifier.dart';
import 'package:reff_web/core/providers/providers.dart';
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
    final questionProvider =
        useProvider(QuestionWithAnswersChangeNotifier.provider);
    final busyState = useProvider(BusyState.provider.state);

    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Align(
              alignment: Alignment.bottomCenter,
              child: busyState
                  ? LinearProgressIndicator(backgroundColor: Colors.grey)
                  : SizedBox.shrink()),
          title: (questionProvider.questionExistsState ==
                  QuestionExistsState.exsist())
              ? Text("Edit")
              : Text("Create")),
      floatingActionButton: Builder(
          builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                      heroTag: "delete",
                      child: Icon(Icons.delete),
                      onPressed: () {}),
                  Divider(color: Colors.transparent),
                  FloatingActionButton(
                      heroTag: "save",
                      child: Icon(Icons.save),
                      onPressed: !busyState
                          ? () async {
                              if (questionProvider.answers.length < 2) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content:
                                        Text('En az 2 tercih eklemelisin')));
                              } else {
                                context.read(BusyState.provider).busy();

                                final result = await questionProvider
                                    .saveToFirebase(validation: _validation());

                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Kaydedildi'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 1),
                                ));
                                await Future.delayed(
                                    Duration(seconds: 1, milliseconds: 100));
                                context
                                    .refresh(Providers.questionsFutureProvider);
                                context.read(BusyState.provider).notBusy();
                                if (result && Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              }
                            }
                          : null),
                ],
              )),
      body: Container(
        padding: mediumPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Wrap(
              direction: Axis.horizontal,
              children: [
                CityPicker(
                    cities: CityModel.cities,
                    initialCity: CityModel.cities.singleWhere(
                        (city) => city == questionProvider.question.city),
                    onChanged: questionProvider.updateCity),
                DateTimePicker(
                  label: "Start Date",
                  initialDateTime:
                      questionProvider.question.startDate ?? DateTime.now(),
                  initialTimeOfDate: TimeOfDay.fromDateTime(
                          questionProvider.question.startDate.toDateTime()) ??
                      TimeOfDay.now(),
                  onChangedDateTime: questionProvider.updateStartDate,
                  onChangedTimeOfDay: (timeOfDay) {
                    final date =
                        questionProvider.question.startDate.toDateTime();
                    final pureDate = DateTime(date.year, date.month, date.day);
                    final addedTimeOfDay = pureDate.add(Duration(
                        minutes: timeOfDay.minute, hours: timeOfDay.hour));
                    questionProvider
                        .updateStartDate(addedTimeOfDay.millisecondsSinceEpoch);
                  },
                ),
                DateTimePicker(
                  label: "End Date",
                  initialDateTime:
                      questionProvider.question.endDate ?? DateTime.now(),
                  initialTimeOfDate: TimeOfDay.fromDateTime(
                          questionProvider.question.endDate.toDateTime()) ??
                      TimeOfDay.now(),
                  onChangedDateTime: questionProvider.updateEndDate,
                  onChangedTimeOfDay: (timeOfDay) {
                    final date = questionProvider.question.endDate.toDateTime();
                    final pureDate = DateTime(date.year, date.month, date.day);
                    final addedTimeOfDay = pureDate.add(Duration(
                        minutes: timeOfDay.minute, hours: timeOfDay.hour));
                    questionProvider
                        .updateEndDate(addedTimeOfDay.millisecondsSinceEpoch);
                  },
                ),
                IsActiveQuestion(
                  initialValue: questionProvider.question.isActive,
                  onChanged: (value) =>
                      questionProvider.updateActive(activate: value),
                )
              ],
            ),
            HeaderField(
              formState: headerFormState,
              initialValue: questionProvider.question.header ?? "",
              onChanged: (value) {
                if (value != null && value.isNotEmpty) {
                  questionProvider.updateHeader(value);
                }
              },
            ),
            ContentField(
                formState: contentFormState,
                initialValue: questionProvider.question.content ?? "",
                onChanged: (value) {
                  if (value != null && value.isNotEmpty) {
                    questionProvider.updateContent(value);
                  }
                }),
            ImageUrlField(
              formState: imageURLFormState,
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
