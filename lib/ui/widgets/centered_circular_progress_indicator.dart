import 'package:flutter/material.dart';

class CenteredCircularProgressIndicator extends StatelessWidget {
  const CenteredCircularProgressIndicator({super.key, required this.currentSemanticsLabel});

  final String currentSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        semanticsLabel: currentSemanticsLabel,
      ),
    );
  }
}
