import 'package:flutter/material.dart';
import 'package:flutter_study/common/restaurant/component/restaurant_card.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: RestaurantCard(
            image: Image.asset(
              'asset/img/food/ddeok_bok_gi.jpg',
              fit: BoxFit.cover,
            ),
            name: '불타는 떢볶이',
            tags: const ['떡볶이', '치즈', '매운맛'],
            ratingCount: 100,
            deliveryTime: 15,
            deliveryFee: 2000,
            rating: 4.52,
          ),
        ),
      ),
    );
  }
}