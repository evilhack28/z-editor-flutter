import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:z_editor/data/pvz_models.dart';
import 'package:z_editor/data/rtid_parser.dart';
import 'package:z_editor/data/zombie_repository.dart';
import 'package:z_editor/screens/select/zombie_selection_screen.dart';
import 'package:z_editor/widgets/asset_image.dart';
import 'package:z_editor/widgets/editor_components.dart';

/// Zombie spawn event editor for JitteredWave and GroundSpawner.
/// Ported from Z-Editor-master JitteredWaveEventEP.kt, SpawnZombiesFromGroundEventEP.kt
class ZombieSpawnEventScreen extends StatefulWidget {
  const ZombieSpawnEventScreen({
    super.key,
    required this.rtid,
    required this.levelFile,
    required this.onChanged,
    required this.onBack,
    required this.eventSubtitle,
    required this.isGroundSpawner,
    required this.onRequestZombieSelection,
  });

  final String rtid;
  final PvzLevelFile levelFile;
  final VoidCallback onChanged;
  final VoidCallback onBack;
  final String eventSubtitle;
  final bool isGroundSpawner;
  final void Function(void Function(String) onSelected) onRequestZombieSelection;

  @override
  State<ZombieSpawnEventScreen> createState() => _ZombieSpawnEventScreenState();
}

