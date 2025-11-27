import 'package:flutter/material.dart';
import 'package:matlog/l10n/app_localizations.dart';
import '../domain/mastery_belt.dart';

class MasteryBeltWidget extends StatelessWidget {
  final MasteryBelt belt;
  final double height;
  final bool showLabel;
  final bool expandWidth;

  const MasteryBeltWidget({
    super.key,
    required this.belt,
    this.height = 20,
    this.showLabel = true,
    this.expandWidth = false,
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

  String _getLocalizedBeltName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (belt) {
      case MasteryBelt.white:
        return l10n.beltWhite;
      case MasteryBelt.blue:
        return l10n.beltBlue;
      case MasteryBelt.purple:
        return l10n.beltPurple;
      case MasteryBelt.brown:
        return l10n.beltBrown;
      case MasteryBelt.black:
        return l10n.beltBlack;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
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
      child: Row(
        mainAxisSize: expandWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (showLabel)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                _getLocalizedBeltName(context).toUpperCase(),
                style: TextStyle(
                  color: _textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.5,
                ),
              ),
            ),
          if (expandWidth) const Spacer(),
          // Rank Bar
          Container(
            width: height * 1.5, // Proportional width
            margin: const EdgeInsets.only(right: 4, top: 2, bottom: 2),
            decoration: BoxDecoration(
              color: belt == MasteryBelt.black ? Colors.red : Colors.black,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
