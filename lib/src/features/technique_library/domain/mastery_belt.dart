
enum MasteryBelt {
  white,
  blue,
  purple,
  brown,
  black;

  static MasteryBelt fromRepetitions(int count) {
    if (count <= 10) return MasteryBelt.white;
    if (count <= 50) return MasteryBelt.blue;
    if (count <= 150) return MasteryBelt.purple;
    if (count <= 300) return MasteryBelt.brown;
    return MasteryBelt.black;
  }

  String get displayName {
    switch (this) {
      case MasteryBelt.white:
        return 'White Belt';
      case MasteryBelt.blue:
        return 'Blue Belt';
      case MasteryBelt.purple:
        return 'Purple Belt';
      case MasteryBelt.brown:
        return 'Brown Belt';
      case MasteryBelt.black:
        return 'Black Belt';
    }
  }
}
