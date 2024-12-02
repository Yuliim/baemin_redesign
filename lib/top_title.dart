import 'package:flutter/material.dart';

class TopTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 이미지 위젯 추가
        Image.asset(
          'assets/요아정_요거트만.jpg',
          width: double.infinity, // 화면 가로 전체를 사용
          height: 200.0, // 원하는 높이로 설정
          fit: BoxFit.cover, // 이미지가 영역을 꽉 채우도록 설정
        ),
        // 기존 내용
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목 줄 추가
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   'assets/인기.png', // '인기' 이미지
                  //   height: 50.0, // 텍스트 높이에 맞게 이미지 크기 설정
                  // ),
                  //SizedBox(width: 8.0), // 제목과 이미지 간격
                  Expanded(
                    child: Text(
                      '내맘대로 요아정) 요거트 아이스크림',
                      style: TextStyle(
                        fontSize: 24.0, // 제목 크기
                        fontWeight: FontWeight.bold, // 제목 굵기
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              // 영양성분 텍스트 박스
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 9.0, vertical: 2.0), // 패딩 추가
                decoration: BoxDecoration(
                  color: Colors.grey[100], // 회색 배경
                  borderRadius: BorderRadius.circular(20.0), // 둥근 모서리
                ),
                child: Text(
                  '영양성분 및 알레르기 성분 표시 보기',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey[900], // 텍스트 색상
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              // 리뷰 줄
              Row(
                children: [
                  Icon(
                    Icons.comment,
                    color: Color(0xFF2AC1BC), // 아이콘 색상
                    size: 20.0, // 아이콘 크기
                  ),
                  SizedBox(width: 6.0), // 간격
                  Text(
                    '메뉴 리뷰 17개 >', // 텍스트
                    style: TextStyle(
                      fontSize: 18.0, // 텍스트 크기
                      fontWeight: FontWeight.bold, // 텍스트 굵기
                      color: Colors.black, // 텍스트 색상
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
