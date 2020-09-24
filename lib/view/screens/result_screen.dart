import 'dart:core';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_shared/core/services/services.dart';
import 'package:reff_web/core/providers/providers.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/core/utils/locator.dart';
import 'package:flutter/material.dart' as material;

final resultIDState = StateProvider<String>((_) => "");

class ResultScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final resultID = useProvider(resultIDState);
    return Scaffold(
        appBar: AppBar(title: Text('Sonuçlar')),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.delete),
            onPressed: () async {
              // todo : add delete op.
              if (resultID.state != null && resultID.state != "") {
                await locator<BaseResultApi>().remove(resultID.state);
              } else {
                debugPrint('resultID is null');
              }
            }),
        body: Column(
          children: [
            QuestionInfo(),
            Divider(height: 40),
            Expanded(child: ResultWidget())
          ],
        ));
  }
}

class QuestionInfo extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final questionState =
        useProvider(QuestionWithAnswersChangeNotifier.provider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<QuestionModel>(
            future: locator<BaseQuestionApi>().get(questionState.question.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('loading question');
              }
              if (snapshot.hasData) {
                return Text('${snapshot.data.header}');
              } else {
                return Text('no question');
              }
            }),
      ),
    );
  }
}

class ResultWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final questionState =
        useProvider(QuestionWithAnswersChangeNotifier.provider);

    final resultFuture = useProvider(
        Providers.resultByQuestionIDFutureProvider(questionState.question.id));

    final answersFuture = useProvider(
        Providers.answersFutureProvider(questionState.question.answers));

    return resultFuture.maybeWhen(
        data: (result) => answersFuture.maybeWhen(
            data: (answers) => ListView.builder(
                itemCount: answers.length,
                itemBuilder: (context, index) {
                  final answer = answers[index];

                  final resultAgeMapForThisAnswer = result.agesMap.entries
                      .where((element) => element.key == answer.id)
                      .map((e) => e.value)
                      .first;

                  final resultGenderMapForThisAnswer = result.gendersMap.entries
                      .where((element) => element.key == answer.id)
                      .map((e) => e.value)
                      .first;

                  final resultCityNameMapForThisAnswer = result
                      .cityNameMap.entries
                      .where((element) => element.key == answer.id)
                      .map((e) => e.value)
                      .first;

                  final mockAgeMap = {
                    19: 200,
                    32: 418,
                    41: 94,
                    58: 148,
                    67: 42,
                  };
                  final mockGenderMap = {
                    Gender.FEMALE: 251,
                    Gender.MALE: 418,
                    Gender.OTHERS: 13,
                  };
                  final mockCityMap = {
                    "İstanbul": 200,
                    "Ankara": 418,
                    "İzmir": 94,
                    "Antalya": 148,
                    "Muğla": 42,
                  };

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ExpansionTile(
                        backgroundColor:
                            answer.color.toColor().withOpacity(0.3),
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(answer.content),
                        ),
                        children: [
                          Container(
                              height: 200,
                              child: MyChart(
                                  fromMapToChartModel<Gender>(mockGenderMap))),
                          Container(
                              height: 200,
                              child: MyChart(
                                  fromMapToChartModel<int>(mockAgeMap))),
                          Container(
                              height: 200,
                              child: MyChart(
                                  fromMapToChartModel<String>(mockCityMap))),
                        ],
                      ),
                    ),
                  );
                }),
            orElse: () => Text('loading answers')),
        orElse: () => Center(child: Text('loading result')));
  }
}

class CreateNewResult extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final questionProvider =
        useProvider(QuestionWithAnswersChangeNotifier.provider);

    return Center(
      child: RaisedButton(
          child: Text('not found result, create new one'),
          onPressed: () async {
            await locator<BaseResultApi>()
                .addFromQuestion(questionProvider.question.id);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }),
    );
  }
}

class MyChart extends HookWidget {
  final List<Series> seriesList;

  MyChart(this.seriesList);

  @override
  Widget build(BuildContext context) {
    return seriesList == null
        ? Center(child: Text('no data'))
        : BarChart(
            seriesList,
            animate: false,
            vertical: false,
          );
  }
}

List<Series<SeriesModel<T>, String>> fromMapToChartModel<T>(Map<T, int> map) {
  if (map == null && map.isEmpty) return null;

  final data = <SeriesModel<T>>[];
  map.forEach((key, value) {
    if (value > 0) {
      final entry = SeriesModel<T>(label: key, amount: value);
      data.add(entry);
    }
  });

  if (data.isEmpty) return null;

  return [
    Series<SeriesModel<T>, String>(
      id: 'LABEL',
      domainFn: (model, _) => model.label.toString(),
      measureFn: (model, _) => model.amount,
      data: data,
      labelAccessorFn: (row, _) => '${row.label}: ${row.amount}',
    )
  ];
}

class SeriesModel<T> {
  SeriesModel({@required this.label, @required this.amount})
      : assert(label != null),
        assert(amount != null);

  final T label;
  final int amount;
}
