import 'package:flutter/material.dart';
import 'package:z_editor/data/module_registry.dart';

class ModuleConflictRule {
  final Set<String> conflictingClasses;
  final String title;
  final String? description;

  const ModuleConflictRule({
    required this.conflictingClasses,
    this.title = 'Module Logic Conflict',
    this.description,
  });
}

class ConflictRegistry {
  static const List<ModuleConflictRule> rules = [
    ModuleConflictRule(
      conflictingClasses: {'SeedBankProperties', 'ConveyorSeedBankProperties'},
      description: 'Seed Bank and Conveyor modules interfere with each other\'s UI and may cause crashes. Ensure Seed Bank is in pre-selection mode.',
    ),
    ModuleConflictRule(
      conflictingClasses: {'VaseBreakerPresetProperties', 'StandardLevelIntroProperties'},
      description: 'Vase Breaker mode does not need an opening intro.',
    ),
    ModuleConflictRule(
      conflictingClasses: {'LastStandMinigameProperties', 'StandardLevelIntroProperties'},
      description: 'Last Stand mode does not need an opening intro.',
    ),
    ModuleConflictRule(
      conflictingClasses: {'EvilDaveProperties', 'ZombiesDeadWinConProperties'},
      description: 'I, Zombie mode cannot have Zombie Drop module.',
    ),
    ModuleConflictRule(
      conflictingClasses: {'EvilDaveProperties', 'ZombiesAteYourBrainsProperties'},
      description: 'I, Zombie mode cannot have Zombie Victory Condition.',
    ),
    ModuleConflictRule(
      conflictingClasses: {'ZombossBattleModuleProperties', 'ZombiesDeadWinConProperties'},
      description: 'Death drops in Zomboss Battle mode will prevent proper level completion.',
    ),
    ModuleConflictRule(
      conflictingClasses: {'ZombossBattleIntroProperties', 'StandardLevelIntroProperties'},
      description: 'Two level opening intros cannot coexist, otherwise Zomboss health bar will not display correctly.',
    ),
    ModuleConflictRule(
      conflictingClasses: {'InitialPlantEntryProperties', 'RoofProperties'},
      description: 'Pre-placed plants on the roof will cause a crash.',
    ),
    ModuleConflictRule(
      conflictingClasses: {'ProtectThePlantChallengeProperties', 'RoofProperties'},
      description: 'Protected plants on the roof will cause a crash.',
    ),
  ];

  static List<Pair<ModuleConflictRule, String>> getActiveConflicts(BuildContext context, Set<String> existingObjClasses) {
    return rules.where((rule) {
      return rule.conflictingClasses.every((cls) => existingObjClasses.contains(cls));
    }).map((rule) {
      final displayDesc = rule.description ?? _generateDefaultDescription(context, rule);
      return Pair(rule, displayDesc);
    }).toList();
  }

  static String _generateDefaultDescription(BuildContext context, ModuleConflictRule rule) {
    final names = rule.conflictingClasses.map((cls) {
      return ModuleRegistry.getMetadata(cls).getTitle(context);
    }).toList();
    return '${names.join(" and ")} conflict logically. It is recommended to keep only one.';
  }
}

class Pair<A, B> {
  final A first;
  final B second;
  const Pair(this.first, this.second);
}
