import 'package:flutter/material.dart';
import 'package:z_editor/data/challenge_repository.dart';
import 'package:z_editor/l10n/app_localizations.dart';

/// Challenge selection. Ported from Z-Editor-master ChallengeSelectionScreen.kt
class ChallengeSelectionScreen extends StatefulWidget {
  const ChallengeSelectionScreen({
    super.key,
    required this.onChallengeSelected,
    required this.onBack,
  });

  final void Function(ChallengeTypeInfo info) onChallengeSelected;
  final VoidCallback onBack;

  @override
  State<ChallengeSelectionScreen> createState() =>
      _ChallengeSelectionScreenState();
}

class _ChallengeSelectionScreenState extends State<ChallengeSelectionScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final challenges = _searchQuery.trim().isEmpty
        ? ChallengeRepository.allChallenges
        : ChallengeRepository.search(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: TextField(
          onChanged: (v) => setState(() => _searchQuery = v),
          decoration: InputDecoration(
            hintText: l10n?.search ?? 'Search',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _searchQuery = ''),
                  )
                : null,
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          return ListTile(
            leading: Icon(challenge.icon),
            title: Text(challenge.title),
            subtitle: Text(challenge.description),
            onTap: () => widget.onChallengeSelected(challenge),
          );
        },
      ),
    );
  }
}

