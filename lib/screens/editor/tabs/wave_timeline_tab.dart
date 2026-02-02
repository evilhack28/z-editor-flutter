import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:z_editor/data/level_parser.dart';
import 'package:z_editor/data/pvz_models.dart';
import 'package:z_editor/data/wave_point_analysis.dart';
import 'package:z_editor/l10n/app_localizations.dart';
import 'package:z_editor/widgets/editor_components.dart';

/// Wave timeline tab with events. Ported from Z-Editor-master WaveTimelineTab.kt
class WaveTimelineTab extends StatefulWidget {
  const WaveTimelineTab({
    super.key,
    required this.levelFile,
    required this.parsed,
    required this.onChanged,
    required this.onEditEvent,
    required this.onAddEvent,
    required this.onEditWaveManagerSettings,
  });

  final PvzLevelFile levelFile;
  final ParsedLevelData parsed;
  final VoidCallback onChanged;
  final void Function(String rtid, int waveIndex) onEditEvent;
  final void Function(int waveIndex) onAddEvent;
  final VoidCallback onEditWaveManagerSettings;

  @override
  State<WaveTimelineTab> createState() => _WaveTimelineTabState();
}

class _WaveTimelineTabState extends State<WaveTimelineTab> {
  int _pointsAtWave(WaveManagerModuleData module, int waveIndex) {
    if (module.dynamicZombies.isEmpty) return 0;
    final g = module.dynamicZombies.first;
    final offset = waveIndex - g.startingWave;
    final incCount = offset < 0 ? 0 : offset;
    return g.startingPoints + g.pointIncrement * incCount;
  }

  void _syncWaves() {
    final wm = widget.parsed.waveManager;
    if (wm is! WaveManagerData) return;
    final wmObj = widget.levelFile.objects.firstWhereOrNull(
      (o) => o.objClass == 'WaveManagerProperties',
    );
    if (wmObj != null) {
      wmObj.objData = wm.toJson();
      widget.onChanged();
    }
  }

  void _addWave() {
    final wm = widget.parsed.waveManager;
    if (wm is! WaveManagerData) return;
    wm.waves.add(<String>[]);
    wm.waveCount = wm.waves.length;
    _syncWaves();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wm = widget.parsed.waveManager is WaveManagerData
        ? widget.parsed.waveManager as WaveManagerData
        : null;
    final module = widget.parsed.waveModule is WaveManagerModuleData
        ? widget.parsed.waveModule as WaveManagerModuleData
        : null;
    final objectMap = widget.parsed.objectMap;

    if (wm == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                l10n?.noWaveManager ?? 'No wave manager found',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n?.noWaveManagerHint ??
                    'This level has wave management but no WaveManagerProperties object.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final waves = wm.waves;
    final interval = wm.flagWaveInterval <= 0 ? 10 : wm.flagWaveInterval;

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Icon(Icons.lightbulb_outline, color: Theme.of(context).colorScheme.secondary),
            title: Text(
              l10n?.waveTimelineHint ?? 'Tap event to edit. Tap + to add event.',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              l10n?.waveTimelineHintDetail ?? 'Swipe wave left to manage, right to delete.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Icon(Icons.tune, color: Theme.of(context).colorScheme.tertiary),
            title: Text(
              l10n?.waveManagerSettings ?? 'Wave manager settings',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${l10n?.flagInterval ?? "Flag interval"}: $interval',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: widget.onEditWaveManagerSettings,
          ),
        ),
        const SizedBox(height: 16),
        if (waves.isEmpty)
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    l10n?.noWaves ?? 'No waves',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n?.addFirstWave ?? 'Add the first wave.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          )
        else
          ...List.generate(waves.length, (index) {
            final waveIndex = index + 1;
            final waveEvents = waves[index];
            final isFlagWave =
                waveIndex % interval == 0 || waveIndex == waves.length;
            final points = module != null
                ? _pointsAtWave(module, waveIndex)
                : 0;
            final expectation = module != null && points > 0
                ? WavePointAnalysis.calculateExpectation(points, widget.parsed)
                : <String, double>{};

            return Dismissible(
              key: ValueKey('wave_$index'),
              direction: DismissDirection.horizontal,
              confirmDismiss: (dir) async {
                if (dir == DismissDirection.endToStart) {
                  return await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('${l10n?.deleteWave ?? "Delete"} ${l10n?.waveLabel ?? "Wave"} $waveIndex?'),
                      content: Text(
                        l10n?.deleteWaveConfirm(waveEvents.length) ??
                            'This will remove this wave and its ${waveEvents.length} events.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(l10n?.cancel ?? 'Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: FilledButton.styleFrom(
                            backgroundColor: Theme.of(ctx).colorScheme.error,
                          ),
                          child: Text(l10n?.delete ?? 'Delete'),
                        ),
                      ],
                    ),
                  );
                }
                return false;
              },
              onDismissed: (dir) {
                if (dir == DismissDirection.endToStart) {
                  wm.waves.removeAt(index);
                  wm.waveCount = wm.waves.length;
                  _syncWaves();
                  setState(() {});
                }
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${l10n?.waveLabel ?? "Wave"} $waveIndex',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              if (isFlagWave)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.flag,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              const Spacer(),
                              if (points > 0)
                                GestureDetector(
                                  onTap: () => _showExpectationDialog(context, waveIndex, points),
                                  child: Chip(
                                    label: Text('${l10n?.pointsLabel ?? "Points"} $points'),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ...waveEvents.map((rtid) {
                                final alias = LevelParser.extractAlias(rtid);
                                final obj = objectMap[alias];
                                final isInvalid = obj == null;
                                return EventChipWidget(
                                  key: ValueKey(rtid),
                                  rtid: rtid,
                                  objectMap: objectMap,
                                  onTap: () => widget.onEditEvent(rtid, waveIndex),
                                );
                              }),
                              Material(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(6),
                                child: InkWell(
                                  onTap: () => widget.onAddEvent(waveIndex),
                                  borderRadius: BorderRadius.circular(6),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.add, size: 16, color: Theme.of(context).colorScheme.primary),
                                        const SizedBox(width: 4),
                                        Text(
                                          l10n?.addEvent ?? 'Add event',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (waveEvents.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                l10n?.emptyWave ?? 'Empty wave',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: FilledButton.icon(
              onPressed: _addWave,
              icon: const Icon(Icons.add),
              label: Text(l10n?.addWave ?? 'Add wave'),
            ),
          ),
        ),
      ],
    );
  }

  void _showExpectationDialog(BuildContext context, int waveIndex, int points) {
    final expectation = WavePointAnalysis.calculateExpectation(
      points,
      widget.parsed,
    );
    final sorted = expectation.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.take(5).where((e) => e.value > 0.05).toList();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${AppLocalizations.of(ctx)?.waveLabel ?? "Wave"} $waveIndex ${AppLocalizations.of(ctx)?.expectation ?? "Expectation"}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${AppLocalizations.of(ctx)?.pointsLabel ?? "Points"}: $points'),
              const SizedBox(height: 16),
              if (top.isEmpty)
                Text(
                  AppLocalizations.of(ctx)?.noDynamicZombies ?? 'No dynamic zombies',
                  style: Theme.of(ctx).textTheme.bodySmall,
                )
              else
                ...top.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.key),
                          Text(e.value.toStringAsFixed(2)),
                        ],
                      ),
                    )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(ctx)?.close ?? 'Close'),
          ),
        ],
      ),
    );
  }
}
