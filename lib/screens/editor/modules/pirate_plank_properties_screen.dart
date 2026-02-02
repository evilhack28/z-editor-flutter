import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:z_editor/data/pvz_models.dart';
import 'package:z_editor/data/reference_repository.dart';
import 'package:z_editor/data/rtid_parser.dart';

/// Pirate plank properties editor. Ported from Z-Editor-master PiratePlankPropertiesEP.kt
class PiratePlankPropertiesScreen extends StatefulWidget {
  const PiratePlankPropertiesScreen({
    super.key,
    required this.rtid,
    required this.levelFile,
    required this.levelDef,
    required this.onChanged,
    required this.onBack,
  });

  final String rtid;
  final PvzLevelFile levelFile;
  final LevelDefinitionData levelDef;
  final VoidCallback onChanged;
  final VoidCallback onBack;

  @override
  State<PiratePlankPropertiesScreen> createState() =>
      _PiratePlankPropertiesScreenState();
}

class _PiratePlankPropertiesScreenState
    extends State<PiratePlankPropertiesScreen> {
  late PvzObject _moduleObj;
  late PiratePlankPropertiesData _data;
  bool _isPirateStage = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final info = RtidParser.parse(widget.rtid);
    final alias = info?.alias ?? '';
    final existing = widget.levelFile.objects.firstWhereOrNull(
      (o) => o.aliases?.contains(alias) == true,
    );
    if (existing != null) {
      _moduleObj = existing;
    } else {
      _moduleObj = PvzObject(
        aliases: [alias],
        objClass: 'PiratePlankProperties',
        objData: PiratePlankPropertiesData().toJson(),
      );
      widget.levelFile.objects.add(_moduleObj);
    }
    try {
      _data = PiratePlankPropertiesData.fromJson(
        Map<String, dynamic>.from(_moduleObj.objData as Map),
      );
    } catch (_) {
      _data = PiratePlankPropertiesData();
    }
    final stageInfo = RtidParser.parse(widget.levelDef.stageModule);
    final stageObjClass = stageInfo?.alias != null
        ? ReferenceRepository.instance.getObjClass(stageInfo!.alias)
        : null;
    _isPirateStage = stageObjClass == 'PirateStageProperties';
  }

  void _sync() {
    _moduleObj.objData = _data.toJson();
    widget.onChanged();
    setState(() {});
  }

  bool _hasPlank(int row) => _data.plankRows.contains(row);

  void _setPlank(int row, bool value) {
    final rows = List<int>.from(_data.plankRows);
    if (value) {
      if (!rows.contains(row)) {
        rows.add(row);
        rows.sort();
      }
    } else {
      rows.remove(row);
    }
    _data = PiratePlankPropertiesData(plankRows: rows);
    _sync();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: const Text('Pirate plank'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isPirateStage) ...[
              Card(
                color: theme.colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Stage mismatch',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Current stage is not Pirate. This module may not work correctly.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              'Plank rows (0–4)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: List.generate(5, (row) {
                  final hasDivider = row < 4;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Row ${row + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Index: $row',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _hasPlank(row),
                              onChanged: (v) => _setPlank(row, v),
                            ),
                          ],
                        ),
                      ),
                      if (hasDivider)
                        Divider(
                          height: 1,
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                    ],
                  );
                }),
              ),
            ),
            if (_data.plankRows.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected rows:',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _data.plankRows
                            .map((r) => 'Row ${r + 1}')
                            .join(', '),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
