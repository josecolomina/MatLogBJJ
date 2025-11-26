import 'package:flutter/material.dart';
import '../domain/mastery_belt.dart';

class MasteryBeltWidget extends StatelessWidget {
  final MasteryBelt belt;
  final double height;
  final bool showLabel;

  const MasteryBeltWidget({
    super.key,
    required this.belt,
    this.height = 20,
    this.showLabel = true,
  });

  Color get _beltColor {
    switch (belt) {
      case MasteryBelt.white:
        return Colors.white;
      case MasteryBelt.blue:
        return Colors.blue[800]!;
      case MasteryBelt.purple:
        return Colors.purple[800]!;
      case MasteryBelt.brown:
        return Colors.brown[800]!;
      case MasteryBelt.black:
        return Colors.black;
    }
  }

  Color get _textColor {
    if (belt == MasteryBelt.white) return Colors.black;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _beltColor,
        borderRadius: BorderRadius.circular(4),
        border: belt == MasteryBelt.white ? Border.all(color: Colors.grey) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: showLabel
            ? Text(
                belt.displayName.toUpperCase(),
                style: TextStyle(
                  color: _textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.5,
                ),
              )
            : null,
      ),
    );
  }
}
