import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';

class MetronomePage extends StatefulWidget {
  const MetronomePage({Key? key}) : super(key: key);

  @override
  State<MetronomePage> createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  int _currentBeat = -1;

  
  int _bpm = 180;
  int _beatsPerMeasure = 4;

  late Duration _interval;

  bool _isPlaying = false;

  final TextEditingController _bpmController = TextEditingController();
  final TextEditingController _beatsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bpmController.text = _bpm.toString();
    _beatsController.text = _beatsPerMeasure.toString();
    _updateInterval();

    _ticker = createTicker((elapsed) {
      // 計算目前節拍索引
      int beat = (elapsed.inMilliseconds ~/ _interval.inMilliseconds) % _beatsPerMeasure;
      if (beat != _currentBeat) {
        _currentBeat = beat;
        _playTick(); // 播放點擊聲
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _bpmController.dispose();
    _beatsController.dispose();
    super.dispose();
  }

  // 更新節拍間隔時間（毫秒）
  void _updateInterval() {
    _interval = Duration(milliseconds: (60000 / _bpm).round());
  }

  // 播放系統點擊聲
  void _playTick() {
    SystemSound.play(SystemSoundType.click);
  }

  // 開始或停止節拍器
  void _togglePlay() {
    if (_isPlaying) {
      _ticker.stop();
      _currentBeat = -1;
    } else {
      _ticker.start();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  // BPM 輸入改變時觸發
  void _onBpmChanged(String value) {
    final bpm = int.tryParse(value);
    if (bpm == null) return;

    // 限制 BPM 範圍在 30 到 240 之間
    int clamped = bpm.clamp(30, 240);

    // 如果輸入超出範圍，修正輸入框內容
    if (clamped.toString() != value) {
      _bpmController.text = clamped.toString();
      _bpmController.selection = TextSelection.fromPosition(
          TextPosition(offset: _bpmController.text.length));
    }

    setState(() {
      _bpm = clamped;
      _updateInterval();
      if (_isPlaying) {
        _ticker.stop();
        _ticker.start();
      }
    });
  }

  // 根據背景顏色決定文字顏色（亮色背景用黑字，暗色背景用白字）
  Color _textColorForBackground(Color bg) {
    return bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  // 建立節拍點點 Widget
  Widget _buildBeatDot(int index) {
    bool isActive = _currentBeat == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: isActive ? 30 : 20,
      height: isActive ? 30 : 20,
      decoration: BoxDecoration(
        color: isActive ? Colors.purple : Colors.purple.shade200,
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
          BoxShadow(
            color: Colors.purple.withOpacity(0.6),
            blurRadius: 10,
            spreadRadius: 3,
          )
        ]
            : [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color btnColor = Colors.purple;
    Color btnTextColor = _textColorForBackground(btnColor);

    return Scaffold(
      appBar: AppBar(
        title: const Text('超慢跑節拍器'),
        backgroundColor: btnColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 節拍點點動畫，數量依 _beatsPerMeasure 決定
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_beatsPerMeasure, (index) => _buildBeatDot(index)),
            ),
            const SizedBox(height: 40),

            Text(
              _isPlaying ? '節拍中...' : '已停止',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: btnColor,
              ),
            ),

            const SizedBox(height: 30),

            // BPM 與拍子數輸入框並排
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _bpmController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                    decoration: const InputDecoration(
                      labelText: 'BPM',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: _onBpmChanged,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _beatsController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                    decoration: const InputDecoration(
                      labelText: '拍子數',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      if (value.isEmpty) return;
                      final beats = int.tryParse(value);
                      if (beats == null) return;

                      // 限制拍子數範圍 1~12
                      int clamped = beats.clamp(1, 12);

                      // 如果輸入超出範圍，修正輸入框內容
                      if (clamped.toString() != value) {
                        _beatsController.text = clamped.toString();
                        _beatsController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _beatsController.text.length));
                      }

                      setState(() {
                        _beatsPerMeasure = clamped;
                        _currentBeat = -1; // 重置目前節拍
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _togglePlay,
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                foregroundColor: btnTextColor,
                minimumSize: const Size(160, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(_isPlaying ? '停止' : '開始', style: const TextStyle(fontSize: 24)),
            ),

            const SizedBox(height: 30),

            // 超慢跑模式提示文字（非按鈕）
            Text(
              '超慢跑模式：180 BPM，2 拍',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
