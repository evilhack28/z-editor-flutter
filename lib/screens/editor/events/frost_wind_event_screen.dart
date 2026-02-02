import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:z_editor/data/level_parser.dart';
import 'package:z_editor/data/pvz_models.dart';
import 'package:z_editor/widgets/editor_components.dart';

/// Frost wind event editor. Ported from Z-Editor-master FrostWindEventEP.kt
class FrostWindEventScreen extends StatefulWidget {
  const FrostWindEventScreen({
    super.key,
    required this.rtid,
    required this.levelFile,
    required this.onChanged,
    required this.onBack,
  });

  final String rtid;
  final PvzLevelFile levelFile;
  final VoidCallback onChanged;
  final VoidCallback onBack;

  @override
  State<FrostWindEventScreen> createState() => _FrostWindEventScreenState();
}

class _FrostWindEventScreenState extends State<FrostWindEventScreen> {
  late PvzObject _moduleObj;
  late FrostWindWaveActionPropsData _data;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final alias = LevelParser.extractAlias(widget.rtid);
    final existing = widget.levelFile.objects.firstWhereOrNull(
      (o) => o.aliases?.contains(alias) == true,
    );
    if (existing != null) {
      _moduleObj = existing;
    } else {
      _moduleObj = PvzObject(
        aliases: [alias],
        objClass: 'FrostWindWaveActionProps',
        objData: FrostWindWaveActionPropsData().toJson(),
      );
      widget.levelFile.objects.add(_moduleObj);
    }
    try {
      _data = FrostWindWaveActionPropsData.fromJson(
        Map<String, dynamic>.from(_moduleObj.objData as Map),
      );
    } catch (_) {
      _data = FrostWindWaveActionPropsData();
    }
  }

  void _sync() {
    _moduleObj.objData = _data.toJson();
    widget.onChanged();
    setState(() {});
  }

  void _addWind() {
    _data = FrostWindWaveActionPropsData(
      winds: [..._data.winds, FrostWindData(row: 2, direction: 'right')],
    );
    _sync();
  }

  void _updateWind(int index, FrostWindData wind) {
    final winds = List<FrostWindData>.from(_data.winds);
    winds[index] = wind;
    _data = FrostWindWaveActionPropsData(winds: winds);
    _sync();
  }

  void _removeWind(int index) {
    final winds = List<FrostWindData>.from(_data.winds)..removeAt(index);
    _data = FrostWindWaveActionPropsData(winds: winds);
    _sync();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alias = LevelParser.extractAlias(widget.rtid);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit $alias'),
            Text(
              'Event: Frost wind',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => showEditorHelpDialog(
              context,
              title: 'Frost wind event',
              sections: const [
                HelpSectionData(
                  title: 'Overview',
                  body: '冰河世界专属事件。在指定行生成寒风，寒风会携带冰冻效果，将植物冻结成冰块。',
                ),
                HelpSectionData(
                  title: 'Direction',
                  body: '可以设置寒风来袭的方向，可以选择从左或从右。',
                ),
              ],
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._data.winds.asMap().entries.map((e) {
                final idx = e.key;
                final wind = e.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.ac_unit, color: theme.colorScheme.secondary),
                            const SizedBox(width: 8),
                            Text(
                              'Wind #${idx + 1}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _removeWind(idx),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text('Row: ${wind.row + 1}'),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                ChoiceChip(
                                  label: const Text('Left'),
                                  selected: wind.direction == 'left',
                                  onSelected: (_) => _updateWind(
                                    idx,
                                    FrostWindData(
                                      row: wind.row,
                                      direction: 'left',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: const Text('Right'),
                                  selected: wind.direction == 'right' ||
                                      wind.direction.isEmpty,
                                  onSelected: (_) => _updateWind(
                                    idx,
                                    FrostWindData(
                                      row: wind.row,
                                      direction: 'right',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: wind.row > 0
                                  ? () => _updateWind(
                                        idx,
                                        FrostWindData(
                                          row: wind.row - 1,
                                          direction: wind.direction,
                                        ),
                                      )
                                  : null,
                            ),
                            Text('Row ${wind.row + 1}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: wind.row < 4
                                  ? () => _updateWind(
                                        idx,
                                        FrostWindData(
                                          row: wind.row + 1,
                                          direction: wind.direction,
                                        ),
                                      )
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              FilledButton.icon(
                onPressed: _addWind,
                icon: const Icon(Icons.add),
                label: const Text('Add wind'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
