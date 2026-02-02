import 'package:flutter/material.dart';
import 'package:z_editor/data/pvz_models.dart';
import 'package:z_editor/data/reference_repository.dart';
import 'package:z_editor/l10n/app_localizations.dart';

class ChallengeEditorScreen extends StatefulWidget {
  const ChallengeEditorScreen({
    super.key,
    required this.object,
    required this.onChanged,
  });

  final PvzObject object;
  final VoidCallback onChanged;

  @override
  State<ChallengeEditorScreen> createState() => _ChallengeEditorScreenState();
}

class _ChallengeEditorScreenState extends State<ChallengeEditorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.object.objClass),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildEditor(),
      ),
    );
  }

  Widget _buildEditor() {
    switch (widget.object.objClass) {
      case 'StarChallengeBeatTheLevelProps':
        return _BeatTheLevelEditor(object: widget.object, onChanged: widget.onChanged);
      case 'StarChallengeSaveMowerProps':
      case 'StarChallengePlantFoodNonuseProps':
        return const Center(child: Text('No properties to configure'));
      case 'StarChallengePlantSurviveProps':
        return _SimpleCountEditor(
          object: widget.object,
          field: 'Count',
          label: 'Count',
          onChanged: widget.onChanged,
        );
      case 'StarChallengeZombieDistanceProps':
        return _SimpleDoubleEditor(
          object: widget.object,
          field: 'TargetDistance',
          label: 'Target Distance',
          onChanged: widget.onChanged,
        );
      case 'StarChallengeSunProducedProps':
        return _SimpleCountEditor(
          object: widget.object,
          field: 'TargetSun',
          label: 'Target Sun',
          onChanged: widget.onChanged,
        );
      case 'StarChallengeSunUsedProps':
        return _SimpleCountEditor(
          object: widget.object,
          field: 'MaximumSun',
          label: 'Maximum Sun',
          onChanged: widget.onChanged,
        );
      case 'StarChallengeSpendSunHoldoutProps':
        return _SimpleCountEditor(
          object: widget.object,
          field: 'HoldoutSeconds',
          label: 'Holdout Seconds',
          onChanged: widget.onChanged,
        );
      case 'StarChallengeKillZombiesInTimeProps':
        return _KillZombiesInTimeEditor(object: widget.object, onChanged: widget.onChanged);
      case 'StarChallengeZombieSpeedProps':
        return _SimpleDoubleEditor(
          object: widget.object,
          field: 'SpeedModifier',
          label: 'Speed Modifier',
          onChanged: widget.onChanged,
        );
      case 'StarChallengeSunReducedProps':
        return _SimpleDoubleEditor(
          object: widget.object,
          field: 'sunModifier',
          label: 'Sun Modifier',
          onChanged: widget.onChanged,
        );
      case 'StarChallengePlantsLostProps':
        return _SimpleCountEditor(
          object: widget.object,
          field: 'MaximumPlantsLost',
          label: 'Maximum Plants Lost',
          onChanged: widget.onChanged,
        );
      case 'StarChallengeSimultaneousPlantsProps':
        return _SimpleCountEditor(
          object: widget.object,
          field: 'MaximumPlants',
          label: 'Maximum Plants',
          onChanged: widget.onChanged,
        );
      case 'StarChallengeUnfreezePlantsProps':
        return _SimpleCountEditor(
          object: widget.object,
          field: 'Count',
          label: 'Count',
          onChanged: widget.onChanged,
        );
      case 'StarChallengeBlowZombieProps':
        return _SimpleCountEditor(
          object: widget.object,
          field: 'Count',
          label: 'Count',
          onChanged: widget.onChanged,
        );
      case 'StarChallengeTargetScoreProps':
         return _SimpleCountEditor(
          object: widget.object,
          field: 'TargetScore',
          label: 'Target Score',
          onChanged: widget.onChanged,
        );
      case 'ProtectThePlantChallengeProperties':
        return _ProtectThePlantEditor(object: widget.object, onChanged: widget.onChanged);
      case 'ProtectTheGridItemChallengeProperties':
        return _ProtectTheGridItemEditor(object: widget.object, onChanged: widget.onChanged);
      case 'SunBombChallengeProperties':
        return _SunBombEditor(object: widget.object, onChanged: widget.onChanged);
      default:
        return const Text('Unknown challenge type');
    }
  }
}

class _BeatTheLevelEditor extends StatefulWidget {
  const _BeatTheLevelEditor({required this.object, required this.onChanged});
  final PvzObject object;
  final VoidCallback onChanged;

  @override
  State<_BeatTheLevelEditor> createState() => _BeatTheLevelEditorState();
}

