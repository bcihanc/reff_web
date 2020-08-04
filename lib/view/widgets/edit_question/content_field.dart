import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/view/shared/custom_card.dart';

class ContentField extends StatefulWidget {
  @override
  _ContentFieldState createState() => _ContentFieldState();
}

class _ContentFieldState extends State<ContentField> {
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestionProvider>(context, listen: false);

    return CustomCard(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: provider.contentFormKey,
        child: TextFormField(
            controller: _controller..text = provider.question.content,
            onChanged: (value) {
              if (value != null && value.isNotEmpty) {
                provider.updateContent(value);
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
