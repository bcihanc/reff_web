import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reff_web/core/providers/question_provider.dart';
import 'package:reff_web/styles.dart';
import 'package:reff_web/views/shared/custom_card.dart';

class ImageUrlField extends StatefulWidget {
  ImageUrlField({Key key}) : super(key: key);

  @override
  _ImageUrlFieldState createState() => _ImageUrlFieldState();
}

class _ImageUrlFieldState extends State<ImageUrlField> {
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
        child: Row(
          children: [
            Expanded(
              child: Form(
                key: provider.imageUrlFormKey,
                child: TextFormField(
                    controller: _controller,
                    onChanged: (value) {
                      if (value != null && value.isNotEmpty) {
                        provider.updateImageUrl(value);
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
            (provider.question.imageUrl == null ||
                    provider.question.imageUrl.isEmpty)
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
                      provider.question.imageUrl ??
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
