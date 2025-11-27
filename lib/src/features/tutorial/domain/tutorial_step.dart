import 'package:flutter/material.dart';

class TutorialStep {
  final String title;
  final String description;
  final Rect? highlightRect;
  final String? actionText;
  final VoidCallback? onAction;

  const TutorialStep({
    required this.title,
    required this.description,
    this.highlightRect,
    this.actionText,
    this.onAction,
    this.key,
    this.fallbackKey,
    this.padding = 0,
    this.paddingBottom = 0,
    this.verticalOffset = 0,
  });

  final GlobalKey? key;
  final GlobalKey? fallbackKey;
  final double padding;
  final double paddingBottom;
  final double verticalOffset;

  TutorialStep copyWith({Rect? highlightRect}) {
    return TutorialStep(
      title: title,
      description: description,
      highlightRect: highlightRect ?? this.highlightRect,
      actionText: actionText,
      onAction: onAction,
      key: key,
      fallbackKey: fallbackKey,
      padding: padding,
      paddingBottom: paddingBottom,
      verticalOffset: verticalOffset,
    );
  }
}
