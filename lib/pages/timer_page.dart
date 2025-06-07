import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(FitnessTimerApp());

class FitnessTimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '健身計時器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimerPage(),
    );
  }
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int initialTime = 30;
  int remainingTime = 30;
  Timer? timer;
  bool isRunning = false;
  TextEditingController inputController = TextEditingController();

  void startTimer() {
    if (timer != null && timer!.isActive) return;

    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          t.cancel();
          isRunning = false;
        }
      });
    });

    setState(() {
      isRunning = true;
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      remainingTime = initialTime;
      isRunning = false;
    });
  }

  void setCustomTime() {
    int? inputSeconds = int.tryParse(inputController.text);
    if (inputSeconds != null && inputSeconds > 0) {
      timer?.cancel();
      setState(() {
        initialTime = inputSeconds;
        remainingTime = inputSeconds;
        isRunning = false;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('健身計時器', style: TextStyle(fontSize: 26))),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$remainingTime 秒',
              style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? pauseTimer : startTimer,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                    textStyle: TextStyle(fontSize: 28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(isRunning ? '暫停' : '開始'),
                ),
                SizedBox(width: 30),
                ElevatedButton(
                  onPressed: resetTimer,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                    textStyle: TextStyle(fontSize: 28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text('重置'),
                ),
              ],
            ),
            SizedBox(height: 50),
            TextField(
              controller: inputController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 24),
              decoration: InputDecoration(
                labelText: '輸入倒數秒數',
                labelStyle: TextStyle(fontSize: 22),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: setCustomTime,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                textStyle: TextStyle(fontSize: 28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text('設定'),
            ),
          ],
        ),
      ),
    );
  }
}
