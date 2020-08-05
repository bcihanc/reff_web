import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reff_web/core/providers/main_provider.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/view/shared/custom_card.dart';

class ContentField extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _controller = useTextEditingController();
    final key = useProvider(contentFormKey);

    final questionProvider = useProvider(questionStateProvider);

    return CustomCard(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: key,
        child: TextFormField(
            controller: _controller..text = questionProvider.question.content,
            onChanged: (value) {
              if (value != null && value.isNotEmpty) {
                questionProvider.updateContent(value);
              }
            },
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
