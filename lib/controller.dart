import 'package:get/get.dart';

class AppMenuController extends GetxController {
  var selectedCategory = '가격'.obs; // 기본 선택 카테고리
  var showAllSelectedItems = false.obs; // '모두 보기' 상태를 관리하는 변수 추가
  var isInDeleteMode = false.obs; // 선택 삭제 모드 상태 추가
  var itemsMarkedForDeletion = <String>[].obs; // 삭제 대기 중인 항목 관리

  var selectedItemsByCategory = <String, RxList<String>>{
    '가격': <String>[].obs,
    '생과일토핑': <String>[].obs,
    '시리얼토핑': <String>[].obs,
    '소스': <String>[].obs,
    '프리미엄토핑': <String>[].obs,
  };

  // 선택 제한 설정
  final Map<String, int> categoryLimits = {
    '가격': 1,
    '생과일토핑': 10,
    '시리얼토핑': 12,
    '소스': 4,
    '프리미엄토핑': 3,
  };

  // 카테고리 변경
  void updateCategory(String category) {
    selectedCategory.value = category;
  }

  // 항목 선택/해제
  void toggleItemSelection(String category, String itemName) {
    final items = selectedItemsByCategory[category];
    final limit = categoryLimits[category] ?? 0;

    if (items == null) return;

    // 가격 카테고리일 경우 라디오 버튼 동작
    if (category == '가격') {
      items.clear(); // 이전 선택 초기화
      items.add(itemName); // 새 선택 추가
    } else {
      // 이미 선택된 경우 해제
      if (items.contains(itemName)) {
        items.remove(itemName);
      } else {
        // 선택 제한 확인
        if (items.length < limit) {
          items.add(itemName);
        } else {
          print('최대 $limit개까지 선택 가능합니다.');
        }
      }
    }
  }

  // '모두 보기' 토글
  void toggleShowAllSelectedItems() {
    showAllSelectedItems.value = !showAllSelectedItems.value;
  }

  // 선택 삭제 모드 활성화/비활성화
  void toggleSelectionMode() {
    isInDeleteMode.value = !isInDeleteMode.value;
  }


  // 항목 삭제 토글
  void toggleSelectedItemForDeletion(String itemName) {
    if (itemsMarkedForDeletion.contains(itemName)) {
      itemsMarkedForDeletion.remove(itemName); // 삭제 선택 해제
    } else {
      itemsMarkedForDeletion.add(itemName); // 삭제 항목 추가
    }
  }

  // 선택 삭제 확인
  void confirmDeletion() {
    for (var category in selectedItemsByCategory.keys) {
      // 각 카테고리에서 삭제 대기 중인 항목 제거
      selectedItemsByCategory[category]?.removeWhere(
            (item) => itemsMarkedForDeletion.contains(item),
      );
    }
    itemsMarkedForDeletion.clear(); // 삭제 목록 초기화
    toggleSelectionMode(); // 선택 삭제 모드 종료
  }

  // 항목 즉시 삭제
  void deleteItem(String category, String itemName) {
    selectedItemsByCategory[category]?.remove(itemName);
  }

  // 선택된 메뉴를 카테고리별로 정렬하여 문자열 반환
  String getFormattedSelectedItems() {
    return selectedItemsByCategory.entries
        .where((entry) => entry.value.isNotEmpty)
        .map((entry) => entry.value.join(' / '))
        .join(' / ');
  }

  // 전체 선택된 메뉴 수 계산
  int getTotalSelectedItemsCount() {
    return selectedItemsByCategory.values.fold(0, (sum, items) => sum + items.length);
  }
}
