import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reff_web/core/providers/main_provider.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/view/shared/custom_card.dart';

class ImageUrlField extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _controller = useTextEditingController();
    final questionProvider = useProvider(questionStateProvider);
    final key = useProvider(imageUrlFormKey);

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Form(
                key: key,
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
