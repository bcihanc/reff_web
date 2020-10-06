import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AsyncValueWidgetBuilder<T> extends StatelessWidget {
  const AsyncValueWidgetBuilder(
      {@required this.asyncValue,
      @required this.dataWidget,
      this.loadingWidget,
      this.errorWidget})
      : assert(asyncValue != null),
        assert(dataWidget != null);

  final AsyncValue<T> asyncValue;
  final ValueWidgetBuilder<T> dataWidget;
  final WidgetBuilder loadingWidget;
  final ValueWidgetBuilder errorWidget;

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
        data: (data) => dataWidget(context, data, null),
        loading: () => loadingWidget == null
            ? Center(child: CircularProgressIndicator())
            : loadingWidget(context),
        error: (error, stack) => errorWidget == null
            ? Center(child: Text('$error'))
            : errorWidget(context, error, null));
  }
}
