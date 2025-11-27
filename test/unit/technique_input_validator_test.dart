import 'package:flutter_test/flutter_test.dart';
import 'package:matlog/src/features/technique_library/domain/technique_input_validator.dart';

void main() {
  group('TechniqueInputValidator', () {
    group('sanitizeTechniqueName', () {
      test('trims whitespace', () {
        expect(
          TechniqueInputValidator.sanitizeTechniqueName('  armbar  '),
          'Armbar',
        );
      });

      test('removes special characters', () {
        expect(
          TechniqueInputValidator.sanitizeTechniqueName('Arm@bar#123!'),
          'Armbar123',
        );
      });

      test('normalizes multiple spaces to single space', () {
        expect(
          TechniqueInputValidator.sanitizeTechniqueName('  arm    bar   from   guard  '),
          'Arm Bar From Guard',
        );
      });

      test('capitalizes first letter of each word', () {
        expect(
          TechniqueInputValidator.sanitizeTechniqueName('ARMBAR FROM GUARD'),
          'Armbar From Guard',
        );
        
        expect(
          TechniqueInputValidator.sanitizeTechniqueName('armbar from guard'),
          'Armbar From Guard',
        );
      });

      test('handles unicode characters correctly', () {
        expect(
          TechniqueInputValidator.sanitizeTechniqueName('Triángulo'),
          'Triángulo',
        );
        
        expect(
          TechniqueInputValidator.sanitizeTechniqueName('barrida española'),
          'Barrida Española',
        );
      });

      test('handles hyphens correctly', () {
        expect(
          TechniqueInputValidator.sanitizeTechniqueName('arm-bar'),
          'Arm-bar',
        );
        
        expect(
          TechniqueInputValidator.sanitizeTechniqueName('d-arce choke'),
          'D-arce Choke',
        );
      });

      test('limits length to maxNameLength', () {
        final longName = 'a' * 150;
        final result = TechniqueInputValidator.sanitizeTechniqueName(longName);
        
        expect(result.length, lessThanOrEqualTo(TechniqueInputValidator.maxNameLength));
      });

      test('throws ValidationException on empty input', () {
        expect(
          () => TechniqueInputValidator.sanitizeTechniqueName(''),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws ValidationException on whitespace only', () {
        expect(
          () => TechniqueInputValidator.sanitizeTechniqueName('   '),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws ValidationException when only special characters', () {
        expect(
          () => TechniqueInputValidator.sanitizeTechniqueName(r'@#$%^&*()'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('handles mixed case with numbers', () {
        expect(
          TechniqueInputValidator.sanitizeTechniqueName('x-guard 2.0'),
          'X-guard 20',
        );
      });
    });

    group('normalizeCategory', () {
      test('maps "guard" variations to Guardia', () {
        expect(TechniqueInputValidator.normalizeCategory('guard'), 'Guardia');
        expect(TechniqueInputValidator.normalizeCategory('GUARD'), 'Guardia');
        expect(TechniqueInputValidator.normalizeCategory('guardia'), 'Guardia');
        expect(TechniqueInputValidator.normalizeCategory('guarda'), 'Guardia');
      });

      test('maps "passing" variations to Pasaje', () {
        expect(TechniqueInputValidator.normalizeCategory('passing'), 'Pasaje');
        expect(TechniqueInputValidator.normalizeCategory('pass'), 'Pasaje');
        expect(TechniqueInputValidator.normalizeCategory('pasaje'), 'Pasaje');
        expect(TechniqueInputValidator.normalizeCategory('pase'), 'Pasaje');
      });

      test('maps "submission" variations to Sumisión', () {
        expect(TechniqueInputValidator.normalizeCategory('submission'), 'Sumisión');
        expect(TechniqueInputValidator.normalizeCategory('sub'), 'Sumisión');
        expect(TechniqueInputValidator.normalizeCategory('sumision'), 'Sumisión');
        expect(TechniqueInputValidator.normalizeCategory('finish'), 'Sumisión');
      });

      test('maps "defense" variations to Defensa', () {
        expect(TechniqueInputValidator.normalizeCategory('defense'), 'Defensa');
        expect(TechniqueInputValidator.normalizeCategory('defensa'), 'Defensa');
        expect(TechniqueInputValidator.normalizeCategory('escape'), 'Defensa');
      });

      test('maps "takedown" variations to Derribo', () {
        expect(TechniqueInputValidator.normalizeCategory('takedown'), 'Derribo');
        expect(TechniqueInputValidator.normalizeCategory('derribo'), 'Derribo');
        expect(TechniqueInputValidator.normalizeCategory('throw'), 'Derribo');
      });

      test('returns "Otra" for unknown categories', () {
        expect(TechniqueInputValidator.normalizeCategory('unknown'), 'Otra');
        expect(TechniqueInputValidator.normalizeCategory('random'), 'Otra');
        expect(TechniqueInputValidator.normalizeCategory(''), 'Otra');
      });

      test('handles whitespace in input', () {
        expect(TechniqueInputValidator.normalizeCategory('  guard  '), 'Guardia');
      });
    });

    group('normalizePosition', () {
      test('maps common guard variations', () {
        expect(TechniqueInputValidator.normalizePosition('guard'), 'Guard');
        expect(TechniqueInputValidator.normalizePosition('guardia'), 'Guard');
        expect(TechniqueInputValidator.normalizePosition('closed guard'), 'Closed Guard');
        expect(TechniqueInputValidator.normalizePosition('half guard'), 'Half Guard');
      });

      test('maps control positions', () {
        expect(TechniqueInputValidator.normalizePosition('side control'), 'Side Control');
        expect(TechniqueInputValidator.normalizePosition('mount'), 'Mount');
        expect(TechniqueInputValidator.normalizePosition('back'), 'Back');
      });

      test('capitalizes unknown positions', () {
        expect(TechniqueInputValidator.normalizePosition('butterfly guard'), 'Butterfly Guard');
        expect(TechniqueInputValidator.normalizePosition('TURTLE'), 'Turtle');
      });

      test('handles Spanish variations', () {
        expect(TechniqueInputValidator.normalizePosition('guardia cerrada'), 'Closed Guard');
        expect(TechniqueInputValidator.normalizePosition('control lateral'), 'Side Control');
      });

      test('limits length to maxPositionLength', () {
        final longPosition = 'some very long position name that exceeds the maximum allowed length for positions';
        final result = TechniqueInputValidator.normalizePosition(longPosition);
        
        expect(result.length, lessThanOrEqualTo(TechniqueInputValidator.maxPositionLength));
      });

      test('throws ValidationException on empty input', () {
        expect(
          () => TechniqueInputValidator.normalizePosition(''),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('normalizeTags', () {
      test('converts tags to lowercase', () {
        final result = TechniqueInputValidator.normalizeTags(['BJJ', 'NoGi', 'Competition']);
        expect(result, ['bjj', 'nogi', 'competition']);
      });

      test('trims whitespace from tags', () {
        final result = TechniqueInputValidator.normalizeTags(['  bjj  ', ' nogi ']);
        expect(result, ['bjj', 'nogi']);
      });

      test('removes empty tags', () {
        final result = TechniqueInputValidator.normalizeTags(['bjj', '', '  ', 'nogi']);
        expect(result, ['bjj', 'nogi']);
      });

      test('removes duplicate tags', () {
        final result = TechniqueInputValidator.normalizeTags(['bjj', 'BJJ', 'bjj', 'nogi']);
        expect(result, ['bjj', 'nogi']);
      });

      test('limits number of tags to 10', () {
        final manyTags = List.generate(15, (i) => 'tag$i');
        final result = TechniqueInputValidator.normalizeTags(manyTags);
        expect(result.length, lessThanOrEqualTo(10));
      });

      test('filters out tags longer than 30 characters', () {
        final result = TechniqueInputValidator.normalizeTags([
          'short',
          'this is a very long tag that exceeds thirty characters',
        ]);
        expect(result, ['short']);
      });
    });

    group('generateSafeId', () {
      test('combines name and position with underscore', () {
        final id = TechniqueInputValidator.generateSafeId('Armbar', 'Guard');
        expect(id, 'armbar_guard');
      });

      test('converts to lowercase', () {
        final id = TechniqueInputValidator.generateSafeId('ARMBAR', 'GUARD');
        expect(id, 'armbar_guard');
      });

      test('replaces spaces with underscores', () {
        final id = TechniqueInputValidator.generateSafeId('Arm Bar', 'Closed Guard');
        expect(id, 'arm_bar_closed_guard');
      });

      test('removes special characters', () {
        final id = TechniqueInputValidator.generateSafeId('Arm@bar#', 'Guard!');
        expect(id, 'arm_bar_guard');
      });

      test('normalizes multiple underscores to single', () {
        final id = TechniqueInputValidator.generateSafeId('Arm  Bar', 'Half   Guard');
        expect(id, 'arm_bar_half_guard');
      });

      test('removes leading and trailing underscores', () {
        final id = TechniqueInputValidator.generateSafeId('  Armbar  ', '  Guard  ');
        expect(id, 'armbar_guard');
      });

      test('limits length to 100 characters', () {
        final longName = 'a' * 80;
        final longPosition = 'b' * 80;
        final id = TechniqueInputValidator.generateSafeId(longName, longPosition);
        
        expect(id.length, lessThanOrEqualTo(100));
      });

      test('is deterministic (same input produces same output)', () {
        final id1 = TechniqueInputValidator.generateSafeId('Armbar', 'Guard');
        final id2 = TechniqueInputValidator.generateSafeId('Armbar', 'Guard');
        expect(id1, id2);
      });

      test('throws ValidationException when result would be empty', () {
        expect(
          () => TechniqueInputValidator.generateSafeId(r'@#$%', r'!@#$'),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('ValidationException', () {
      test('has message property', () {
        final exception = ValidationException('test message');
        expect(exception.message, 'test message');
      });

      test('toString includes message', () {
        final exception = ValidationException('test message');
        expect(exception.toString(), contains('test message'));
      });

      test('equality works correctly', () {
        final ex1 = ValidationException('test');
        final ex2 = ValidationException('test');
        final ex3 = ValidationException('other');
        
        expect(ex1, ex2);
        expect(ex1, isNot(ex3));
      });
    });
  });
}
