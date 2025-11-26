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
  });
}
