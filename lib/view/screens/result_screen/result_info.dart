import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_web/core/providers/providers.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/view/screens/result_screen/chart_model.dart';
import 'package:reff_web/view/widgets/async_value_widget_builder.dart';

class ResultInfoAsyncBuilder extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final question =
        context.read(QuestionWithAnswersChangeNotifier.provider).question;

    final resultFuture =
        useProvider(Providers.resultByQuestionIDFutureProvider(question.id));
    final answersFuture =
        useProvider(Providers.answersFutureProvider(question.answers));

    return AsyncValueWidgetBuilder<ResultModel>(
        asyncValue: resultFuture,
        dataWidget: (_, result, __) {
          return AsyncValueWidgetBuilder<List<AnswerModel>>(
              asyncValue: answersFuture,
              dataWidget: (_, answers, __) =>
                  ResultInfoContainer(result: result, answers: answers));
        });
  }
}

class ResultInfoContainer extends StatelessWidget {
  const ResultInfoContainer({@required this.result, @required this.answers})
      : assert(result != null),
        assert(answers != null);
  final ResultModel result;
  final List<AnswerModel> answers;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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

          final resultEducationMapForThisAnswer = result.educationMap.entries
              .where((element) => element.key == answer.id)
              .map((e) => e.value)
              .first;

          final resultCityNameMapForThisAnswer = result.cityNameMap.entries
              .where((element) => element.key == answer.id)
              .map((e) => e.value)
              .first;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ExpansionTile(
                backgroundColor: answer.color.toColor().withOpacity(0.3),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(answer.content),
                ),
                children: [
                  Container(
                      height: 200,
                      child: MyChart(fromMapToChartModel<Gender>(
                          resultGenderMapForThisAnswer))),
                  const SizedBox(height: 20),
                  Container(
                      height: 200,
                      child: MyChart(
                          fromMapToChartModel<int>(resultAgeMapForThisAnswer))),
                  const SizedBox(height: 20),
                  Container(
                      height: 200,
                      child: MyChart(fromMapToChartModel<String>(
                          resultCityNameMapForThisAnswer))),
                  const SizedBox(height: 20),
                  Container(
                      height: 200,
                      child: MyChart(fromMapToChartModel<Education>(
                          resultEducationMapForThisAnswer))),
                ],
              ),
            ),
          );
        });
  }
}
