import 'package:flutter/material.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_shared/core/utils/constants.dart' as constants;
import 'package:reff_web/styles.dart';

class EditAnswerDialog extends StatefulWidget {
  final AnswerModel answer;

  const EditAnswerDialog({Key key, this.answer}) : super(key: key);

  @override
  _EditAnswerDialogState createState() => _EditAnswerDialogState();
}

class _EditAnswerDialogState extends State<EditAnswerDialog> {
  AnswerModel answer;
  TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    answer = widget.answer ?? AnswerModel(content: "");
    contentController = TextEditingController(text: answer.content);
  }

  @override
  void dispose() {
    contentController?.dispose();
    super.dispose();
  }

  // todo : validate
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Card(
        child: Padding(
          padding: mediumPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.maxFinite,
                margin: smallPadding,
                child: Card(
                  color: this.answer.color.color(),
                  child: Padding(
                    padding: smallPadding,
                    child: Text((this.answer.content == null ||
                            this.answer.content.isEmpty)
                        ? "Hayatta en hakiki mürşit ilimdir."
                        : this.answer.content),
                  ),
                ),
              ),
              TextFormField(
                  controller: contentController,
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      this.answer = this.answer.copyWith.call(content: value);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "İçerik",
                    icon: Padding(
                      padding: smallPadding,
                      child: Icon(Icons.text_fields),
                    ),
                  )),
              EditColorPicker(
                onChanged: (Color value) {
                  debugPrint(value.myColor().toString());
                  setState(() {
                    this.answer =
                        this.answer.copyWith.call(color: value.myColor());
                  });
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: RaisedButton.icon(
                    color: Colors.blueGrey,
                    onPressed: () {
                      Navigator.pop(context, answer);
                    },
                    icon: Icon(Icons.save),
                    label: Text('Kaydet')),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EditColorPicker extends StatelessWidget {
  final ValueChanged<Color> onChanged;

  const EditColorPicker({Key key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        height: 50,
        child: Scrollbar(
          child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: constants.myColors.map((color) {
                return IconButton(
                  color: color,
                  icon: Container(
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: color)),
                  onPressed: () {
                    onChanged(color);
                  },
                );
              }).toList()),
        ),
      ),
    );
  }
}
