import 'package:flutter_test/flutter_test.dart';
import 'package:matlog/src/features/technique_library/domain/mastery_belt.dart';

void main() {
  group('MasteryBelt', () {
    test('fromRepetitions returns correct belt for thresholds', () {
      expect(MasteryBelt.fromRepetitions(0), MasteryBelt.white);
      expect(MasteryBelt.fromRepetitions(10), MasteryBelt.white);
      expect(MasteryBelt.fromRepetitions(11), MasteryBelt.blue);
      expect(MasteryBelt.fromRepetitions(50), MasteryBelt.blue);
      expect(MasteryBelt.fromRepetitions(51), MasteryBelt.purple);
      expect(MasteryBelt.fromRepetitions(150), MasteryBelt.purple);
      expect(MasteryBelt.fromRepetitions(151), MasteryBelt.brown);
      expect(MasteryBelt.fromRepetitions(300), MasteryBelt.brown);
      expect(MasteryBelt.fromRepetitions(301), MasteryBelt.black);
      expect(MasteryBelt.fromRepetitions(1000), MasteryBelt.black);
    });

    test('displayName returns correct string', () {
      expect(MasteryBelt.white.displayName, 'White Belt');
      expect(MasteryBelt.blue.displayName, 'Blue Belt');
      expect(MasteryBelt.purple.displayName, 'Purple Belt');
      expect(MasteryBelt.brown.displayName, 'Brown Belt');
      expect(MasteryBelt.black.displayName, 'Black Belt');
    });
  });
}
