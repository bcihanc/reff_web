import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reff_shared/core/models/CityModel.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_shared/core/utils/constants.dart';
import 'package:reff_web/core/models/Unions.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/view/widgets/custom_card.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddAnswerButton extends HookWidget {
  AddAnswerButton({@required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final questionProvider = useProvider(questionChangeNotifierProvider);

    return Container(
      alignment: Alignment.centerRight,
      padding: xsmallPadding,
      child: RaisedButton.icon(
          color: Colors.blueGrey,
          onPressed: onPressed,
          icon: Icon(Icons.add),
          label: Text('Ekle')),
    );
  }
}

class AnswerList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final questionProvider = useProvider(questionChangeNotifierProvider);

    return CustomCard(
      child: Padding(
        padding: mediumPadding,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Icon(Icons.radio_button_checked),
                      VerticalDivider(color: Colors.transparent),
                      Text('Tercih Listesi'),
                    ],
                  ),
                ),
                AddAnswerButton(onPressed: () async {
                  final answer = await showDialog<AnswerModel>(
                      context: context,
                      builder: (context) => EditAnswerDialog());
                  if (answer != null) {
                    questionProvider.addAnswer(answer);
                  }
                }),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: questionProvider.answers.length,
                  itemBuilder: (context, index) {
                    final answer = questionProvider.answers[index];

                    return CustomCard(
                      color: answer.color.toColor().withOpacity(0.5),
                      child: ListTile(
                        dense: true,
                        title: Text(answer.content),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  final editedAnswer =
                                      await showDialog<AnswerModel>(
                                          context: context,
                                          builder: (context) {
                                            return EditAnswerDialog(
                                              answer: answer,
                                            );
                                          });
                                  if (editedAnswer != null) {
                                    questionProvider.updateAnswer(
                                        answer, editedAnswer);
                                  }
                                }),
                            IconButton(
                                icon: Icon(Icons.delete_forever),
                                onPressed: () {
                                  questionProvider.removeAnswer(answer);
                                }),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class ContentField extends HookWidget {
  ContentField(
      {@required this.initialValue,
      @required this.onChanged,
      @required this.formState});
  final ValueChanged onChanged;
  final String initialValue;
  final GlobalKey<FormState> formState;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: this.initialValue);

    return CustomCard(
        child: Padding(
      padding: smallPadding,
      child: Form(
        key: formState,
        child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "İçerik",
              icon: Padding(
                padding: smallPadding,
                child: Icon(Icons.text_fields),
              ),
            )),
      ),
    ));
  }
}

class EditAnswerDialog extends StatefulHookWidget {
  EditAnswerDialog({this.answer});
  final AnswerModel answer;

  @override
  _SomeWidgetState createState() => _SomeWidgetState();
}

class _SomeWidgetState extends State<EditAnswerDialog> {
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: widget.answer?.content);
    final answerState = useState(widget.answer ?? AnswerModel(content: ""));

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
                  color: answerState.value.color.toColor(),
                  child: Padding(
                    padding: smallPadding,
                    child: Text((answerState.value.content == null ||
                            answerState.value.content.isEmpty)
                        ? "Hayatta en hakiki mürşit ilimdir."
                        : answerState.value.content),
                  ),
                ),
              ),
              TextFormField(
                  controller: controller,
                  autofocus: true,
                  onChanged: (value) {
                    if (value != null) {
                      answerState.value =
                          answerState.value.copyWith.call(content: value);
                    }
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
                  if (value != null) {
                    answerState.value =
                        answerState.value.copyWith.call(color: value.myColor());
                  }
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: RaisedButton.icon(
                    color: Colors.blueGrey,
                    onPressed: () {
                      Navigator.pop(context, answerState.value);
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

class EditColorPicker extends HookWidget {
  final ValueChanged<Color> onChanged;
  EditColorPicker({this.onChanged});

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
              children: myColors.map((color) {
                return IconButton(
                  color: color,
                  icon: Container(
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: color)),
                  onPressed: () => onChanged(color),
                );
              }).toList()),
        ),
      ),
    );
  }
}

//class TimePicker extends HookWidget {
//  const TimePicker({Key key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    final questionProvider = useProvider(questionChangeNotifierProvider);
//
//    return CustomCard(
//      child: Padding(
//        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//        child: RaisedButton.icon(
//            color: Colors.blueGrey,
//            onPressed: () async {
//              final time = await showTimePicker(
//                      initialEntryMode: TimePickerEntryMode.input,
//                      context: context,
//                      initialTime: TimeOfDay.fromDateTime(
//                              questionProvider.question.startDate) ??
//                          TimeOfDay.now()) ??
//                  TimeOfDay.now();
//
//              questionProvider.updateTime(time);
//            },
//            icon: Icon(Icons.timelapse),
//            label: Text("Time Picker")),
//      ),
//    );
//  }
//}

class DateTimePicker extends HookWidget {
  final String label;

  final DateTime initialDateTime;
  final TimeOfDay initialTimeOfDate;

