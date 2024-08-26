
import 'dart:async' as dart_async;

import 'package:flutter/material.dart';
import 'package:machine_ui/Dtos/LightStatus.dart';
import 'package:machine_ui/Services/LighterService.dart';
import 'package:signalr_client_core/signalr_client.dart' as signal_r;

import 'Dtos/LightData.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: LighterPage()
    );
  }
}

class LighterPage extends StatefulWidget {
  const LighterPage({super.key});

  @override
  _LighterPageState createState() => _LighterPageState();
}

class _LighterPageState extends State<LighterPage>
    with SingleTickerProviderStateMixin {

  Future<LighterData>? _lighterData;
  late signal_r.HubConnection _hubConnection;

  @override
  void initState() {
    super.initState();
    _lighterData = Lighterservice().fetchStatus();

    _hubConnection = signal_r.HubConnectionBuilder()
      .withUrl("http://localhost:5027/stateHub")
      .build();

    _hubConnection.on("StatusUpdated", _handleStateChanged);

    _startSignalR();
  }

  @override
  void dispose() {
    _hubConnection.stop();
    super.dispose();
  }

  Future<void> _handleStateChanged(List<Object?>? args) async {

      if (args!.isNotEmpty) {
        final newState = args[0] == 1
                ? LighterData(lighterStatus: LighterStatus.LightOff)
                : LighterData(lighterStatus: LighterStatus.LightOn);

        setState(() {
          _lighterData = Future.value(newState);
        });
      }
  }

  Future<void> _startSignalR() async {
    await _hubConnection.start();
  }

  Future<void> _toggleLightStatus() async {
    try{
      final newLightData = await Lighterservice().toggleStatus();
      setState(() {
        _lighterData = Future.value(newLightData);
      });
    }
    catch (error) {
      print('Error toggling light status $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LighterStatusWidget(futureData: _lighterData),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _toggleLightStatus,
                child: const Text('Toggle light status'))
          ],
        ),
      ),
    );
  }
}

class LighterStatusWidget extends StatelessWidget {

  final Future<LighterData>? futureData;

  const LighterStatusWidget({super.key, required this.futureData});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LighterData>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          else if (snapshot.hasData) {
            final lightstatus = snapshot.data!.lighterStatus;
            return ShowData(lightstatus: lightstatus);
          }
          else {
            return const Text('No data available');
          }
        }
    );
  }
}


class ShowData extends StatelessWidget {
  final LighterStatus lightstatus;

  const ShowData({super.key, required this.lightstatus});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: lightstatus == LighterStatus.LightOn ? Colors.yellow : Colors.black,
        ),
      ),
    );
  }
}
