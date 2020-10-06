import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reff_shared/core/models/models.dart';
import 'package:reff_shared/core/services/services.dart';
import 'package:reff_web/core/providers/providers.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/core/utils/locator.dart';
import 'package:reff_web/view/widgets/async_value_widget_builder.dart';

class QuestionInfoAsyncBuilder extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final questionID =
        context.read(QuestionWithAnswersChangeNotifier.provider).question.id;

    final questionFuture =
        useProvider(Providers.questionFutureProvider(questionID));

    return AsyncValueWidgetBuilder<QuestionModel>(
        asyncValue: questionFuture,
        dataWidget: (_, question, __) => _QuestionInfoContainer(question));
  }
}

class _QuestionInfoContainer extends StatelessWidget {
  _QuestionInfoContainer(this.question) : assert(question != null);
  final QuestionModel question;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Text('${question.header}'),
    );
  }
}
