import 'package:flutter/material.dart';
import 'package:flutter_study/common/const/colors.dart';
import 'package:flutter_study/common/layout/default_layout.dart';
import 'package:flutter_study/product/view/product_screen.dart';

import '../../restaurant/view/restaurant_screen.dart';

class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab>
  with  SingleTickerProviderStateMixin{
  late TabController controller; // 이닛할때 부르므로 late쓰면 됨 나중에 받는다.

  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = TabController(length: 4, vsync: this); //vsync this가 기능을 가지고 있어야됨 SingleTickerProviderStateMixin 넣어줘라

    controller.addListener(tabListener); // 연동을 하기 위해 탭리스너를 해줘야됨
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener(){
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  DefaultLayout(
      title: '민겅 딜리버리',
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(), // 탭바뷰에서 스크롤 하면 중지시킴
        controller: controller,
        children: [
          RestaurantScreen(),
          ProductScreen(),
          Center(child: Container(child: Text('주문'))),
          Center(child: Container(child: Text('프로필'))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.shifting, //선택된 거 크게
        // type: BottomNavigationBarType.fixed, //거슬린다면 fixed 사용해라
        onTap: (int index){
          // setState(() {
          controller.animateTo(index); // 이렇게 넣어주면 된다.
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood_outlined),
              label: '음식'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              label: '주문'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: '프로필'
          ),
        ],
      ),
    );
  }
}
