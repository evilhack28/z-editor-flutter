import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:z_editor/data/level_parser.dart';
import 'package:z_editor/data/pvz_models.dart';
import 'package:z_editor/widgets/editor_components.dart';

/// Raiding party event editor. Ported from Z-Editor-master RaidingPartyEventEP.kt
class RaidingPartyEventScreen extends StatefulWidget {
  const RaidingPartyEventScreen({
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
  State<RaidingPartyEventScreen> createState() => _RaidingPartyEventScreenState();
}

class _RaidingPartyEventScreenState extends State<RaidingPartyEventScreen> {
  late PvzObject _moduleObj;
  late RaidingPartyEventData _data;

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
        objClass: 'RaidingPartyZombieSpawnerProps',
        objData: RaidingPartyEventData().toJson(),
      );
      widget.levelFile.objects.add(_moduleObj);
    }
    try {
      _data = RaidingPartyEventData.fromJson(
        Map<String, dynamic>.from(_moduleObj.objData as Map),
      );
    } catch (_) {
      _data = RaidingPartyEventData();
    }
  }

  void _sync() {
    _moduleObj.objData = _data.toJson();
    widget.onChanged();
    setState(() {});
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
              'Event: Raiding party',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => showEditorHelpDialog(
              context,
              title: 'Raiding party event',
              sections: const [
                HelpSectionData(
                  title: 'Overview',
                  body: 'Pirate港湾事件，分批依次生成飞索僵尸进攻。僵尸强制为海盗飞索，阶级随地图。',
                ),
                HelpSectionData(
                  title: 'Group size',
                  body: '每组所包含的僵尸数量。',
                ),
                HelpSectionData(
                  title: 'Swashbuckler count',
                  body: '该事件总共生成的僵尸数量。',
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spawn parameters',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildIntField(
                        theme,
                        'Group size (GroupSize)',
                        _data.groupSize,
                        (v) {
                          _data = RaidingPartyEventData(
                            groupSize: v,
                            swashbucklerCount: _data.swashbucklerCount,
                            timeBetweenGroups: _data.timeBetweenGroups,
                          );
                          _sync();
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildIntField(
                        theme,
                        'Total zombies (SwashbucklerCount)',
                        _data.swashbucklerCount,
                        (v) {
                          _data = RaidingPartyEventData(
                            groupSize: _data.groupSize,
                            swashbucklerCount: v,
                            timeBetweenGroups: _data.timeBetweenGroups,
                          );
                          _sync();
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildIntField(
                        theme,
                        'Time between groups (TimeBetweenGroups)',
                        _data.timeBetweenGroups,
                        (v) {
                          _data = RaidingPartyEventData(
                            groupSize: _data.groupSize,
                            swashbucklerCount: _data.swashbucklerCount,
                            timeBetweenGroups: v,
                          );
                          _sync();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntField(
    ThemeData theme,
    String label,
    int value,
    void Function(int) onChanged,
  ) {
    return TextFormField(
      initialValue: value.toString(),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: (v) {
        final n = int.tryParse(v);
        if (n != null) onChanged(n);
      },
    );
  }
}
