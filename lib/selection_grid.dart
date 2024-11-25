import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class SelectionGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items; // 메뉴 데이터
  final Function(String) onItemSelected; // 아이템 선택 콜백
  final AppMenuController controller; // 컨트롤러 추가

  const SelectionGrid({
    required this.items,
    required this.onItemSelected,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // 양쪽 간격 조정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final String category = controller.selectedCategory.value;
            final int limit = controller.categoryLimits[category] ?? 0;

            return Padding(
              padding: const EdgeInsets.only(top:4, bottom: 8.0), // 상단과 아이템 사이 간격
              child: Text(
                '최대 $limit개 선택', // 제한 메시지
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
            );
          }),
          ...items.map((item) {
            final String itemName = item['name'];
            final int itemPrice = item['price'];
            final String category = controller.selectedCategory.value;
            final itemsInCategory =
                controller.selectedItemsByCategory[category] ?? [];
            final limit = controller.categoryLimits[category] ?? 0;

            return Obx(() {
              final bool isSelected = itemsInCategory.contains(itemName);

              if (category == '가격') {
                // '가격' 카테고리에만 라디오 버튼 적용
                return GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      // 선택 해제
                      onItemSelected(itemName);
                    } else {
                      // 라디오 버튼은 하나만 선택 가능
                      onItemSelected(itemName);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0), // 메뉴 간 간격
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomRadioButton(
                          isSelected: isSelected,
                          onTap: () => onItemSelected(itemName),
                          label: itemName,
                        ),
                        Text(
                          '$itemPrice원',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // 나머지 카테고리는 체크박스 적용
                return GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      // 선택 해제
                      onItemSelected(itemName);
                    } else if (itemsInCategory.length < limit) {
                      // 선택 가능
                      onItemSelected(itemName);
                    } else {
                      // 선택 초과 시 Overlay 메시지 표시
                      _showOverlayMessage(context, '최대 $limit개까지 선택 가능합니다.');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: CustomCheckbox(
                                value: isSelected,
                                onChanged: (_) {
                                  if (isSelected) {
                                    onItemSelected(itemName);
                                  } else if (itemsInCategory.length < limit) {
                                    onItemSelected(itemName);
                                  } else {
                                    _showOverlayMessage(
                                        context, '최대 $limit개까지 선택 가능합니다.');
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 12.0),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6, // 텍스트 최대 너비
                              child: Text(
                                itemName,
                                maxLines: 2, // 최대 2줄
                                overflow: TextOverflow.ellipsis, // 넘치는 텍스트 처리
                                softWrap: true, // 자동 줄바꿈 활성화
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '+$itemPrice원',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            });
          }).toList(),
        ],
      ),
    );
  }

  void _showOverlayMessage(BuildContext context, String message) {
    final overlay = Overlay.of(context); // 현재 화면의 Overlay 가져오기
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.5, // 화면 중간 위치
        left: MediaQuery.of(context).size.width * 0.2,
        right: MediaQuery.of(context).size.width * 0.2,
        child: Material(
          color: Colors.transparent, // 배경 투명
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8), // 검정 배경
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white, // 흰색 텍스트
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry); // Overlay에 추가

    // 2초 후 메시지 제거
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}

class CustomRadioButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String label;

  const CustomRadioButton({
    required this.isSelected,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 24, // 버튼 크기
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle, // 원형 버튼
              border: Border.all(
                color: isSelected ? Color(0xFF2AC1BC) : Colors.grey[300]!, // 테두리 색상
                width: 2.0, // 테두리 두께
              ),
              color: isSelected ? Color(0xFF2AC1BC) : Colors.transparent, // 선택 시 내부 색상
            ),
            child: isSelected
                ? Center(
              child: Container(
                width: 8, // 내부 원 크기
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // 내부 원 색상
                ),
              ),
            )
                : null,
          ),
          SizedBox(width: 12.0), // 버튼과 라벨 간의 간격
          Text(
            label,
            style: TextStyle(fontSize: 18.0), // 라벨 텍스트 스타일
          ),
        ],
      ),
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final bool value; // 체크 여부
  final ValueChanged<bool> onChanged;

  const CustomCheckbox({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),

      child: Container(
        width: 18, // 체크박스 크기
        height: 18,
        decoration: BoxDecoration(
          border: Border.all(
            color: value ? Color(0xFF2AC1BC) : Colors.grey[300]!, // 테두리 색상
            width: 1.5, // 테두리 두께
          ),
          borderRadius: BorderRadius.circular(3), // 둥근 모서리
          color: value ? Color(0xFF2AC1BC) : Colors.transparent, // 배경색
        ),
        child: value
            ? Center(
          child: CustomPaint(
            size: Size(15, 15), // 체크 무늬 크기
            painter: CheckMarkPainter(),
          ),
        )
            : null,
      ),
    );
  }
}

class CheckMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white // 체크 무늬 색상
      ..strokeWidth = 1.5 // 체크 무늬 굵기
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.5)
      ..lineTo(size.width * 0.4, size.height * 0.7)
      ..lineTo(size.width * 0.8, size.height * 0.3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
