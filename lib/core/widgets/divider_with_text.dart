import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  final double? thickness;

  const DividerWithText({
    super.key,
    required this.text,
    this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: thickness ?? 1,
            color: Colors.grey.shade300,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: thickness ?? 1,
            color: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }
}