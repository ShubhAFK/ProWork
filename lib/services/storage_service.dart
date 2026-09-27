import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project_data.dart';

class StorageService {
  static const String _keyProjectData = 'prowork_project_data_v1';

  Future<ProjectData> loadProjectData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawJson = prefs.getString(_keyProjectData);
      if (rawJson != null && rawJson.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(rawJson) as Map<String, dynamic>;
        return ProjectData.fromJson(decoded);
      }
    } catch (_) {}
    return ProjectData.createInitialSeed();
  }

  Future<void> saveProjectData(ProjectData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawJson = jsonEncode(data.toJson());
      await prefs.setString(_keyProjectData, rawJson);
    } catch (_) {}
  }
}
