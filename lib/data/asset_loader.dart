import 'dart:convert';
import 'package:flutter/services.dart';

/// Load JSON string from asset, handling UTF-16 LE BOM if present.
/// Some assets (e.g. Plants.json, Zombies.json) may be saved as UTF-16.
Future<String> loadJsonString(String path) async {
  final byteData = await rootBundle.load(path);
  final bytes = byteData.buffer.asUint8List();
  if (bytes.length >= 2 && bytes[0] == 0xFF && bytes[1] == 0xFE) {
    // UTF-16 LE BOM - decode as UTF-16
    final codeUnits = <int>[];
    for (var i = 2; i < bytes.length - 1; i += 2) {
      codeUnits.add(bytes[i] | (bytes[i + 1] << 8));
    }
    return String.fromCharCodes(codeUnits);
  }
  return utf8.decode(bytes);
}
