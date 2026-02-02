import 'package:flutter/material.dart';
import 'package:z_editor/data/zombie_repository.dart';
import 'package:z_editor/l10n/app_localizations.dart';
import 'package:z_editor/l10n/resource_names.dart';
import 'package:z_editor/widgets/asset_image.dart';

/// Zombie selection. Ported from Z-Editor-master ZombieSelectionScreen.kt
class ZombieSelectionScreen extends StatefulWidget {
  const ZombieSelectionScreen({
    super.key,
    this.multiSelect = false,
    required this.onZombieSelected,
    this.onMultiZombieSelected,
    required this.onBack,
  });

  final bool multiSelect;
  final void Function(String) onZombieSelected;
  final void Function(List<String>)? onMultiZombieSelected;
  final VoidCallback onBack;

  @override
  State<ZombieSelectionScreen> createState() => _ZombieSelectionScreenState();
}

class _ZombieSelectionScreenState extends State<ZombieSelectionScreen> {
  String _searchQuery = '';
  final Set<String> _selectedIds = {};
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    ZombieRepository().init().then((_) {
      if (mounted) setState(() => _isLoaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final repo = ZombieRepository();
    final zombies = _searchQuery.isEmpty
        ? repo.allZombies
        : repo.allZombies
            .where((z) =>
                z.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                z.id.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: Text(l10n?.selectZombie ?? 'Select zombie'),
        actions: [
          if (widget.multiSelect && _selectedIds.isNotEmpty)
            TextButton(
              onPressed: () {
                widget.onMultiZombieSelected?.call(_selectedIds.toList());
                widget.onBack();
              },
              child: Text(l10n?.done ?? 'Done'),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: l10n?.searchZombie ?? 'Search zombie',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          Expanded(
            child: !_isLoaded
                ? const Center(child: CircularProgressIndicator())
                : zombies.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n?.noZombieFound ?? 'No zombie found',
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 80,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: zombies.length,
                        itemBuilder: (_, i) {
                          final zombie = zombies[i];
                          final isSelected =
                              _selectedIds.contains(zombie.id);
                          return _ZombieGridItem(
                            zombie: zombie,
                            isSelected: isSelected,
                            onTap: () {
                              if (widget.multiSelect) {
                                setState(() {
                                  if (isSelected) {
                                    _selectedIds.remove(zombie.id);
                                  } else {
                                    _selectedIds.add(zombie.id);
                                  }
                                });
                              } else {
                                widget.onZombieSelected(zombie.id);
                                widget.onBack();
                              }
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _ZombieGridItem extends StatelessWidget {
  const _ZombieGridItem({
    required this.zombie,
    required this.isSelected,
    required this.onTap,
  });

  final ZombieInfo zombie;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconPath = zombie.iconAssetPath;

    return Material(
      color: isSelected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: iconPath != null
                      ? AssetImageWidget(
                          assetPath: iconPath,
                          altCandidates: imageAltCandidates(iconPath),
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.android,
                          size: 48,
                          color: theme.colorScheme.outline,
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ResourceNames.lookup(context, zombie.name),
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                zombie.id,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
