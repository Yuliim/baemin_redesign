import 'package:flutter/material.dart';
import '../controller.dart';
import 'package:get/get.dart';

class ActionButtons extends StatelessWidget {
  final AppMenuController controller; // 컨트롤러 추가

  const ActionButtons({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: controller.toggleShowAllSelectedItems, // '모두 보기' 동작
            child: Obx(
                  () => Row(
                children: [
                  Text(
                    '전체 보기',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Icon(
                    controller.showAllSelectedItems.value
                        ? Icons.keyboard_arrow_down // 눌렀을 때 아래로 향함
                        : Icons.keyboard_arrow_up, // 눌리지 않았을 때 위로 향함
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          Obx(
                () => TextButton(
              onPressed: controller.toggleSelectionMode, // 선택 삭제 모드 전환
              child: Text(
                controller.isInDeleteMode.value ? '확인' : '선택 삭제',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey, // 둘 다 회색
                  decoration: TextDecoration.none, // 밑줄 제거
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
