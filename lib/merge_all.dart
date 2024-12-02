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
            child: CustomScrollView(
              slivers: [
                // 상단 타이틀과 카테고리 바
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      TopTitle(), // 상단 제목 및 이미지
                      Divider(color: Colors.grey[300], thickness: 1), // 구분선
                      CategoryBar(controller: controller), // 카테고리 바
                      Divider(color: Colors.grey[300], thickness: 1), // 구분선
                    ],
                  ),
                ),
                // 고정 선택 바 - ActionButtons와 SelectedItemsDisplay가 포함된 부분을 Sliver로 고정
                SliverPersistentHeader(
                  pinned: true, // 스크롤 시에도 고정되도록 설정
                  delegate: FixedSelectionBarDelegate(controller: controller),
                ),
                // 구분선 추가
                SliverToBoxAdapter(
                  child: Divider(color: Colors.grey[300], thickness: 1),
                ),
                // 선택된 카테고리에 따른 SelectionGrid 표시
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 5.0), // SelectionGrid와 겹치지 않도록 여유 공간 추가
                      Obx(() {
                        // GetX를 사용하여 selectedCategory의 상태 변화를 관찰하여 업데이트
                        final currentCategory = controller.selectedCategory.value;
                        final currentItems = menuData[currentCategory] ?? []; // 현재 카테고리에 맞는 데이터 가져오기

                        return SelectionGrid(
                          items: currentItems, // 필터링된 데이터 전달
                          onItemSelected: (itemName) {
                            // 아이템 선택 시 호출되는 콜백 함수
                            controller.toggleItemSelection(currentCategory, itemName);
                          },
                          controller: controller, // 컨트롤러 전달
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 하단 네비게이션 영역
          Obx(() {
            // 선택된 항목들의 총 가격 계산
            int totalPrice = controller.selectedItemsByCategory.entries.fold(
              0,
                  (sum, entry) {
                return sum +
                    entry.value.fold(
                      0,
                          (itemSum, itemName) {
                        // 각 항목의 가격을 가져와서 합산
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
                      height: 1.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      child: Row(
                        children: [
                          // 왼쪽 정보 영역 (배달 최소 주문 금액 등)
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
                          // "총 금액 담기" 버튼 영역
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
          }),
        ],
      ),
    );
  }
}

// SliverPersistentHeaderDelegate 구현
class FixedSelectionBarDelegate extends SliverPersistentHeaderDelegate {
  final AppMenuController controller;

  FixedSelectionBarDelegate({required this.controller});

  // 최소 높이 설정 - 선택된 항목의 수에 따라 동적으로 계산
  @override
  double get minExtent => calculateTotalHeight();

  // 최대 높이 설정 - 선택된 항목의 수에 따라 동적으로 계산
  @override
  double get maxExtent => calculateTotalHeight();

  // 고정 선택 바의 총 높이를 계산하는 함수
  double calculateTotalHeight() {
    final List<String> totalItems = controller.selectedItemsByCategory.entries
        .expand((entry) => entry.value.cast<String>()) // List<dynamic>을 List<String>으로 변환
        .toList(); // 전체 선택된 아이템 리스트

    final List<String> itemWidgets = controller.showAllSelectedItems.value
        ? totalItems
        : (controller.selectedItemsByCategory[controller.selectedCategory.value]?.cast<String>() ?? []);

    int itemsPerLine = _calculateItemsPerLine(itemWidgets); // 한 줄에 들어갈 수 있는 최대 아이템 수 계산

    double lineHeight = 40.0; // 각 줄의 높이
    int numberOfLines = (itemWidgets.length / itemsPerLine).ceil(); // 전체 아이템을 기준으로 줄의 수 계산

    return numberOfLines * lineHeight + 70.0; // 전체 줄 높이와 액션 버튼 높이 합산
  }

  // @override
  // Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
  //   return Container(
  //     color: Colors.yellow, // 배경색을 흰색으로 설정
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
  //           child: ActionButtons(controller: controller), // 액션 버튼 (항상 표시)
  //         ),
  //         Expanded(
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
  //             child: SelectedItemsDisplay(controller: controller),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      children: [
        Container(
          color: Colors.white,//Color(0xFFF1FFFF), //fffae4
          child: Column(
            children: [
              ActionButtons(controller: controller), // 액션 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                child: SelectedItemsDisplay(controller: controller),
              ),
            ],
          ),
        ),

      ],
    );
  }

  @override
  bool shouldRebuild(covariant FixedSelectionBarDelegate oldDelegate) {
    return calculateTotalHeight() != oldDelegate.calculateTotalHeight();
  }

  int _calculateItemsPerLine(List<String> items) {
    int maxLengthPerLine = 28; // 각 줄에 들어갈 수 있는 최대 문자 길이
    int currentLength = 0;
    int itemsPerLine = 0;

    for (String item in items) {
      currentLength += item.length + 1; // 아이템 이름 길이와 스페이스 고려
      if (currentLength <= maxLengthPerLine) {
        itemsPerLine++;
      } else {
        break;
      }
    }
    return itemsPerLine > 0 ? itemsPerLine : 1; // 최소 1개의 아이템은 들어갈 수 있도록 보장
  }
}
