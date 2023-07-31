import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/common/restaurant/component/restaurant_card.dart';

import '../../const/data.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    // 유효기간 5분
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http//$ip/restaurant',
      options: Options(
          headers: {
            'authorization': 'Bearer $accessToken',
          }
      ),
    );

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List>(
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List> snapshot ){
              print(snapshot.error);
              print(snapshot.data);

              return RestaurantCard(
                image: Image.asset(
                  'asset/img/food/ddeok_bok_gi.jpg',
                  fit: BoxFit.cover,
                ),
                name: '불타는 떢볶이',
                tags: const ['떡볶이', '치즈', '매운맛'],
                ratingsCount: 100,
                deliveryTime: 15,
                deliveryFee: 2000,
                ratings: 4.52,
              );
            },
          )
        ),
      ),
    );
  }
}
