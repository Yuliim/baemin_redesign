// import 'package:flutter/material.dart';
// import '../controller.dart';
// import 'package:get/get.dart';
//
// class CategoryBar extends StatelessWidget {
//   final AppMenuController controller;
//   final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러 추가
//
//   CategoryBar({required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return SingleChildScrollView(
//         controller: _scrollController, // 스크롤 컨트롤러 연결
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: ['가격', '생과일토핑', '시리얼토핑', '소스', '프리미엄토핑'].map((category) {
//             return GestureDetector(
//               onTap: () {
//                 controller.updateCategory(category); // 카테고리 업데이트
//                 _scrollToCategory(category); // 선택된 카테고리로 스크롤 이동
//               },
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//                 child: Text(
//                   category,
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.w900, // 글씨 굵게 변경
//                     color: controller.selectedCategory.value == category
//                         ? Colors.black
//                         : Colors.grey,
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       );
//     });
//   }
//
//   /// 선택된 카테고리 버튼으로 스크롤 이동
//   void _scrollToCategory(String category) {
//     final index = ['가격', '생과일토핑', '시리얼토핑', '소스', '프리미엄토핑'].indexOf(category);
//     final screenWidth = WidgetsBinding.instance.window.physicalSize.width /
//         WidgetsBinding.instance.window.devicePixelRatio; // 화면 너비 계산
//
//     // 각 버튼의 가로 길이와 간격
//     const buttonWidth = 100.0; // 각 버튼의 대략적인 너비
//     const buttonSpacing = 24.0; // 버튼 간 간격
//
//     // 스크롤 이동 대상 위치 계산
//     double targetPosition;
//     if (category == '가격' || category == '생과일토핑') {
//       targetPosition = 0.0; // 맨 왼쪽으로 스크롤
//     } else if (category == '소스' || category == '프리미엄토핑') {
//       targetPosition =
//           (buttonWidth + buttonSpacing) * 5 - screenWidth; // 맨 오른쪽으로 스크롤
//     } else {
//       targetPosition =
//           ((buttonWidth + buttonSpacing) * index + buttonWidth / 2) - screenWidth / 2; // 가운데 정렬
//     }
//
//     // 스크롤 애니메이션 적용
//     _scrollController.animateTo(
//       targetPosition.clamp(
//         0.0,
//         _scrollController.position.maxScrollExtent,
//       ), // 스크롤 범위 제한
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../controller.dart';
import 'package:get/get.dart';

class CategoryBar extends StatelessWidget {
  final AppMenuController controller;
  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러 추가

  CategoryBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categories = ['가격', '생과일토핑', '시리얼토핑', '소스', '프리미엄토핑'];

      return SingleChildScrollView(
        controller: _scrollController, // 스크롤 컨트롤러 연결
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: categories.map((category) {
            return GestureDetector(
              onTap: () {
                controller.updateCategory(category); // 카테고리 업데이트
                _scrollToCategory(category, categories); // 선택된 카테고리로 스크롤 이동
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // 일정한 간격 유지
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w900, // 글씨 굵게 유지
                    color: controller.selectedCategory.value == category
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  /// 선택된 카테고리 버튼으로 스크롤 이동
  void _scrollToCategory(String category, List<String> categories) {
    final index = categories.indexOf(category);
    final screenWidth = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio; // 화면 너비 계산

    const buttonWidth = 90.0; // 버튼 대략적인 너비
    const buttonSpacing = 16.0; // 버튼 간 간격

    // 스크롤 이동 대상 위치 계산
    double targetPosition;
    if (index == 0) {
      targetPosition = 0.0; // 맨 왼쪽으로 스크롤
    } else if (index == categories.length - 1) {
      targetPosition =
          (buttonWidth + buttonSpacing) * categories.length - screenWidth; // 맨 오른쪽으로 스크롤
    } else {
      targetPosition =
          ((buttonWidth + buttonSpacing) * index + buttonWidth / 2) - screenWidth / 2; // 가운데 정렬
    }

    // 스크롤 애니메이션 적용
    _scrollController.animateTo(
      targetPosition.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ), // 스크롤 범위 제한
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
