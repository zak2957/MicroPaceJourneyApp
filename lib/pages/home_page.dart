import 'package:flutter/material.dart';
import '../widgets/step_counter_widget.dart';
import '../widgets/function_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Micro Pace Journey',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xefefefef),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 置頂訊息
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F3FD).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF4A90E2).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Color(0xFF4A90E2),
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '歡迎開始超慢跑silver fit',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF191D38),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '維持骨骼密度.降低三高.提升心肺',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF777DA7),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 記步器區塊 (置頂功能)
              const StepCounterWidget(),

              const SizedBox(height: 24),

              // 其他功能標題
              Text(
                '運動功能',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFF2C3E50),
                ),
              ),

              const SizedBox(height: 16),

              // 功能卡片網格
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: const [
                  FunctionCardWidget(
                    icon: Icons.timer,
                    title: '計時器',
                    subtitle: '運動計時',
                    color: Color(0xFFE74C3C),
                    isImplemented: false,
                  ),
                  FunctionCardWidget(
                    icon: Icons.water_drop,
                    title: '喝水紀錄',
                    subtitle: '補水提醒',
                    color: Color(0xFF3498DB),
                    isImplemented: false,
                  ),
                  FunctionCardWidget(
                    icon: Icons.music_note,
                    title: '節拍器',
                    subtitle: '步伐節奏',
                    color: Color(0xFF9B59B6),
                    isImplemented: false,
                  ),
                  FunctionCardWidget(
                    icon: Icons.straighten,
                    title: '里程轉換',
                    subtitle: '距離計算',
                    color: Color(0xFFF39C12),
                    isImplemented: false,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 底部提示
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,  // 白底
              borderRadius: BorderRadius.circular(15),
              boxShadow: [  // 加陰影
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),  // 陰影顏色
                  spreadRadius: 1,  // 陰影散布
                  blurRadius: 6,    // 模糊程度
                  offset: const Offset(0, 3),  // 陰影偏移 (x, y)
                ),
              ],
            ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFF27AE60),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '記得保持適度運動，注意身體狀況',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF878991),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
