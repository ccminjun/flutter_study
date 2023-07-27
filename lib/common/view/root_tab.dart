import 'package:flutter/material.dart';
import 'package:flutter_study/common/const/colors.dart';
import 'package:flutter_study/common/layout/default_layout.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return  DefaultLayout(
      title: '코팩 딜리버리',
      child: TabBarView(
        controller: ,
        children: [
          Container(child: Text('홈')),
          Container(child: Text('음식')),
          Container(child: Text('주문')),
          Container(child: Text('프로필')),
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
          setState(() {
            this.index = index;
          });
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
