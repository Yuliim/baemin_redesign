import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'merge_all.dart';

void main() {
  Get.put(AppMenuController()); // 앱 시작 시 컨트롤러 초기화
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Baemin Redesign',
      theme: ThemeData(
        primaryColor: Color(0xFF2AC1BC), // 원하는 색상 적용
      ),
      home: MergeAllScreen(),
    );
  }
}
