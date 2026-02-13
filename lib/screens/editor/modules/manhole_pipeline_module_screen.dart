import 'package:flutter/material.dart';
import 'package:z_editor/data/pvz_models.dart';
import 'package:z_editor/data/rtid_parser.dart';
import 'package:z_editor/l10n/app_localizations.dart';
import 'package:z_editor/widgets/asset_image.dart' show AssetImageWidget, imageAltCandidates;
import 'package:z_editor/widgets/editor_components.dart';

/// Manhole pipeline module. Ported from ManholePipelinePropertiesEP.kt
class ManholePipelineModuleScreen extends StatefulWidget {
  const ManholePipelineModuleScreen({
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
  State<ManholePipelineModuleScreen> createState() =>
      _ManholePipelineModuleScreenState();
}

class _ManholePipelineModuleScreenState
    extends State<ManholePipelineModuleScreen> {
  late PvzObject _moduleObj;
  late ManholePipelineModuleData _data;
  int _selectedIndex = 0;
  bool _editingEnd = false;
  late TextEditingController _timeCtrl;
  late TextEditingController _damageCtrl;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final info = RtidParser.parse(widget.rtid);
    final alias = info?.alias ?? '';
    _moduleObj = widget.levelFile.objects.firstWhere(
      (o) => o.aliases?.contains(alias) == true,
      orElse: () => PvzObject(
        aliases: [alias],
        objClass: 'ManholePipelineModuleProperties',
        objData: ManholePipelineModuleData().toJson(),
      ),
    );
    if (!widget.levelFile.objects.contains(_moduleObj)) {
      widget.levelFile.objects.add(_moduleObj);
    }
    try {
      _data = ManholePipelineModuleData.fromJson(
        Map<String, dynamic>.from(_moduleObj.objData as Map),
      );
    } catch (_) {
      _data = ManholePipelineModuleData();
    }
    if (_data.pipelineList.isEmpty) {
      _data.pipelineList = [PipelineData(startX: 6, startY: 2, endX: 2, endY: 2)];
    }
    _timeCtrl = TextEditingController(text: '${_data.operationTimePerGrid}');
    _damageCtrl = TextEditingController(text: '${_data.damagePerSecond}');
  }

  void _sync() {
    _moduleObj.objData = _data.toJson();
    widget.onChanged();
    setState(() {});
  }

  void _addPipeline() {
    final list = List<PipelineData>.from(_data.pipelineList)
      ..add(PipelineData(startX: 6, startY: 2, endX: 2, endY: 2));
    _data = ManholePipelineModuleData(
      operationTimePerGrid: _data.operationTimePerGrid,
      damagePerSecond: _data.damagePerSecond,
      pipelineList: list,
    );
    _selectedIndex = list.length - 1;
    _sync();
  }

  void _removePipeline(int index) {
    if (_data.pipelineList.length <= 1) return;
    final list = List<PipelineData>.from(_data.pipelineList)..removeAt(index);
    _data = ManholePipelineModuleData(
      operationTimePerGrid: _data.operationTimePerGrid,
      damagePerSecond: _data.damagePerSecond,
      pipelineList: list,
    );
    if (_selectedIndex >= list.length) _selectedIndex = list.length - 1;
    _sync();
  }

  PipelineData get _current =>
      _data.pipelineList[_selectedIndex.clamp(0, _data.pipelineList.length - 1)];

  void _updateCurrent(PipelineData newData) {
    final list = List<PipelineData>.from(_data.pipelineList);
    list[_selectedIndex] = newData;
    _data = ManholePipelineModuleData(
      operationTimePerGrid: _data.operationTimePerGrid,
      damagePerSecond: _data.damagePerSecond,
      pipelineList: list,
    );
    _sync();
  }

  @override
  void dispose() {
    _timeCtrl.dispose();
    _damageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.back,
          onPressed: widget.onBack,
        ),
        title: Text(l10n.manholePipeline),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: l10n.tooltipAboutModule,
            onPressed: () => showEditorHelpDialog(
              context,
              title: l10n.manholePipelines,
              sections: [
                HelpSectionData(
                  title: l10n.overview,
                  body: l10n.manholePipelineHelpOverview,
                ),
                HelpSectionData(
                  title: l10n.editing,
                  body: l10n.manholePipelineHelpEditing,
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.globalParameters,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _intField(
                            controller: _timeCtrl,
                            label: l10n.timePerGrid,
                            onChanged: (v) {
                              final n = int.tryParse(v);
                              if (n != null) {
                                _data.operationTimePerGrid = n;
                                _sync();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _intField(
                            controller: _damageCtrl,
                            label: l10n.damagePerSecond,
                            onChanged: (v) {
                              final n = int.tryParse(v);
                              if (n != null) {
                                _data.damagePerSecond = n;
                                _sync();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _data.pipelineList.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  if (index == _data.pipelineList.length) {
                    return OutlinedButton.icon(
                      onPressed: _addPipeline,
                      icon: const Icon(Icons.add),
                      label: Text(l10n.add),
                    );
                  }
                  final selected = index == _selectedIndex;
                  return FilterChip(
                    label: Text(l10n.pipeN(index + 1)),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedIndex = index),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: _data.pipelineList.length > 1
                        ? () => _removePipeline(index)
                        : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                FilterChip(
                  selected: !_editingEnd,
                  label: Text(l10n.setStart),
                  onSelected: (_) => setState(() => _editingEnd = false),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  selected: _editingEnd,
                  label: Text(l10n.setEnd),
                  onSelected: (_) => setState(() => _editingEnd = true),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildGrid(theme),
            const SizedBox(height: 8),
            Text(
              l10n.manholePipelineStartEndFormat(
                _current.startX,
                _current.startY,
                _current.endX,
                _current.endY,
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(ThemeData theme) {
    return scaleTableForDesktop(
      context: context,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        child: AspectRatio(
          aspectRatio: 1.8,
          child: Container(
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              children: List.generate(5, (row) {
                return Expanded(
                  child: Row(
                    children: List.generate(9, (col) {
                      final isStart =
                          _current.startX == col && _current.startY == row;
                      final isEnd =
                          _current.endX == col && _current.endY == row;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (_editingEnd) {
                              _updateCurrent(
                                PipelineData(
                                  startX: _current.startX,
                                  startY: _current.startY,
                                  endX: col,
                                  endY: row,
                                ),
                              );
                            } else {
                              _updateCurrent(
                                PipelineData(
                                  startX: col,
                                  startY: row,
                                  endX: _current.endX,
                                  endY: _current.endY,
                                ),
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(0.5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.dividerColor,
                                width: 0.5,
                              ),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: isStart || isEnd
                                ? SizedBox.expand(
                                    child: AssetImageWidget(
                                      assetPath: isStart
                                          ? 'assets/images/griditems/steam_down.webp'
                                          : 'assets/images/griditems/steam_up.webp',
                                      fit: BoxFit.cover,
                                      altCandidates: imageAltCandidates(
                                        isStart
                                            ? 'assets/images/griditems/steam_down.webp'
                                            : 'assets/images/griditems/steam_up.webp',
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _intField({
    required TextEditingController controller,
    required String label,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      onChanged: onChanged,
    );
  }
}
