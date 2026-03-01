import 'pvz_models.dart';

/// Parses PvzLevelFile into ParsedLevelData (from Z-Editor-master LevelParser.kt)
class LevelParser {
  static ParsedLevelData parseLevel(PvzLevelFile levelFile) {
    final objectMap = <String, PvzObject>{};
    for (final obj in levelFile.objects) {
      final alias = obj.aliases?.isNotEmpty == true ? obj.aliases!.first : 'unknown';
      objectMap[alias] = obj;
    }

    LevelDefinitionData? levelDef;
    final levelDefList = levelFile.objects.where((o) => o.objClass == 'LevelDefinition').toList();
    final levelDefObj = levelDefList.isEmpty ? null : levelDefList.first;
    if (levelDefObj != null && levelDefObj.objData is Map<String, dynamic>) {
      levelDef = LevelDefinitionData.fromJson(levelDefObj.objData as Map<String, dynamic>);
    }

    WaveManagerData? waveManager;
    final wmObj = levelFile.objects
        .where((o) => o.objClass == 'WaveManagerProperties')
        .firstOrNull;
    if (wmObj != null && wmObj.objData is Map<String, dynamic>) {
      waveManager = WaveManagerData.fromJson(
        wmObj.objData as Map<String, dynamic>,
      );
    }

    WaveManagerModuleData? waveModule;
    final wmmObj = levelFile.objects
        .where((o) => o.objClass == 'WaveManagerModuleProperties')
        .firstOrNull;
    if (wmmObj != null && wmmObj.objData is Map<String, dynamic>) {
      waveModule = WaveManagerModuleData.fromJson(
        wmmObj.objData as Map<String, dynamic>,
      );
    }

    return ParsedLevelData(
      levelDef: levelDef,
      waveManager: waveManager,
      waveModule: waveModule,
      objectMap: objectMap,
    );
  }

  static String extractAlias(String rtid) {
    final start = rtid.indexOf('(');
    final end = rtid.indexOf('@');
    if (start >= 0 && end > start) {
      return rtid.substring(start + 1, end);
    }
    return rtid;
  }

  /// Returns true if the lawn uses DeepSea or DeepSeaLand grid (6x10).
  static bool isDeepSeaLawn(LevelDefinitionData? levelDef) {
    if (levelDef == null || levelDef.stageModule.isEmpty) return false;
    final alias = extractAlias(levelDef.stageModule);
    return alias == 'DeepseaStage' || alias == 'DeepseaLandStage';
  }

  /// Returns true if level uses 6-row grid. Convenience for screens with levelFile only.
  static bool isDeepSeaLawnFromFile(PvzLevelFile levelFile) {
    final parsed = parseLevel(levelFile);
    return isDeepSeaLawn(parsed.levelDef);
  }

  /// Returns (rows, cols) for the lawn. DeepSea: (6, 10), standard: (5, 9).
  static (int rows, int cols) getGridDimensions(LevelDefinitionData? levelDef) {
    return isDeepSeaLawn(levelDef) ? (6, 10) : (5, 9);
  }

  static (int rows, int cols) getGridDimensionsFromFile(PvzLevelFile levelFile) {
    final parsed = parseLevel(levelFile);
    return getGridDimensions(parsed.levelDef);
  }

  /// Returns true if level contains any data referencing row 5 (0-indexed) or higher.
  static bool has6RowDataInLevel(PvzLevelFile levelFile) {
    for (final obj in levelFile.objects) {
      if (obj.objData is! Map<String, dynamic>) continue;
      final data = obj.objData as Map<String, dynamic>;
      if (_hasRow5OrHigher(data)) return true;
      final list = data['GridSquareBlacklist'] as List<dynamic>?;
      if (list != null) {
        for (final item in list) {
          if (item is Map) {
            final y = (item['mY'] as num?) ?? (item['Y'] as num?);
            if (y != null && y.toInt() >= 5) return true;
          }
        }
      }
      final rails = data['Rails'] as List<dynamic>?;
      if (rails != null) {
        for (final r in rails) {
          if (r is Map) {
            final end = (r['RowEnd'] as num?)?.toInt();
            if (end != null && end >= 5) return true;
          }
        }
      }
      final carts = data['Railcarts'] as List<dynamic>?;
      if (carts != null) {
        for (final c in carts) {
          if (c is Map && (c['Row'] as num?) != null) {
            if ((c['Row'] as num).toInt() >= 5) return true;
          }
        }
      }
      final zombies = data['Zombies'] as List<dynamic>?;
      if (zombies != null) {
        for (final z in zombies) {
          if (z is Map && (z['Row'] as num?) != null) {
            final row = (z['Row'] as num).toInt();
            if (row >= 6) return true; // 1-based: row 6 = 6th row
          }
        }
      }
    }
    return false;
  }

  static bool _hasRow5OrHigher(Map<String, dynamic> data) {
    final locations = data['SpawnPositionsPool'] as List<dynamic>?;
    if (locations != null) {
      for (final loc in locations) {
        if (loc is Map) {
          final y = (loc['mY'] as num?) ?? (loc['y'] as num?);
          if (y != null && y.toInt() >= 5) return true;
        }
      }
    }
    for (final key in ['Plants', 'Placements', 'InitialPlantPlacements']) {
      final list = data[key] as List<dynamic>?;
      if (list != null) {
        for (final p in list) {
          if (p is Map) {
            final gy = (p['GridY'] as num?) ?? (p['gridY'] as num?);
            if (gy != null && gy.toInt() >= 5) return true;
          }
        }
      }
    }
    return false;
  }
}
