import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/view/shared/custom_card.dart';

class HeaderFieldAndDateTimePicker extends StatefulWidget {
  @override
  _HeaderFieldAndDateTimePickerState createState() =>
      _HeaderFieldAndDateTimePickerState();
}

class _HeaderFieldAndDateTimePickerState
    extends State<HeaderFieldAndDateTimePicker> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String _dateTimeFormat(DateTime dateTime) {
    final format = DateFormat("dd.MM.yyyy");
    return format.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestionProvider>(context);

    return Row(
      children: [
        Expanded(
          child: CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: provider.headerFormKey,
                child: TextFormField(
                    controller: _controller..text = provider.question.header,
                    onChanged: (value) {
                      if (value != null && value.isNotEmpty) {
                        provider.updateHeader(value);
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Başlık boş olamaz";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Başlık",
                      icon: Padding(
                        padding: smallPadding,
                        child: Icon(Icons.text_fields),
                      ),
                    )),
              ),
            ),
          ),
        ),
        CustomCard(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: RaisedButton.icon(
                color: Colors.blueGrey,
                onPressed: () async {
                  final dateTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      ) ??
                      DateTime.now();
                  provider.updateDate(dateTime);
                },
                icon: Icon(Icons.date_range),
                label: Text(_dateTimeFormat(provider.question.timeStamp))),
          ),
        )
      ],
    );
  }
}
