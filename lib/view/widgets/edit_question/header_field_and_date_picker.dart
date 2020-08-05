import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reff_web/core/providers/main_provider.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/view/shared/custom_card.dart';

class HeaderFieldAndDateTimePicker extends HookWidget {
  String _dateTimeFormat(DateTime dateTime) {
    final format = DateFormat("dd.MM.yyyy");
    return format.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final _controller = useTextEditingController();
    final questionProvider = useProvider(questionStateProvider);
    final key = useProvider(headerFormKey);

    return Row(
      children: [
        Expanded(
          child: CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: key,
                child: TextFormField(
                    controller: _controller
                      ..text = questionProvider.question.header ?? "empty",
                    onChanged: (value) {
                      if (value != null && value.isNotEmpty) {
                        questionProvider.updateHeader(value);
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty || value == "") {
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
                  questionProvider.updateDate(dateTime);
                },
                icon: Icon(Icons.date_range),
                label:
                    Text(_dateTimeFormat(questionProvider.question.timeStamp))),
          ),
        )
      ],
    );
  }
}
