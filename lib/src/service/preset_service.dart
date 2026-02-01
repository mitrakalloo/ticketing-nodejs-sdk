import 'dart:convert';
import '../util/api_adapter.dart';

class PresetService {
  final APIAdapter _adapter;

  PresetService(this._adapter);

  Future<List<String>> countries() async {
    final response = await _adapter.get("/countries");
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['countries'] as List).map((e) => e.toString()).toList();
  }
}
