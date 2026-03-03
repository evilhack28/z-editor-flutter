import 'package:flutter/material.dart';
import 'package:z_editor/data/registry/module_registry.dart';
import 'package:z_editor/l10n/app_localizations.dart';

class ModuleConflictRule {
  final Set<String> conflictingClasses;
  final String? titleKey;
  final String? descriptionKey;

  const ModuleConflictRule({
    required this.conflictingClasses,
    this.titleKey,
    this.descriptionKey,
  });
}

class ConflictRegistry {
  static const List<ModuleConflictRule> rules = [
    ModuleConflictRule(
      conflictingClasses: {'SeedBankProperties', 'ConveyorSeedBankProperties'},
      descriptionKey: 'conflictDesc_SeedBankConveyor',
    ),
    ModuleConflictRule(
      conflictingClasses: {'VaseBreakerPresetProperties', 'StandardLevelIntroProperties'},
      descriptionKey: 'conflictDesc_VaseBreakerIntro',
    ),
    ModuleConflictRule(
      conflictingClasses: {'LastStandMinigameProperties', 'StandardLevelIntroProperties'},
      descriptionKey: 'conflictDesc_LastStandIntro',
    ),
    ModuleConflictRule(
      conflictingClasses: {'EvilDaveProperties', 'ZombiesDeadWinConProperties'},
      descriptionKey: 'conflictDesc_EvilDaveZombieDrop',
    ),
    ModuleConflictRule(
      conflictingClasses: {'EvilDaveProperties', 'ZombiesAteYourBrainsProperties'},
      descriptionKey: 'conflictDesc_EvilDaveVictory',
    ),
    ModuleConflictRule(
      conflictingClasses: {'ZombossBattleModuleProperties', 'ZombiesDeadWinConProperties'},
      descriptionKey: 'conflictDesc_ZombossDeathDrop',
    ),
    ModuleConflictRule(
      conflictingClasses: {'ZombossBattleIntroProperties', 'StandardLevelIntroProperties'},
      descriptionKey: 'conflictDesc_ZombossTwoIntros',
    ),
    ModuleConflictRule(
      conflictingClasses: {'InitialPlantEntryProperties', 'RoofProperties'},
      descriptionKey: 'conflictDesc_InitialPlantEntryRoof',
    ),
    ModuleConflictRule(
      conflictingClasses: {'InitialPlantProperties', 'RoofProperties'},
      descriptionKey: 'conflictDesc_InitialPlantRoof',
    ),
    ModuleConflictRule(
      conflictingClasses: {'ProtectThePlantChallengeProperties', 'RoofProperties'},
      descriptionKey: 'conflictDesc_ProtectPlantRoof',
    ),
    ModuleConflictRule(
      conflictingClasses: {'CustomLevelModuleProperties', 'LawnMowerProperties'},
      descriptionKey: 'conflictDesc_LawnMowerYard',
    ),
  ];

  /// Returns list of (localized title, localized description) for active conflicts.
  static List<Pair<String, String>> getActiveConflicts(BuildContext context, Set<String> existingObjClasses) {
    final l10n = AppLocalizations.of(context)!;
    final title = l10n.conflictTitle_ModuleLogic;
    return rules.where((rule) {
      return rule.conflictingClasses.every((cls) => existingObjClasses.contains(cls));
    }).map((rule) {
      final desc = rule.descriptionKey != null
          ? _getLocalizedConflictDescription(l10n, rule.descriptionKey!)
          : _generateDefaultDescription(context, rule);
      return Pair(title, desc);
    }).toList();
  }

  static String _getLocalizedConflictDescription(AppLocalizations l10n, String key) {
    switch (key) {
      case 'conflictDesc_SeedBankConveyor':
        return l10n.conflictDesc_SeedBankConveyor;
      case 'conflictDesc_VaseBreakerIntro':
        return l10n.conflictDesc_VaseBreakerIntro;
      case 'conflictDesc_LastStandIntro':
        return l10n.conflictDesc_LastStandIntro;
      case 'conflictDesc_EvilDaveZombieDrop':
        return l10n.conflictDesc_EvilDaveZombieDrop;
      case 'conflictDesc_EvilDaveVictory':
        return l10n.conflictDesc_EvilDaveVictory;
      case 'conflictDesc_ZombossDeathDrop':
        return l10n.conflictDesc_ZombossDeathDrop;
      case 'conflictDesc_ZombossTwoIntros':
        return l10n.conflictDesc_ZombossTwoIntros;
      case 'conflictDesc_InitialPlantEntryRoof':
        return l10n.conflictDesc_InitialPlantEntryRoof;
      case 'conflictDesc_InitialPlantRoof':
        return l10n.conflictDesc_InitialPlantRoof;
      case 'conflictDesc_ProtectPlantRoof':
        return l10n.conflictDesc_ProtectPlantRoof;
      case 'conflictDesc_LawnMowerYard':
        return l10n.conflictDesc_LawnMowerYard;
      default:
        return key;
    }
  }

  static String _generateDefaultDescription(BuildContext context, ModuleConflictRule rule) {
    final l10n = AppLocalizations.of(context)!;
    final names = rule.conflictingClasses.map((cls) {
      return ModuleRegistry.getMetadata(cls).getTitle(context);
    }).toList();
    return l10n.conflictDefaultDescription(names[0], names.length > 1 ? names[1] : names[0]);
  }
}

class Pair<A, B> {
  final A first;
  final B second;
  const Pair(this.first, this.second);
}
