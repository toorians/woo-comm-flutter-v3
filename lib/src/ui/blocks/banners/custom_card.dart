import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  CustomCard({Key? key, required this.child, this.color}) : super(key: key);

  final Widget child;
  final double margin = 1;
  final double elevation = 0.0;
  final double borderRadius = 0;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color == null ? Theme.of(context).cardColor : color,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      margin: EdgeInsets.fromLTRB(margin, margin / 2, margin, margin / 2),
      child: Column(
        children: [
          child,
          Divider(height: 0)
        ],
      ),
    );
  }
}