  final ValueChanged<DateTime> onChangedDateTime;
  final ValueChanged<TimeOfDay> onChangedTimeOfDay;

  DateTimePicker(
      {@required this.initialDateTime,
      @required this.initialTimeOfDate,
      @required this.onChangedDateTime,
      @required this.onChangedTimeOfDay,
      @required this.label});

  String _dateTimeFormat(DateTime dateTime) {
    final format = DateFormat("dd.MM.yyyy");
    return format.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final questionProvider = useProvider(questionChangeNotifierProvider);

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: RaisedButton.icon(
            color: Colors.blueGrey,
            onPressed: () async {
              final dateTime = await showDatePicker(
                      context: context,
                      initialDate: this.initialDateTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365))) ??
                  DateTime.now();

              this.onChangedDateTime(dateTime);

              final timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: this.initialTimeOfDate,
                  ) ??
                  TimeOfDay.now();

              this.onChangedTimeOfDay(timeOfDay);
            },
            icon: Icon(Icons.date_range),
            label: Text(this.label)),
      ),
    );
  }
}

class HeaderField extends HookWidget {
  HeaderField(
      {@required this.initialValue,
      @required this.onChanged,
      @required this.formState});
  final ValueChanged onChanged;
  final String initialValue;
  final GlobalKey<FormState> formState;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: this.initialValue);

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formState,
          child: TextFormField(
              controller: controller,
              onChanged: this.onChanged,
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
    );
  }
}

class ImageUrlField extends HookWidget {
  ImageUrlField(
      {@required this.initialValue,
      @required this.onChanged,
      @required this.formState});
  final ValueChanged onChanged;
  final String initialValue;
  final GlobalKey<FormState> formState;

  @override
  Widget build(BuildContext context) {
    final _controller = useTextEditingController();
    final questionProvider = useProvider(questionChangeNotifierProvider);

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Form(
                key: formState,
                child: TextFormField(
                    controller: _controller,
                    onChanged: (value) {
                      if (value != null && value.isNotEmpty) {
                        questionProvider.updateImageUrl(value);
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Image Url",
                      icon: Padding(
                        padding: smallPadding,
                        child: Icon(Icons.image),
                      ),
                    )),
              ),
            ),
            VerticalDivider(),
            (questionProvider.question.imageUrl == null ||
                    questionProvider.question.imageUrl.isEmpty)
                ? CustomCard(
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.blueGrey,
                      child: Icon(Icons.image),
                    ),
                  )
                : Card(
                    child: Image.network(
                      questionProvider.question.imageUrl ??
                          "https://via.placeholder.com/100",
                      height: 100,
                      width: 100,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class IdShower extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final questionProvider = useProvider(questionChangeNotifierProvider);

    var idTextWidget = (questionProvider.question.id != null)
        ? QuestionExistsState.exsist()
        : QuestionExistsState.notExsist();

    return CustomCard(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        alignment: Alignment.center,
        height: 46,
        child: idTextWidget.when(
          exsist: () => Text(questionProvider.question.id),
          notExsist: () => SizedBox.shrink(),
        ),
      ),
    ));
  }
}

class IsActiveQuestion extends HookWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  IsActiveQuestion({this.initialValue, this.onChanged});

  Widget build(BuildContext context) {
    final valueState = useState(initialValue);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('Yayın'),
            Switch(
                value: valueState.value,
                onChanged: (bool value) {
                  valueState.value = value;
                  onChanged(value);
                }),
          ],
        ),
      ),
    );
  }
}

class CityPicker extends HookWidget {
  CityPicker(
      {@required this.initialCity,
      @required this.cities,
      @required this.onChanged});
  final List<CityModel> cities;
  final CityModel initialCity;
  final ValueChanged<CityModel> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: SearchableDropdown<CityModel>.single(
        value: this.initialCity ?? cities.first,
        items: cities
            .map((city) => DropdownMenuItem(
                  child: Text(city.name),
                  value: city,
                ))
            .toList(),
        onChanged: (value) {
          onChanged(value);
        },
      ),
    );
  }
}

class FilterBar extends HookWidget {
  const FilterBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _filterChangeNotifier = useProvider(filterChangeNotifierProvider);

    return Padding(
      padding: mediumPadding,
      child: CustomCard(
        child: Container(
          height: 50,
          child: Row(
            children: [
              VerticalDivider(),
              FlatButton.icon(
                  icon: Icon(Icons.date_range),
                  onPressed: () async {
                    final date = await showDatePicker(
                        context: context,
                        initialDate: _filterChangeNotifier.dateTime,
                        firstDate: DateTime.now(),
                        lastDate: _filterChangeNotifier.dateTime
                            .add(Duration(days: 90)));

                    if (date != null) {
                      _filterChangeNotifier.setDateTime(date);
                    }
                  },
                  label: Text(DateFormat("dd.MM.yyyy")
                      .format(_filterChangeNotifier.dateTime)))
            ],
          ),
        ),
      ),
    );
  }
}
