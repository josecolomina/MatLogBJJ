import 'package:flutter/material.dart';

enum BeltColor {
  white,
  blue,
  purple,
  brown,
  black;

  String get displayName {
    switch (this) {
      case BeltColor.white:
        return 'White';
      case BeltColor.blue:
        return 'Blue';
      case BeltColor.purple:
        return 'Purple';
      case BeltColor.brown:
        return 'Brown';
      case BeltColor.black:
        return 'Black';
    }
  }

  Color get colorValue {
    switch (this) {
      case BeltColor.white:
        return Colors.white;
      case BeltColor.blue:
        return const Color(0xFF2196F3); // Standard Blue
      case BeltColor.purple:
        return const Color(0xFF9C27B0); // Standard Purple
      case BeltColor.brown:
        return const Color(0xFF795548); // Standard Brown
      case BeltColor.black:
        return Colors.black;
    }
  }
}

class BeltInfo {
  final BeltColor color;
  final int stripes;

  const BeltInfo({
    required this.color,
    required this.stripes,
  }) : assert(stripes >= 0 && stripes <= 9, 'Stripes must be between 0 and 9');

  Map<String, dynamic> toMap() {
    return {
      'color': color.name,
      'stripes': stripes,
    };
  }

  factory BeltInfo.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const BeltInfo(color: BeltColor.white, stripes: 0);
    
    return BeltInfo(
      color: BeltColor.values.firstWhere(
        (e) => e.name == map['color'],
        orElse: () => BeltColor.white,
      ),
      stripes: (map['stripes'] as int?) ?? 0,
    );
  }
}