class _BeatTheLevelEditorState extends State<_BeatTheLevelEditor> {
  late TextEditingController _descController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final data = widget.object.objData as Map<String, dynamic>;
    _descController = TextEditingController(text: data['Description'] as String? ?? '');
    _nameController = TextEditingController(text: data['DescriptiveName'] as String? ?? '');
  }

  void _save() {
    widget.object.objData['Description'] = _descController.text;
    widget.object.objData['DescriptiveName'] = _nameController.text;
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _descController,
          decoration: const InputDecoration(labelText: 'Description'),
          onChanged: (_) => _save(),
        ),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Descriptive Name'),
          onChanged: (_) => _save(),
        ),
      ],
    );
  }
}

class _SimpleCountEditor extends StatelessWidget {
  const _SimpleCountEditor({
    required this.object,
    required this.field,
    required this.label,
    required this.onChanged,
  });

  final PvzObject object;
  final String field;
  final String label;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final data = object.objData as Map<String, dynamic>;
    return TextFormField(
      initialValue: (data[field] ?? 0).toString(),
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      onChanged: (val) {
        data[field] = int.tryParse(val) ?? 0;
        onChanged();
      },
    );
  }
}

class _SimpleDoubleEditor extends StatelessWidget {
  const _SimpleDoubleEditor({
    required this.object,
    required this.field,
    required this.label,
    required this.onChanged,
  });

  final PvzObject object;
  final String field;
  final String label;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final data = object.objData as Map<String, dynamic>;
    return TextFormField(
      initialValue: (data[field] ?? 0.0).toString(),
      decoration: InputDecoration(labelText: label),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (val) {
        data[field] = double.tryParse(val) ?? 0.0;
        onChanged();
      },
    );
  }
}

class _KillZombiesInTimeEditor extends StatelessWidget {
  const _KillZombiesInTimeEditor({required this.object, required this.onChanged});
  final PvzObject object;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final data = object.objData as Map<String, dynamic>;
    return Column(
      children: [
        TextFormField(
          initialValue: (data['ZombiesToKill'] ?? 10).toString(),
          decoration: const InputDecoration(labelText: 'Zombies To Kill'),
          keyboardType: TextInputType.number,
          onChanged: (val) {
            data['ZombiesToKill'] = int.tryParse(val) ?? 10;
            onChanged();
          },
        ),
        TextFormField(
          initialValue: (data['Time'] ?? 10).toString(),
          decoration: const InputDecoration(labelText: 'Time (Seconds)'),
          keyboardType: TextInputType.number,
          onChanged: (val) {
            data['Time'] = int.tryParse(val) ?? 10;
            onChanged();
          },
        ),
      ],
    );
  }
}

class _ProtectThePlantEditor extends StatefulWidget {
  const _ProtectThePlantEditor({required this.object, required this.onChanged});
  final PvzObject object;
  final VoidCallback onChanged;

  @override
  State<_ProtectThePlantEditor> createState() => _ProtectThePlantEditorState();
}

class _ProtectThePlantEditorState extends State<_ProtectThePlantEditor> {
  late ProtectThePlantChallengePropertiesData _data;

  @override
  void initState() {
    super.initState();
    _data = ProtectThePlantChallengePropertiesData.fromJson(
      widget.object.objData as Map<String, dynamic>,
    );
  }

  void _save() {
    widget.object.objData = _data.toJson();
    widget.onChanged();
  }

  void _addPlant() {
    setState(() {
      _data.plants.add(ProtectPlantData());
      _save();
    });
  }

  void _removePlant(int index) {
    setState(() {
      _data.plants.removeAt(index);
      _save();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: _data.mustProtectCount.toString(),
          decoration: const InputDecoration(labelText: 'Must Protect Count (0 = All)'),
          keyboardType: TextInputType.number,
          onChanged: (val) {
            _data.mustProtectCount = int.tryParse(val) ?? 0;
            _save();
          },
        ),
        const SizedBox(height: 16),
        const Text('Protected Plants', style: TextStyle(fontWeight: FontWeight.bold)),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _data.plants.length,
          itemBuilder: (ctx, idx) {
            final item = _data.plants[idx];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: item.plantType,
                            decoration: const InputDecoration(labelText: 'Plant Type'),
                            onChanged: (val) {
                              item.plantType = val;
                              _save();
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removePlant(idx),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: item.gridX.toString(),
                            decoration: const InputDecoration(labelText: 'Grid X'),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              item.gridX = int.tryParse(val) ?? 0;
                              _save();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            initialValue: item.gridY.toString(),
                            decoration: const InputDecoration(labelText: 'Grid Y'),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              item.gridY = int.tryParse(val) ?? 0;
                              _save();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        FilledButton.icon(
          onPressed: _addPlant,
          icon: const Icon(Icons.add),
          label: const Text('Add Plant'),
        ),
      ],
    );
  }
}

class _ProtectTheGridItemEditor extends StatefulWidget {
  const _ProtectTheGridItemEditor({required this.object, required this.onChanged});
  final PvzObject object;
  final VoidCallback onChanged;

