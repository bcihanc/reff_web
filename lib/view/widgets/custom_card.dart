import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;

  CustomCard({this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: this.child,
    );
  }
}
