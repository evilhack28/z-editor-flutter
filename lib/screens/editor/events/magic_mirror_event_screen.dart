import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:z_editor/data/level_parser.dart';
import 'package:z_editor/data/pvz_models.dart';
import 'package:z_editor/l10n/app_localizations.dart';
import 'package:z_editor/widgets/asset_image.dart' show AssetImageWidget, imageAltCandidates;
import 'package:z_editor/widgets/editor_components.dart';

/// Magic mirror event editor. Ported from Z-Editor-master MagicMirrorEventEP.kt
class MagicMirrorEventScreen extends StatefulWidget {
  const MagicMirrorEventScreen({
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
  State<MagicMirrorEventScreen> createState() => _MagicMirrorEventScreenState();
}

class _MagicMirrorEventScreenState extends State<MagicMirrorEventScreen> {
  late PvzObject _moduleObj;
  late MagicMirrorWaveActionData _data;
  int _selectedIndex = 0;
  bool _isEditingMirror2 = false;

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
        objClass: 'MagicMirrorWaveActionProps',
        objData: MagicMirrorWaveActionData().toJson(),
      );
      widget.levelFile.objects.add(_moduleObj);
    }
    try {
      _data = MagicMirrorWaveActionData.fromJson(
        Map<String, dynamic>.from(_moduleObj.objData as Map),
      );
    } catch (_) {
      _data = MagicMirrorWaveActionData();
    }
    if (_data.arrays.isEmpty) {
      _data = MagicMirrorWaveActionData(
        arrays: [
          MagicMirrorArrayData(
            mirror1GridX: 2,
            mirror1GridY: 2,
            mirror2GridX: 6,
            mirror2GridY: 2,
            typeIndex: 1,
            mirrorExistDuration: 300,
          ),
        ],
      );
      _sync();
    }
  }

  void _sync() {
    _moduleObj.objData = _data.toJson();
    widget.onChanged();
    setState(() {});
  }

  void _updateArray(int index, MagicMirrorArrayData arr) {
    final arrays = List<MagicMirrorArrayData>.from(_data.arrays);
    if (index < arrays.length) {
      arrays[index] = arr;
      _data = MagicMirrorWaveActionData(arrays: arrays);
      _sync();
    }
  }

  void _addArray() {
    _data = MagicMirrorWaveActionData(
      arrays: [
        ..._data.arrays,
        MagicMirrorArrayData(
          mirror1GridX: 2,
          mirror1GridY: 2,
          mirror2GridX: 6,
          mirror2GridY: 2,
          typeIndex: 1,
          mirrorExistDuration: 300,
        ),
      ],
    );
    _selectedIndex = _data.arrays.length - 1;
    _sync();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final alias = LevelParser.extractAlias(widget.rtid);
    final currentArray = _data.arrays.elementAtOrNull(_selectedIndex);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n?.editAlias(alias) ?? 'Edit $alias'),
            Text(
              l10n?.eventMagicMirror ?? 'Magic mirror event',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => showEditorHelpDialog(
              context,
              title: l10n?.eventMagicMirror ?? 'Magic mirror event',
              sections: [
                HelpSectionData(
                  title: l10n?.overview ?? 'Overview',
                  body: l10n?.eventHelpMagicMirrorBody ?? '',
                ),
                HelpSectionData(
                  title: l10n?.typeIndex ?? 'Type index',
                  body: l10n?.eventHelpMagicMirrorType ?? '',
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ..._data.arrays.asMap().entries.map((e) {
                      final idx = e.key;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(l10n?.groupN(idx + 1) ?? 'Group ${idx + 1}'),
                          selected: idx == _selectedIndex,
                          onSelected: (_) =>
                              setState(() => _selectedIndex = idx),
                        ),
                      );
                    }),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addArray,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (currentArray != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n?.groupConfigN(_selectedIndex + 1) ?? 'Group ${_selectedIndex + 1} config',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          initialValue: [1, 2, 3].contains(currentArray.typeIndex)
                              ? currentArray.typeIndex
                              : 1,
                          decoration: InputDecoration(
                            labelText: l10n?.typeIndex ?? 'Type index',
                            border: const OutlineInputBorder(),
                          ),
                          items: [1, 2, 3]
                              .map((i) => DropdownMenuItem(
                                    value: i,
                                    child: Text(l10n?.styleN(i) ?? 'Style $i'),
                                  ))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              _updateArray(
                                _selectedIndex,
                                MagicMirrorArrayData(
                                  mirror1GridX: currentArray.mirror1GridX,
                                  mirror1GridY: currentArray.mirror1GridY,
                                  mirror2GridX: currentArray.mirror2GridX,
                                  mirror2GridY: currentArray.mirror2GridY,
                                  typeIndex: v,
                                  mirrorExistDuration:
                                      currentArray.mirrorExistDuration,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue:
                              currentArray.mirrorExistDuration.toString(),
                          decoration: InputDecoration(
                            labelText: l10n?.existDurationSec ?? 'Exist duration (sec)',
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (v) {
                            final n = int.tryParse(v);
                            if (n != null) {
                              _updateArray(
                                _selectedIndex,
                                MagicMirrorArrayData(
                                  mirror1GridX: currentArray.mirror1GridX,
                                  mirror1GridY: currentArray.mirror1GridY,
                                  mirror2GridX: currentArray.mirror2GridX,
                                  mirror2GridY: currentArray.mirror2GridY,
                                  typeIndex: currentArray.typeIndex,
                                  mirrorExistDuration: n,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        SegmentedButton<bool>(
                          segments: [
                            ButtonSegment(
                              value: false,
                              label: Text(l10n?.mirror1 ?? 'Mirror 1'),
                              icon: const Icon(Icons.login),
                            ),
                            ButtonSegment(
                              value: true,
                              label: Text(l10n?.mirror2 ?? 'Mirror 2'),
                              icon: const Icon(Icons.logout),
                            ),
                          ],
                          selected: {_isEditingMirror2},
                          onSelectionChanged: (s) =>
                              setState(() => _isEditingMirror2 = s.first),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'M1: R${currentArray.mirror1GridY + 1}:C${currentArray.mirror1GridX + 1}  |  M2: R${currentArray.mirror2GridY + 1}:C${currentArray.mirror2GridX + 1}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: AspectRatio(
                      aspectRatio: 9 / 5,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 9,
                          childAspectRatio: 1,
                        ),
                        itemCount: 45,
                        itemBuilder: (context, i) {
                          final col = i % 9;
                          final row = i ~/ 9;
                          final isTarget = _isEditingMirror2
                              ? col == currentArray.mirror2GridX &&
                                  row == currentArray.mirror2GridY
                              : col == currentArray.mirror1GridX &&
                                  row == currentArray.mirror1GridY;
                          final mirrorInCell = _data.arrays.indexed
                              .where((e) {
                                final arr = e.$2;
                                return (arr.mirror1GridX == col &&
                                        arr.mirror1GridY == row) ||
                                    (arr.mirror2GridX == col &&
                                        arr.mirror2GridY == row);
                              })
                              .map((e) => (e.$1, e.$2.typeIndex))
                              .lastOrNull;
                          return GestureDetector(
                            onTap: () {
                              if (_isEditingMirror2) {
                                _updateArray(
                                  _selectedIndex,
                                  MagicMirrorArrayData(
                                    mirror1GridX: currentArray.mirror1GridX,
                                    mirror1GridY: currentArray.mirror1GridY,
                                    mirror2GridX: col,
                                    mirror2GridY: row,
                                    typeIndex: currentArray.typeIndex,
                                    mirrorExistDuration:
                                        currentArray.mirrorExistDuration,
                                  ),
                                );
                              } else {
                                _updateArray(
                                  _selectedIndex,
                                  MagicMirrorArrayData(
                                    mirror1GridX: col,
                                    mirror1GridY: row,
                                    mirror2GridX: currentArray.mirror2GridX,
                                    mirror2GridY: currentArray.mirror2GridY,
                                    typeIndex: currentArray.typeIndex,
                                    mirrorExistDuration:
                                        currentArray.mirrorExistDuration,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isTarget
                                    ? theme.colorScheme.primaryContainer
                                    : theme.colorScheme.surfaceContainerHighest,
                                border: Border.all(
                                  color: isTarget
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outlineVariant,
                                ),
                              ),
                              child: mirrorInCell != null
                                  ? Center(
                                      child: AssetImageWidget(
                                        assetPath:
                                            'assets/images/griditems/magic_mirror${mirrorInCell.$2}.png',
                                        width: 32,
                                        height: 32,
                                        fit: BoxFit.contain,
                                        altCandidates: imageAltCandidates(
                                          'assets/images/griditems/magic_mirror${mirrorInCell.$2}.png',
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ] else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(l10n?.addMirrorGroup ?? 'Add a mirror group above'),
                  ),
                ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
