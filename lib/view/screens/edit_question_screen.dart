import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:reff_shared/core/models/CityModel.dart';
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
                          busyStateProvider.read(context).busy();
                          final result = await questionProvider.saveToFirebase(
                              validation: _validation());
                          busyStateProvider.read(context).notBusy();
                          if (result) {
                            Navigator.pop(context);
                          }
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
                CountryPicker(
                  countries: CountryModel.COUNTRIES,
                  initialCountry: CountryModel.COUNTRIES.singleWhere(
                      (country) =>
                          country.code ==
                          questionProvider.question.countryCode),
                  onChanged: (CountryModel country) =>
                      questionProvider.updateCountry(country),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DatePicker(),
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
