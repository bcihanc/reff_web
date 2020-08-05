import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_web/core/models/Unions.dart';
import 'package:reff_web/core/providers/main_provider.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/view/widgets/edit_question/answer_list.dart';
import 'package:reff_web/view/widgets/edit_question/content_field.dart';
import 'package:reff_web/view/widgets/edit_question/header_field_and_date_picker.dart';
import 'package:reff_web/view/widgets/edit_question/image_url_field.dart';

class EditQuestionScreen extends HookWidget {
  final QuestionModel question;
  final List<AnswerModel> answers;
  EditQuestionScreen({Key key, this.question, this.answers}) : super(key: key);

  final _logger = Logger("EditQuestionScreen");

  @override
  Widget build(BuildContext context) {
    _logger.info("build");
    final provider = useProvider(questionStateProvider);
    final busyState = useProvider(busyStateProvider.state);

    useMemoized(() {
      provider.initialize(question: question, answers: answers);
    });

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
          title: Text("title", style: GoogleFonts.pacifico())),
      floatingActionButton: Column(
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
                busyStateProvider.read(context).busy();
                final result = await provider.saveToFirebase();
                busyStateProvider.read(context).notBusy();
                if (result) Navigator.pop(context);
              }),
        ],
      ),
      body: Container(
        padding: mediumPadding,
        child: Column(
          children: [
            HeaderFieldAndDateTimePicker(),
            ContentField(),
            ImageUrlField(),
            AnswerList(),
            IdShower()
          ],
        ),
      ),
    );
  }
}

class IdShower extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final questionProvider = useProvider(questionStateProvider);

    var idTextWidget = (questionProvider.question.id != null)
        ? QuestionExistsState.exsist()
        : QuestionExistsState.notExsist();

    return Container(
        child: idTextWidget.when(
      exsist: () => Text(questionProvider.question.id),
      notExsist: () => Text('id null'),
    ));
  }
}
