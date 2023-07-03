import 'package:flutter/material.dart';
import 'package:flutter_study/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {

  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    required this.onChanged,
    this.autofocus = false,
    this.obscureText = false,
    this.hintText, // 안넣어주는 경우도 있으니까 require 지우고 ? 붙여줌
    this.errorText,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      )
    ); // 테두리가 있는 입력하는 보더
                                            // UnderlineInputBorder 가 기본 값

    return TextFormField(
      cursorColor: PRIMARY_COLOR, //깜빡이는 색깔
      // 비밀번호 입력할때만 사용 true 면 글자가 가려진다.
      obscureText: obscureText,
      autofocus: autofocus, // 켰을때 오토로 포커스 가질꺼냐 말까냐 다시 시작하면 바로 잡히는 걸 알 수 있음.
      onChanged: onChanged,// 바꼇을때 타는 이벤트
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20), // 내용물이 밀린것 확인 가능
        hintText: hintText, // 글자를 쓰면 사라짐
        errorText: errorText, // 아래 에러가 있습니다 메시지를 추가할 수 있음.
        hintStyle: const TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0,
        ),
        fillColor: INPUT_BG_COLOR,
        // false -- 배경색 없음
          // true -- 배경색 있음
        filled: true,
        // 모든 Input 상태의 기본 스타일 세팅
        border: baseBorder, // 동그란 테두리 만들어 주는 부분
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR, // 베이스 보더의 색깔만 변경해서 넣겠다.
          ),
        ),
      ),
    );
  }
}
