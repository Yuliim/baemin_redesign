import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 하위 컴포넌트 import
import 'components/action_buttons.dart';
import 'components/category_bar.dart';
import 'components/selected_items_display.dart';

// 컨트롤러 import
import 'controller.dart';

// 데이터 및 UI 관련 파일 import
import 'data.dart';
import 'selection_grid.dart';
import 'top_title.dart';

class MergeAllScreen extends StatelessWidget {
  final AppMenuController controller = Get.find(); // 컨트롤러 가져오기

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white, // 앱바 흰색 배경
        title: Row(
          children: [
            SizedBox(width: 8.0), // 간격 추가
            Text(
              '메뉴 선택', // 앱바 제목
              style: TextStyle(
                color: Colors.black, // 제목 텍스트 색상
                fontWeight: FontWeight.bold, // 굵게
                fontSize: 21.0,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            // Body 영역 확장
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopTitle(), // 상단 타이틀
                  Divider(color: Colors.grey[300], thickness: 1), // 구분선
                  CategoryBar(controller: controller), // 카테고리 바
                  Divider(color: Colors.grey[300], thickness: 1), // 구분선
                  ActionButtons(controller: controller), // 액션 버튼
                  SelectedItemsDisplay(controller: controller), // 선택된 항목
                  Divider(color: Colors.grey[300], thickness: 1), // 구분선
                  Obx(() {
                    // 선택된 카테고리에 따라 데이터를 필터링하여 SelectionGrid에 전달
                    final currentCategory = controller.selectedCategory.value;
                    final currentItems = menuData[currentCategory] ?? []; // 현재 카테고리에 맞는 데이터 가져오기

                    return SelectionGrid(
                      items: currentItems, // 필터링된 데이터 전달
                      onItemSelected: (itemName) {
                        controller.toggleItemSelection(currentCategory, itemName);
                      },
                      controller: controller, // 컨트롤러 전달
                    );
                  }),
                ],
              ),
            ),
          ),
          // 하단 네비게이션 영역
          Obx(
                () {
              // 선택된 항목들의 총 가격 계산
              int totalPrice = controller.selectedItemsByCategory.entries.fold(
                0,
                    (sum, entry) {
                  return sum +
                      entry.value.fold(
                        0,
                            (itemSum, itemName) {
                          final category = menuData[entry.key] ?? [];
                          final item = category.firstWhere(
                                (e) => e['name'] == itemName,
                            orElse: () => <String, dynamic>{'price': 0},
                          );
                          final price = (item['price'] ?? 0) as int;
                          return itemSum + price;
                        },
                      );
                },
              );

              return Padding(
                padding: EdgeInsets.all(0.0), // 패딩 추가
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider( // 경계선 추가
                        color: Colors.grey[300],
                        thickness: 1.0,
                        height: 1.0, // 선의 높이를 줄여서 깔끔하게 표시
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        child: Row(
                          children: [
                            // 왼쪽 정보 영역
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '배달최소주문금액',
                                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  '12,900원',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10.0), // 가로 간격 추가
                            // 버튼 영역을 Expanded로 감싸기
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (totalPrice >= 12900) {
                                    print('총 금액: $totalPrice원');
                                  } else {
                                    print('최소 주문 금액에 도달하지 못했습니다.');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF2AC1BC),
                                  padding: EdgeInsets.symmetric(vertical: 15.0), // 높이만 지정
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                                child: Text(
                                  '$totalPrice원 담기',
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
