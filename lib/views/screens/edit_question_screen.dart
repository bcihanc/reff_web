import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_web/core/locator.dart';
import 'package:reff_web/core/models/Unions.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/views/widgets/edit_question/answer_list.dart';
import 'package:reff_web/views/widgets/edit_question/content_field.dart';
import 'package:reff_web/views/widgets/edit_question/header_field_and_date_picker.dart';
import 'package:reff_web/views/widgets/edit_question/image_url_field.dart';

class EditQuestionScreen extends StatelessWidget {
  final QuestionModel question;
  final List<AnswerModel> answers;
  const EditQuestionScreen({Key key, this.question, this.answers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<QuestionProvider>(
          param1: this.question, param2: this.answers),
      child: Builder(
        builder: (context) {
          final provider = Provider.of<QuestionProvider>(context);
          final title = provider.questionExistsState
              .when(notExsist: () => "yeni", exsist: () => "düzenle");

          return Scaffold(
            appBar: AppBar(
                flexibleSpace: Align(
                    alignment: Alignment.centerRight,
                    child: provider.isBusy
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          )
                        : null),
                title: Text(title, style: GoogleFonts.pacifico())),
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
                      provider.busy();
                      await provider.saveToFirebase();
                      provider.notBusy();
                      Navigator.pop(context);
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
        },
      ),
    );
  }
}

class IdShower extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestionProvider>(context);
    var idTextWidget = (provider.question.id != null)
        ? QuestionExistsState.exsist()
        : QuestionExistsState.notExsist();

    return Container(
        child: idTextWidget.when(
      exsist: () => Text(provider.question.id),
      notExsist: () => Text('id null'),
    ));
  }
}
