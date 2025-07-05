import 'package:flutter/material.dart';

class StyledTitleText extends StatelessWidget {
  const StyledTitleText({
    super.key,
    required this.text,
    required this.fontSize,
  });

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyMedium!.color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
