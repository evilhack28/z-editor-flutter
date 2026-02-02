import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:z_editor/data/grid_item_repository.dart';
import 'package:z_editor/data/level_parser.dart';
import 'package:z_editor/data/pvz_models.dart';
import 'package:z_editor/widgets/asset_image.dart';
import 'package:z_editor/widgets/editor_components.dart';

/// Zombie potion event editor. Ported from Z-Editor-master ZombiePotionActionPropsEP.kt
class ZombiePotionEventScreen extends StatefulWidget {
  const ZombiePotionEventScreen({
    super.key,
    required this.rtid,
    required this.levelFile,
    required this.onChanged,
    required this.onBack,
    required this.onRequestGridItemSelection,
  });

  final String rtid;
  final PvzLevelFile levelFile;
  final VoidCallback onChanged;
  final VoidCallback onBack;
  final void Function(void Function(String) onSelected) onRequestGridItemSelection;

  @override
  State<ZombiePotionEventScreen> createState() => _ZombiePotionEventScreenState();
}

class _ZombiePotionEventScreenState extends State<ZombiePotionEventScreen> {
  late PvzObject _moduleObj;
  late ZombiePotionActionPropsData _data;
  int _selectedX = 0;
  int _selectedY = 0;

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
        objClass: 'ZombiePotionActionProps',
        objData: ZombiePotionActionPropsData().toJson(),
      );
      widget.levelFile.objects.add(_moduleObj);
    }
    try {
      _data = ZombiePotionActionPropsData.fromJson(
        Map<String, dynamic>.from(_moduleObj.objData as Map),
      );
    } catch (_) {
      _data = ZombiePotionActionPropsData();
    }
  }

  void _sync() {
    _moduleObj.objData = _data.toJson();
    widget.onChanged();
    setState(() {});
  }

  void _addPotion() {
    widget.onRequestGridItemSelection((typeName) {
      final newItem = ZombiePotionData(
        location: LocationData(x: _selectedX, y: _selectedY),
        type: typeName,
      );
      _data = ZombiePotionActionPropsData(
        potions: [..._data.potions, newItem],
      );
      _sync();
    });
  }

  void _removePotion(ZombiePotionData item) {
    _data = ZombiePotionActionPropsData(
      potions: _data.potions.where((p) => p != item).toList(),
    );
    _sync();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alias = LevelParser.extractAlias(widget.rtid);
    final sortedItems = List<ZombiePotionData>.from(_data.potions)
      ..sort((a, b) {
        final r = a.location.y.compareTo(b.location.y);
        return r != 0 ? r : a.location.x.compareTo(b.location.x);
      });

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
              'Event: Potion drop',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => showEditorHelpDialog(
              context,
              title: 'Potion drop event',
              sections: const [
                HelpSectionData(
                  title: 'Overview',
                  body: '此事件可以在场地上强行生成药水，能无视植物，可以作为障碍物生成事件的替代。',
                ),
                HelpSectionData(
                  title: 'Usage',
                  body: '选择网格位置，点击添加物品，选择药水类型。',
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
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selected position',
                                style: theme.textTheme.bodySmall,
                              ),
                              Text(
                                'R${_selectedY + 1} : C${_selectedX + 1}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          FilledButton.icon(
                            onPressed: _addPotion,
                            icon: const Icon(Icons.add),
                            label: const Text('Add item'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AspectRatio(
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
                            final isSelected =
                                row == _selectedY && col == _selectedX;
                            final cellItems = _data.potions
                                .where((p) =>
                                    p.location.x == col && p.location.y == row)
                                .toList();
                            final firstItem = cellItems.firstOrNull;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedX = col;
                                  _selectedY = row;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.colorScheme.primaryContainer
                                      : theme.colorScheme.surfaceContainerHighest,
                                  border: Border.all(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.outlineVariant,
                                  ),
                                ),
                                child: firstItem != null
                                    ? () {
                                        final iconPath = GridItemRepository
                                            .getIconPath(firstItem.type);
                                        return iconPath != null
                                            ? Center(
                                                child: AssetImageWidget(
                                                  assetPath: iconPath,
                                                  width: 24,
                                                  height: 24,
                                                  fit: BoxFit.contain,
                                                ),
                                              )
                                            : Center(
                                                child: Text(
                                                  firstItem.type.isNotEmpty
                                                      ? firstItem.type[0]
                                                      : '?',
                                                ),
                                              );
                                      }()
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Items (sorted by row)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...sortedItems.map((item) {
                final isSelected =
                    item.location.x == _selectedX && item.location.y == _selectedY;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: isSelected
                      ? theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.5,
                        )
                      : null,
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        _selectedX = item.location.x;
                        _selectedY = item.location.y;
                      });
                    },
                    leading: () {
                      final iconPath =
                          GridItemRepository.getIconPath(item.type);
                      return iconPath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: AssetImageWidget(
                                assetPath: iconPath,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                              ),
                            )
                          : CircleAvatar(
                            child: Text(
                              item.type.isNotEmpty
                                  ? item.type[0].toUpperCase()
                                  : '?',
                            ),
                          );
                    }(),
                    title: Text(GridItemRepository.getName(item.type)),
                    subtitle: Text(
                      'R${item.location.y + 1}:C${item.location.x + 1}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removePotion(item),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
