import 'package:flutter/material.dart';
import 'package:z_editor/data/pvz_models.dart';
import 'package:z_editor/data/rtid_parser.dart';

class StartingPlantfoodModuleScreen extends StatefulWidget {
  const StartingPlantfoodModuleScreen({
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
  State<StartingPlantfoodModuleScreen> createState() => _StartingPlantfoodModuleScreenState();
}

class _StartingPlantfoodModuleScreenState extends State<StartingPlantfoodModuleScreen> {
  late PvzObject _moduleObj;
  late LevelMutatorStartingPlantfoodPropsData _data;
  late TextEditingController _pfController;
  late TextEditingController _iconTextController;
  late TextEditingController _iconImageController;

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
        objClass: 'LevelMutatorStartingPlantfoodProps',
        objData: LevelMutatorStartingPlantfoodPropsData().toJson(),
      ),
    );
    try {
      _data = LevelMutatorStartingPlantfoodPropsData.fromJson(
        Map<String, dynamic>.from(_moduleObj.objData as Map),
      );
    } catch (_) {
      _data = LevelMutatorStartingPlantfoodPropsData();
    }
    _pfController = TextEditingController(text: '${_data.startingPlantfoodOverride}');
    _iconTextController = TextEditingController(text: _data.iconText);
    _iconImageController = TextEditingController(text: _data.iconImage);
  }

  void _save() {
    _moduleObj.objData = _data.toJson();
    widget.onChanged();
  }

  @override
  void dispose() {
    _pfController.dispose();
    _iconTextController.dispose();
    _iconImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Override Starting Plantfood'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _save();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Starting Plantfood Override', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _pfController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter starting plantfood (0+)',
              ),
              onChanged: (value) {
                final parsed = int.tryParse(value) ?? _data.startingPlantfoodOverride;
                setState(() {
                  _data.startingPlantfoodOverride = parsed.clamp(0, 999);
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Icon Text'),
            const SizedBox(height: 8),
            TextField(
              controller: _iconTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Optional label',
              ),
              onChanged: (v) {
                setState(() {
                  _data.iconText = v;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Icon Image'),
            const SizedBox(height: 8),
            TextField(
              controller: _iconImageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'IMAGE_... resource id',
              ),
              onChanged: (v) {
                setState(() {
                  _data.iconImage = v;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
