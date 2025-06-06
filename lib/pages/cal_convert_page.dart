import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CalorieCalculatorPage extends StatefulWidget {
  const CalorieCalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalorieCalculatorPage> createState() => _CalorieCalculatorPageState();
}

class _CalorieCalculatorPageState extends State<CalorieCalculatorPage> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _durationController = TextEditingController();

  String _heightUnit = 'cm';
  String _weightUnit = 'kg';
  final List<String> _genderOptions = ['male', 'female'];
  String _selectedGender = 'male';
  final List<int> _bpmOptions = [150, 180];
  int _selectedBpm = 180;

  String _result = '';

  void _showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 18,
    );
  }

  void _calculateCalories() {
    if (_heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _durationController.text.isEmpty) {
      _showToast("請填寫所有欄位！");
      return;
    }

    try {
      double height = double.parse(_heightController.text);
      double weight = double.parse(_weightController.text);
      int age = int.parse(_ageController.text);
      double duration = double.parse(_durationController.text);

      if (_heightUnit == 'ft') height *= 30.48;
      if (_weightUnit == 'lb') weight *= 0.453592;

      double bmr;
      if (_selectedGender == 'male') {
        bmr = 10 * weight + 6.25 * height - 5 * age + 5;
      } else {
        bmr = 10 * weight + 6.25 * height - 5 * age - 161;
      }

      double met = 6.0;
      double caloriesBurned = weight * met * (duration / 60);

      setState(() {
        _result = '基礎代謝率 (BMR)：${bmr.toStringAsFixed(1)} kcal/日\n'
            '超慢跑消耗：約 ${caloriesBurned.toStringAsFixed(1)} kcal';
      });
    } catch (e) {
      _showToast("請確認輸入格式正確！");
    }
  }

  Widget _buildLabeledInput({
    required String label,
    required TextEditingController controller,
    required String unit,
    required List<String> unitOptions,
    required Function(String?) onUnitChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFF39C12), width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: 70,
          child: DropdownButton<String>(
            isExpanded: true,
            value: unit,
            onChanged: onUnitChanged,
            items: unitOptions.map((u) {
              return DropdownMenuItem(value: u, child: Text(u));
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _GenderAgeSelector() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedGender,
            //style: const TextStyle(fontSize: 10),
            decoration: InputDecoration(
              labelText: '性別',
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFF39C12), width: 2),
              ),
            ),
            items: _genderOptions.map((gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(gender == 'male' ? '男性' : '女性'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedGender = value!;
              });
            },
          ),
        ),

        const SizedBox(width: 25),
        Expanded(
          child: TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '年齡',
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFF39C12), width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('卡路里消耗計算'),
        backgroundColor: const Color(0xFFF39C12),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 30, 25, 30),
        child: ListView(
          children: [
            _GenderAgeSelector(),
            const SizedBox(height: 20),
            _buildLabeledInput(
              label: '身高',
              controller: _heightController,
              unit: _heightUnit,
              unitOptions: ['cm', 'ft'],
              onUnitChanged: (v) => setState(() => _heightUnit = v!),
            ),
            const SizedBox(height: 20),
            _buildLabeledInput(
              label: '體重',
              controller: _weightController,
              unit: _weightUnit,
              unitOptions: ['kg', 'lb'],
              onUnitChanged: (v) => setState(() => _weightUnit = v!),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedBpm,
                    decoration: InputDecoration(
                      labelText: '節拍',
                      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFF39C12), width: 2),
                      ),
                    ),
                    items: _bpmOptions.map((bpm) {
                      return DropdownMenuItem(
                        value: bpm,
                        child: Text('$bpm'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBpm = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 20),
                const Text('bpm'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '持續時間',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFF39C12), width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Text('分鐘'),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _calculateCalories,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF39C12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '計算卡路里',
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              _result,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
