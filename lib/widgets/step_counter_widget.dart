import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class StepCounterWidget extends StatefulWidget {
  const StepCounterWidget({Key? key}) : super(key: key);

  @override
  State<StepCounterWidget> createState() => _StepCounterWidgetState();
}

class _StepCounterWidgetState extends State<StepCounterWidget> 
    with TickerProviderStateMixin {
  late Stream<StepCount> _stepCountStream;
  late StreamSubscription<StepCount> _stepCountSubscription;
  
  int _steps = 0;
  int _todaySteps = 0;
  int _baselineSteps = 0; // 新增：用來記錄重置時的基準步數
  String _status = '準備開始';
  bool _isListening = false;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  @override
  void initState() {
    super.initState();
    _initAnimations();
    _requestPermissions();
  }
  
  void _initAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }
  
  Future<void> _requestPermissions() async {
    var status = await Permission.activityRecognition.status;
    if (!status.isGranted) {
      await Permission.activityRecognition.request();
    }
    _initPedometer();
  }
  
  void _initPedometer() {
    try {
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountSubscription = _stepCountStream.listen(
        _onStepCount,
        onError: _onStepCountError,
      );
      setState(() {
        _isListening = true;
        _status = '正在監測步數';
      });
    } catch (e) {
      setState(() {
        _status = '無法啟動計步器';
      });
    }
  }
  
  void _onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps;
      // 修復：計算相對於基準點的步數
      _todaySteps = event.steps - _baselineSteps;
      // 確保步數不會是負數
      if (_todaySteps < 0) {
        _todaySteps = 0;
      }
      _status = '正在記錄您的步數';
    });
  }
  
  void _onStepCountError(error) {
    setState(() {
      _status = '計步器發生錯誤';
      _isListening = false;
    });
  }
  
  void _resetSteps() {
    setState(() {
      // 修復：將當前的絕對步數設為新的基準點
      _baselineSteps = _steps;
      _todaySteps = 0;
      _status = '步數已重置';
    });
    
    // 3秒後恢復正常狀態
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _status = _isListening ? '正在監測步數' : '計步器未啟動';
        });
      }
    });
  }
  
  @override
  void dispose() {
    _stepCountSubscription.cancel();
    _pulseController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4A90E2),
            const Color(0xFF7BB3F0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // 標題和狀態
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '今日步數',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isListening ? Icons.sensors : Icons.sensors_off,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isListening ? '監測中' : '未啟動',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 主要步數顯示
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isListening ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_walk,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_todaySteps',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        '步',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 20),
          
          // 狀態信息
          Text(
            _status,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 統計信息行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('預估距離', '${(_todaySteps * 0.6 / 1000).toStringAsFixed(1)} km'),
              _buildStatItem('消耗卡路里', '${(_todaySteps * 0.04).toStringAsFixed(0)} cal'),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 重置按鈕
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _resetSteps,
              icon: const Icon(Icons.refresh, color: Color(0xFF4A90E2)),
              label: const Text(
                '重置步數',
                style: TextStyle(
                  color: Color(0xFF4A90E2),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
