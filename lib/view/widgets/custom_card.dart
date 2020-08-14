import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color color;

  CustomCard({@required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: this.child,
      color: this.color,
    );
  }
}