  @override
  State<_ProtectTheGridItemEditor> createState() => _ProtectTheGridItemEditorState();
}

class _ProtectTheGridItemEditorState extends State<_ProtectTheGridItemEditor> {
  late ProtectTheGridItemChallengePropertiesData _data;

  @override
  void initState() {
    super.initState();
    _data = ProtectTheGridItemChallengePropertiesData.fromJson(
      widget.object.objData as Map<String, dynamic>,
    );
  }

  void _save() {
    widget.object.objData = _data.toJson();
    widget.onChanged();
  }

  void _addItem() {
    setState(() {
      _data.gridItems.add(ProtectGridItemData());
      _save();
    });
  }

  void _removeItem(int index) {
    setState(() {
      _data.gridItems.removeAt(index);
      _save();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: _data.description,
          decoration: const InputDecoration(labelText: 'Description'),
          onChanged: (val) {
            _data.description = val;
            _save();
          },
        ),
        TextFormField(
          initialValue: _data.mustProtectCount.toString(),
          decoration: const InputDecoration(labelText: 'Must Protect Count'),
          keyboardType: TextInputType.number,
          onChanged: (val) {
            _data.mustProtectCount = int.tryParse(val) ?? 0;
            _save();
          },
        ),
        const SizedBox(height: 16),
        const Text('Protected Grid Items', style: TextStyle(fontWeight: FontWeight.bold)),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _data.gridItems.length,
          itemBuilder: (ctx, idx) {
            final item = _data.gridItems[idx];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: item.gridItemType,
                            decoration: const InputDecoration(labelText: 'Grid Item Type'),
                            onChanged: (val) {
                              item.gridItemType = val;
                              _save();
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeItem(idx),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: item.gridX.toString(),
                            decoration: const InputDecoration(labelText: 'Grid X'),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              item.gridX = int.tryParse(val) ?? 0;
                              _save();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            initialValue: item.gridY.toString(),
                            decoration: const InputDecoration(labelText: 'Grid Y'),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              item.gridY = int.tryParse(val) ?? 0;
                              _save();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        FilledButton.icon(
          onPressed: _addItem,
          icon: const Icon(Icons.add),
          label: const Text('Add Grid Item'),
        ),
      ],
    );
  }
}

class _SunBombEditor extends StatefulWidget {
  const _SunBombEditor({required this.object, required this.onChanged});
  final PvzObject object;
  final VoidCallback onChanged;

  @override
  State<_SunBombEditor> createState() => _SunBombEditorState();
}

class _SunBombEditorState extends State<_SunBombEditor> {
  late SunBombChallengeData _data;

  @override
  void initState() {
    super.initState();
    _data = SunBombChallengeData.fromJson(
      widget.object.objData as Map<String, dynamic>,
    );
  }

  void _save() {
    widget.object.objData = _data.toJson();
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: _data.plantBombExplosionRadius.toString(),
          decoration: const InputDecoration(labelText: 'Plant Bomb Radius'),
          keyboardType: TextInputType.number,
          onChanged: (val) {
            _data.plantBombExplosionRadius = int.tryParse(val) ?? 25;
            _save();
          },
        ),
        TextFormField(
          initialValue: _data.zombieBombExplosionRadius.toString(),
          decoration: const InputDecoration(labelText: 'Zombie Bomb Radius'),
          keyboardType: TextInputType.number,
          onChanged: (val) {
            _data.zombieBombExplosionRadius = int.tryParse(val) ?? 80;
            _save();
          },
        ),
        TextFormField(
          initialValue: _data.plantDamage.toString(),
          decoration: const InputDecoration(labelText: 'Plant Damage'),
          keyboardType: TextInputType.number,
          onChanged: (val) {
            _data.plantDamage = int.tryParse(val) ?? 1000;
            _save();
          },
        ),
        TextFormField(
          initialValue: _data.zombieDamage.toString(),
          decoration: const InputDecoration(labelText: 'Zombie Damage'),
          keyboardType: TextInputType.number,
          onChanged: (val) {
            _data.zombieDamage = int.tryParse(val) ?? 500;
            _save();
          },
        ),
      ],
    );
  }
}
