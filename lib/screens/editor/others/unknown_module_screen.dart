import 'package:flutter/material.dart';
import 'package:z_editor/widgets/editor_components.dart';

/// Unknown/unregistered module placeholder. Ported from Z-Editor-master UnknownEP.kt
class UnknownModuleScreen extends StatelessWidget {
  const UnknownModuleScreen({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: const Text('Module editor in development'),
        backgroundColor: theme.colorScheme.tertiary,
        foregroundColor: theme.colorScheme.onTertiary,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => showEditorHelpDialog(
              context,
              title: 'Unknown module',
              sections: const [
                HelpSectionData(
                  title: 'Overview',
                  body: 'Level files consist of root nodes and modules (PVZ2Object). Each object has aliases, objclass, and objdata. The root has no alias.',
                ),
                HelpSectionData(
                  title: 'Events',
                  body: 'The app parses modules by objclass. This module\'s objclass is not registered, so no dedicated editor exists yet. Support may be added later.',
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber,
                size: 80,
                color: theme.colorScheme.tertiary,
              ),
              const SizedBox(height: 16),
              Text(
                'No editor available for this module',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.tertiary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'This module is not registered in the level parser. It may have been added manually or the objclass was changed.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
