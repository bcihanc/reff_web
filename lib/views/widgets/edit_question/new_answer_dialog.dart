import 'package:flutter/material.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_web/styles.dart';

class AnswerEditDialog extends StatefulWidget {
  final AnswerModel answerModel;

  const AnswerEditDialog({Key key, this.answerModel}) : super(key: key);

  @override
  _AnswerEditDialogState createState() => _AnswerEditDialogState();
}

class _AnswerEditDialogState extends State<AnswerEditDialog> {
  AnswerModel _answerModel;
  TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _answerModel = widget.answerModel ?? AnswerModel(content: "");
    _contentController = TextEditingController(text: _answerModel.content);
  }

  @override
  void dispose() {
    _contentController?.dispose();
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
              TextFormField(
                  controller: _contentController,
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      this._answerModel =
                          this._answerModel.copyWith.call(content: value);
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "İçerik",
                    icon: Padding(
                      padding: smallPadding,
                      child: Icon(Icons.text_fields),
                    ),
                  )),
              Align(
                alignment: Alignment.centerRight,
                child: RaisedButton.icon(
                    color: Colors.blueGrey,
                    onPressed: () {
                      Navigator.pop(context, _answerModel);
                    },
                    icon: Icon(Icons.add),
                    label: Text('ekle')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
