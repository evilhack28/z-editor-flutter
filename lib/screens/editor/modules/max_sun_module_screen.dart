import 'package:flutter/material.dart';
import 'package:z_editor/data/pvz_models.dart';
import 'package:z_editor/data/rtid_parser.dart';
 
class MaxSunModuleScreen extends StatefulWidget {
  const MaxSunModuleScreen({
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
  State<MaxSunModuleScreen> createState() => _MaxSunModuleScreenState();
}
 
class _MaxSunModuleScreenState extends State<MaxSunModuleScreen> {
  late PvzObject _moduleObj;
  late LevelMutatorMaxSunPropsData _data;
  late TextEditingController _sunController;
 
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
        objClass: 'LevelMutatorMaxSunProps',
        objData: LevelMutatorMaxSunPropsData().toJson(),
      ),
    );
    try {
      _data = LevelMutatorMaxSunPropsData.fromJson(
        Map<String, dynamic>.from(_moduleObj.objData as Map),
      );
    } catch (_) {
      _data = LevelMutatorMaxSunPropsData();
    }
    _sunController = TextEditingController(text: '${_data.maxSunOverride}');
  }
 
  void _save() {
    _moduleObj.objData = _data.toJson();
    widget.onChanged();
  }
 
  @override
  void dispose() {
    _sunController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Override Max Sun'),
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
            const Text('Max Sun Override', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _sunController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter max sun (e.g., 9900)',
              ),
              onChanged: (value) {
                final parsed = int.tryParse(value) ?? _data.maxSunOverride;
                setState(() {
                  _data.maxSunOverride = parsed.clamp(0, 99999);
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Icon Text'),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: _data.iconText),
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
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Icon Image'),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: _data.iconImage),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
