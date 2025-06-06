import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // 用來處理 Map 序列化

class WaterTrackerPage extends StatefulWidget {
  const WaterTrackerPage({Key? key}) : super(key: key);

  @override
  State<WaterTrackerPage> createState() => _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<WaterTrackerPage> {
  final TextEditingController _controller = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Map<String, double> _dailyRecords = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  String get _formattedDate =>
      "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

  void _addWater() {
    final input = _controller.text.trim();
    final double? amount = double.tryParse(input);
    if (amount == null || amount <= 0) {
      _showErrorDialog('請輸入有效的毫升數量');
      return;
    }

    setState(() {
      _dailyRecords[_formattedDate] = (_dailyRecords[_formattedDate] ?? 0) + amount;
      _controller.clear();
    });

    _saveData();
  }

  void _resetWater() {
    setState(() {
      _dailyRecords[_formattedDate] = 0;
    });
    _saveData();
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_dailyRecords);
    await prefs.setString('waterRecords', encoded);
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('waterRecords');
    if (stored != null) {
      setState(() {
        final Map<String, dynamic> decoded = jsonDecode(stored);
        _dailyRecords = decoded.map((key, value) => MapEntry(key, (value as num).toDouble()));
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('輸入錯誤'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todayAmount = _dailyRecords[_formattedDate] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('喝水紀錄', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3498DB),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              '右上角可選擇日期\n當前選擇日期：$_formattedDate',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Text(
              '當日總喝水量：${todayAmount.toStringAsFixed(0)} ml',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '輸入喝水量 (ml)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.local_drink),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              label: const Text('加入紀錄'),
              onPressed: _addWater,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3498DB),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 60),
                textStyle: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _resetWater,
              child: const Text('重置這天的紀錄'),
            ),
          ],
        ),
      ),
    );
  }
}
