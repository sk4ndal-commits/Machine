import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:machine_ui/Dtos/LightData.dart';

class Lighterservice {
 
  final Uri getUri = Uri.parse("http://localhost:5027/api/lighter");
  final Uri toggleUri = Uri.parse("http://localhost:5027/api/lighter/toggle");

  Future<LighterData> fetchStatus() async {
    final response = await http.get(getUri);
    
    if (response.statusCode == 200) {
      return LighterData.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception("Failed to get lighter data");
    }
  }

  Future<LighterData> toggleStatus() async {
    final response = await http.post(toggleUri);

    if (response.statusCode == 200) {
      return LighterData.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception("Failed to toggle lighter data");
    }
  }
}
