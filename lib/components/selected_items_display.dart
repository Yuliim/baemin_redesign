import 'package:flutter/material.dart';
import '../controller.dart';
import 'package:get/get.dart';

class SelectedItemsDisplay extends StatelessWidget {
  final AppMenuController controller; // 컨트롤러 추가

  const SelectedItemsDisplay({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 표시할 항목들을 가져옵니다.
      final displayedEntries = controller.showAllSelectedItems.value
          ? controller.selectedItemsByCategory.entries
          .where((entry) => entry.value.isNotEmpty)
          .toList()
          : [
        MapEntry(
            controller.selectedCategory.value,
            controller.selectedItemsByCategory[
            controller.selectedCategory.value] ??
                <String>[])
      ];

      // 위젯 리스트를 생성합니다.
      List<Widget> itemWidgets = [];

      for (int i = 0; i < displayedEntries.length; i++) {
        final entry = displayedEntries[i];
        final items = entry.value;
        final category = entry.key;

        // 카테고리의 아이템들을 위젯으로 변환하고, 리스트에 추가합니다.
        for (int j = 0; j < items.length; j++) {
          final item = items[j];

          itemWidgets.add(GestureDetector(
            onTap: controller.isInDeleteMode.value
                ? () => controller.deleteItem(category, item) // 즉시 삭제
                : null, // 삭제 모드에서만 작동
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
              // 패딩을 늘려 전체 간격 조정
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                  if (controller.isInDeleteMode.value) ...[
                    SizedBox(width: 4.0),
                    GestureDetector(
                      onTap: () => controller.deleteItem(category, item),
                      child: Icon(
                        Icons.close,
                        size: 18.0,
                        color: Colors.black, // x 아이콘을 검정색으로 설정
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ));
        }

        // 마지막 카테고리가 아니라면 구분자 추가
        if (i < displayedEntries.length - 1) {
          itemWidgets.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0), // 좌우 패딩 제거
            child: Text(
              "/", // 구분자
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ));
        }
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4.0, // 간격을 절반으로 줄임
          runSpacing: 8.0,
          children: itemWidgets,
        ),
      );
    });
  }
}