class _ZombieSpawnEventScreenState extends State<ZombieSpawnEventScreen> {
  late PvzObject _moduleObj;
  late dynamic _data;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final info = RtidParser.parse(widget.rtid);
    final alias = info?.alias ?? '';
    final objClass = widget.isGroundSpawner
        ? 'SpawnZombiesFromGroundSpawnerProps'
        : 'SpawnZombiesJitteredWaveActionProps';
    final existing = widget.levelFile.objects.firstWhereOrNull(
      (o) => o.aliases?.contains(alias) == true,
    );
    if (existing != null) {
      _moduleObj = existing;
    } else {
      _moduleObj = PvzObject(
        aliases: [alias],
        objClass: objClass,
        objData: widget.isGroundSpawner
            ? SpawnZombiesFromGroundData().toJson()
            : WaveActionData().toJson(),
      );
      widget.levelFile.objects.add(_moduleObj);
    }
    try {
      if (widget.isGroundSpawner) {
        _data = SpawnZombiesFromGroundData.fromJson(
          Map<String, dynamic>.from(_moduleObj.objData as Map),
        );
      } else {
        _data = WaveActionData.fromJson(
          Map<String, dynamic>.from(_moduleObj.objData as Map),
        );
      }
    } catch (_) {
      _data = widget.isGroundSpawner
          ? SpawnZombiesFromGroundData()
          : WaveActionData();
    }
  }

  List<ZombieSpawnData> get _zombies =>
      widget.isGroundSpawner
          ? (_data as SpawnZombiesFromGroundData).zombies
          : (_data as WaveActionData).zombies;

  void _sync() {
    _moduleObj.objData = widget.isGroundSpawner
        ? (_data as SpawnZombiesFromGroundData).toJson()
        : (_data as WaveActionData).toJson();
    widget.onChanged();
    setState(() {});
  }

  void _addZombie({int? row}) {
    widget.onRequestZombieSelection((id) {
      final aliases = ZombieRepository().buildZombieAliases(id);
      final rtid = RtidParser.build(aliases, 'ZombieTypes');
      final zombies = List<ZombieSpawnData>.from(_zombies)
        ..add(ZombieSpawnData(type: rtid, level: null, row: row));
      _updateZombies(zombies);
    });
  }

  void _updateZombies(List<ZombieSpawnData> zombies) {
    if (widget.isGroundSpawner) {
      _data = SpawnZombiesFromGroundData(
        columnStart: (_data as SpawnZombiesFromGroundData).columnStart,
        columnEnd: (_data as SpawnZombiesFromGroundData).columnEnd,
        additionalPlantFood: (_data as SpawnZombiesFromGroundData).additionalPlantFood,
        spawnPlantName: (_data as SpawnZombiesFromGroundData).spawnPlantName,
        zombies: zombies,
      );
    } else {
      _data = WaveActionData(
        notificationEvents: (_data as WaveActionData).notificationEvents,
        additionalPlantFood: (_data as WaveActionData).additionalPlantFood,
        spawnPlantName: (_data as WaveActionData).spawnPlantName,
        zombies: zombies,
      );
    }
    _sync();
  }

  void _removeZombie(int index) {
    final zombies = List<ZombieSpawnData>.from(_zombies)..removeAt(index);
    _updateZombies(zombies);
  }

  void _updateZombie(int index, ZombieSpawnData zombie) {
    final zombies = List<ZombieSpawnData>.from(_zombies);
    zombies[index] = zombie;
    _updateZombies(zombies);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final info = RtidParser.parse(widget.rtid);
    final alias = info?.alias ?? '';

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
              widget.eventSubtitle,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => showEditorHelpDialog(
              context,
              title: widget.isGroundSpawner ? 'Ground spawn event' : 'Standard spawn event',
              sections: const [
                HelpSectionData(
                  title: 'Overview',
                  body: 'Configure zombies that spawn in this wave. Level 0 follows map tier.',
                ),
                HelpSectionData(
                  title: 'Row',
                  body: 'Row 0-4. Leave unset for random row.',
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
              if (widget.isGroundSpawner) _buildColumnRangeCard(theme),
              if (widget.isGroundSpawner) const SizedBox(height: 16),
              _buildZombieListCard(theme),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumnRangeCard(ThemeData theme) {
    final d = _data as SpawnZombiesFromGroundData;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Column range',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: d.columnStart.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Start',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      final n = int.tryParse(v);
                      if (n != null) {
                        _data = SpawnZombiesFromGroundData(
                          columnStart: n,
                          columnEnd: d.columnEnd,
                          additionalPlantFood: d.additionalPlantFood,
                          spawnPlantName: d.spawnPlantName,
                          zombies: d.zombies,
                        );
                        _sync();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: d.columnEnd.toString(),
                    decoration: const InputDecoration(
                      labelText: 'End',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      final n = int.tryParse(v);
                      if (n != null) {
                        _data = SpawnZombiesFromGroundData(
                          columnStart: d.columnStart,
                          columnEnd: n,
                          additionalPlantFood: d.additionalPlantFood,
                          spawnPlantName: d.spawnPlantName,
                          zombies: d.zombies,
                        );
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
    );
  }

  Widget _buildZombieListCard(BuildContext context, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Zombies (${_zombies.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => _addZombie(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add zombie'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._zombies.asMap().entries.map((e) {
              final idx = e.key;
              final z = e.value;
              return _buildZombieTile(context, theme, idx, z);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildZombieTile(BuildContext context, ThemeData theme, int index, ZombieSpawnData z) {
    final parsed = RtidParser.parse(z.type);
    final alias = parsed?.alias ?? z.type;
    final name = ResourceNames.lookup(context, ZombieRepository().getName(alias));

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 48,
                height: 48,
                child: () {
                  final zombie = ZombieRepository().getZombieById(alias);
                  final path = zombie?.iconAssetPath;
                  if (path != null) {
                    return AssetImageWidget(
                      assetPath: path,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    );
                  }
                  return Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.person,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  );
                }(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    alias,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 70,
              child: DropdownButtonFormField<int?>(
                value: z.row,
                decoration: const InputDecoration(
                  labelText: 'Row',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Any')),
                  ...List.generate(5, (i) => DropdownMenuItem(value: i, child: Text('$i'))),
                ],
                onChanged: (v) {
                  _updateZombie(index, ZombieSpawnData(type: z.type, level: z.level, row: v));
                },
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 70,
              child: TextFormField(
                initialValue: z.level?.toString() ?? '0',
                decoration: const InputDecoration(
                  labelText: 'Lvl',
                  isDense: true,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  final n = int.tryParse(v);
                  _updateZombie(
                    index,
                    ZombieSpawnData(
                      type: z.type,
                      level: n == 0 ? null : n,
                      row: z.row,
                    ),
                  );
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _removeZombie(index),
            ),
          ],
        ),
      ),
    );
  }
}
