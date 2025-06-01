import 'package:flutter/material.dart';

class WaterTrackerPage extends StatefulWidget {
  const WaterTrackerPage({Key? key}) : super(key: key);

  @override
  State<WaterTrackerPage> createState() => _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<WaterTrackerPage> {
  // TODO: 實現喝水紀錄功能
  // 這裡是喝水紀錄功能的預留結構

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('喝水紀錄'),
        backgroundColor: const Color(0xFF3498DB),
        foregroundColor: Colors.white,
      ),
      body: const Center(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Icon(
      Icons.water_drop,
      size: 100,
      color: Color(0xFF3498DB),
    ),
    SizedBox(height: 20),
    Text(
    '喝水紀錄功能',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
        SizedBox(height: 10),
        Text(
          '此功能待開發',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
      ),
      ),
    );
  }
}
