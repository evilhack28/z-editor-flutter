import 'package:flutter/material.dart';
import 'package:z_editor/data/module_registry.dart';
import 'package:z_editor/l10n/app_localizations.dart';

class ModuleSelectionScreen extends StatelessWidget {
  const ModuleSelectionScreen({
    super.key,
    required this.existingObjClasses,
  });

  final Set<String> existingObjClasses;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allModules = ModuleRegistry.getAllModules();
    
    // Filter modules that are already present and don't allow multiple instances
    final availableModules = allModules.where((m) {
      if (m.allowMultiple) return true;
      return !existingObjClasses.contains(m.objClass);
    }).toList();

    // Group by category
    final Map<ModuleCategory, List<ModuleMetadata>> groupedModules = {};
    for (var m in availableModules) {
      groupedModules.putIfAbsent(m.category, () => []).add(m);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Module'),
      ),
      body: ListView(
        children: [
          _buildCategorySection(context, 'Base Modules', groupedModules[ModuleCategory.base]),
          _buildCategorySection(context, 'Game Modes', groupedModules[ModuleCategory.mode]),
          _buildCategorySection(context, 'Scene Settings', groupedModules[ModuleCategory.scene]),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, String title, List<ModuleMetadata>? modules) {
    if (modules == null || modules.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ...modules.map((m) => ListTile(
          leading: Icon(m.icon),
          title: Text(m.getTitle(context)),
          subtitle: Text(m.getDescription(context)),
          onTap: () {
            Navigator.pop(context, m);
          },
        )),
        const Divider(),
      ],
    );
  }
}
