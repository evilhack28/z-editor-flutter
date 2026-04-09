import 'package:flutter_test/flutter_test.dart';
import 'package:z_editor/data/registry/module_registry.dart';

void main() {
  group('BronzeProperties module metadata', () {
    test('is registered as single-instance (allowMultiple false)', () {
      final meta = ModuleRegistry.registry['BronzeProperties'];
      expect(meta, isNotNull);
      expect(meta!.allowMultiple, isFalse);
    });

    test('is in the same category as other minigame-style modules (mode)', () {
      final bronze = ModuleRegistry.registry['BronzeProperties'];
      final bowling = ModuleRegistry.registry['BowlingMinigameProperties'];
      expect(bronze, isNotNull);
      expect(bowling, isNotNull);
      expect(bronze!.category, ModuleCategory.mode);
      expect(bronze.category, bowling!.category);
    });
  });
}
