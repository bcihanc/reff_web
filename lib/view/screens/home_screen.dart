import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reff_web/core/providers/providers.dart';
import 'package:reff_web/view/screens/questions_screen.dart';

class HomeScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // todo : eski haline çevir
    final questionsFuture = useProvider(Providers.questionsFutureProvider);

    return questionsFuture.when(
        data: (questions) {
          return Column(
            children: [
              Expanded(child: QuestionsList(questions)),
            ],
          );
        },
        loading: () => Scaffold(
              body: Center(
                child: SpinKitWave(color: Colors.grey),
              ),
            ),
        error: (error, stack) => Center(
              child: Text('$error'),
            ));
  }
}
