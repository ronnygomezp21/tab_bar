import 'package:flutter/material.dart';

class ContentCardWidget extends StatelessWidget {
  const ContentCardWidget(
      {super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
        )
      ],
    );
  }
}
