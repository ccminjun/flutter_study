import 'package:flutter/material.dart';
import 'package:flutter_study/common/layout/default_layout.dart';
import 'package:flutter_study/product/component/product_card.dart';

import '../component/restaurant_card.dart';

class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 떢복이',
      child: CustomScrollView(
        slivers: [
          renderTop(),
          renderLabel(),
          renderProducts(),
        ],
      )
    );
  }

  SliverPadding renderLabel() {
    return  const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  renderProducts(){
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index){
                return const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: ProductCard(),
                );
              },
              childCount: 10,
          ),
      ),
    );
  }
  
  // 일반 위젯을 넣으려면 SliverToBoxAdapter 써줘야 됨
  SliverToBoxAdapter renderTop(){
    return SliverToBoxAdapter(
      child: RestaurantCard(
        image: Image.asset('asset/img/food/ddeok_bok_gi.jpg'),
        name: '불타는 떡볶이',
        tags: ['떡볶이', '맛있음', '치즈'],
        ratingsCount: 100,
        deliveryTime: 30,
        deliveryFee: 3000,
        ratings: 4.76,
        isDetail: true,
        detail: '맛있는 떡볶이',
      ),
    );
  }
}

