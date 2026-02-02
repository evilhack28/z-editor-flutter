import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:z_editor/data/pvz_models.dart';
import 'package:z_editor/data/rtid_parser.dart';

/// Sun dropper properties editor. Ported from Z-Editor-master SunDropperPropertiesEP.kt
class SunDropperPropertiesScreen extends StatefulWidget {
  const SunDropperPropertiesScreen({
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
  State<SunDropperPropertiesScreen> createState() =>
      _SunDropperPropertiesScreenState();
}

class _SunDropperPropertiesScreenState extends State<SunDropperPropertiesScreen> {
  late PvzObject _moduleObj;
  late SunDropperPropertiesData _data;
  late TextEditingController _initialDelayCtrl;
  late TextEditingController _countdownBaseCtrl;
  late TextEditingController _countdownMaxCtrl;
  late TextEditingController _countdownRangeCtrl;
  late TextEditingController _increasePerSunCtrl;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final info = RtidParser.parse(widget.rtid);
    final alias = info?.alias ?? '';
    final existing = widget.levelFile.objects.firstWhereOrNull(
      (o) => o.aliases?.contains(alias) == true,
    );
    if (existing != null) {
      _moduleObj = existing;
    } else {
      _moduleObj = PvzObject(
        aliases: [alias],
        objClass: 'SunDropperProperties',
        objData: SunDropperPropertiesData().toJson(),
      );
      widget.levelFile.objects.add(_moduleObj);
    }
    try {
      _data = SunDropperPropertiesData.fromJson(
        Map<String, dynamic>.from(_moduleObj.objData as Map),
      );
    } catch (_) {
      _data = SunDropperPropertiesData();
    }
    _initialDelayCtrl = TextEditingController(
      text: '${_data.initialSunDropDelay}',
    );
    _countdownBaseCtrl = TextEditingController(
      text: '${_data.sunCountdownBase}',
    );
    _countdownMaxCtrl = TextEditingController(
      text: '${_data.sunCountdownMax}',
    );
    _countdownRangeCtrl = TextEditingController(
      text: '${_data.sunCountdownRange}',
    );
    _increasePerSunCtrl = TextEditingController(
      text: '${_data.sunCountdownIncreasePerSun}',
    );
  }

  void _sync() {
    _moduleObj.objData = _data.toJson();
    widget.onChanged();
    setState(() {});
  }

  @override
  void dispose() {
    _initialDelayCtrl.dispose();
    _countdownBaseCtrl.dispose();
    _countdownMaxCtrl.dispose();
    _countdownRangeCtrl.dispose();
    _increasePerSunCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: const Text('Sun dropper'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sun drop parameters',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildNumberField(
                  controller: _initialDelayCtrl,
                  label: 'Initial drop delay',
                  onChanged: (v) {
                    final n = double.tryParse(v);
                    if (n != null) {
                      _data.initialSunDropDelay = n;
                      _sync();
                    }
                  },
                ),
                const SizedBox(height: 12),
                _buildNumberField(
                  controller: _countdownBaseCtrl,
                  label: 'Base countdown',
                  onChanged: (v) {
                    final n = double.tryParse(v);
                    if (n != null) {
                      _data.sunCountdownBase = n;
                      _sync();
                    }
                  },
                ),
                const SizedBox(height: 12),
                _buildNumberField(
                  controller: _countdownMaxCtrl,
                  label: 'Max countdown',
                  onChanged: (v) {
                    final n = double.tryParse(v);
                    if (n != null) {
                      _data.sunCountdownMax = n;
                      _sync();
                    }
                  },
                ),
                const SizedBox(height: 12),
                _buildNumberField(
                  controller: _countdownRangeCtrl,
                  label: 'Countdown range',
                  onChanged: (v) {
                    final n = double.tryParse(v);
                    if (n != null) {
                      _data.sunCountdownRange = n;
                      _sync();
                    }
                  },
                ),
                const SizedBox(height: 12),
                _buildNumberField(
                  controller: _increasePerSunCtrl,
                  label: 'Increase per sun',
                  onChanged: (v) {
                    final n = double.tryParse(v);
                    if (n != null) {
                      _data.sunCountdownIncreasePerSun = n;
                      _sync();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required void Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
