import 'package:machine_ui/Dtos/LightStatus.dart';

class LighterData {
  final LighterStatus lighterStatus;

  LighterData({required this.lighterStatus});

  factory LighterData.fromJson(Map<String, dynamic> json) {
    return LighterData(
      lighterStatus: json["lightStatus"] == 1
          ? LighterStatus.LightOff
          : LighterStatus.LightOn,
    );
  }
}