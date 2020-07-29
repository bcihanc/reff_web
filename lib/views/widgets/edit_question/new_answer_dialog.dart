import 'package:flutter/material.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_web/styles.dart';

class AnswerEditDialog extends StatefulWidget {
  final AnswerModel answer;

  const AnswerEditDialog({Key key, this.answer}) : super(key: key);

  @override
  _AnswerEditDialogState createState() => _AnswerEditDialogState();
}

class _AnswerEditDialogState extends State<AnswerEditDialog> {
  AnswerModel _answer;
  TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _answer = widget.answer ?? AnswerModel(content: "");
    _contentController = TextEditingController(text: _answer.content);
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
                      this._answer = this._answer.copyWith.call(content: value);
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
                      Navigator.pop(context, _answer);
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
