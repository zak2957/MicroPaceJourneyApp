# MicroPaceJourneyApp
lib/
├── main.dart                           # 應用程式入口
├── pages/                              # 頁面檔案
│   ├── home_page.dart                  # 主頁面(+計步器)
│   ├── timer_page.dart                 # 計時器頁面 (待開發)
│   ├── water_tracker_page.dart         # 喝水紀錄頁面 (待開發)
│   ├── metronome_page.dart             # 節拍器頁面 (待開發)
│   └── distance_converter_page.dart    # 里程轉換頁面 (待開發)
└── widgets/                            # 組件檔案
    ├── step_counter_
    ............
像這樣:
![image](https://github.com/user-attachments/assets/4fbaf6db-ab04-4d76-9ce3-fbeab7044aeb)
如果想把功能顯示直接在主頁，就不用另外加入pages(timer_page和water_tracker_page都是示範)，但要從function_card_widget做更改
每個人都創建一個功能在widgets裡~這樣比較好分開做~
UI覺得哪裡需要美化可以自行修改，我只是做個雛形!
功能因為沒有討論好所以我也只是提供參考，大家也可以自己改
