import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/common/restaurant/component/restaurant_card.dart';

import '../../const/data.dart';
import '../model/restaurant_model.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    // 유효기간 5분
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    // final accessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoiYWNjZXNzIiwiaWF0IjoxNjkwODA3NjM4LCJleHAiOjE2OTA4MDc5Mzh9.cKexwzADjr4WYFRHGK_zhBKrH8ydAltxCGr1KJtUO1g';

    final resp = await dio.get(
      'http://$ip/restaurant',
      // 'http//127.0.0.1:3000/restaurant',
      options: Options(
          headers: {
            'authorization': 'Bearer $accessToken',
          },
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
              // print(snapshot.error);
              // print(snapshot.data);
              if(!snapshot.hasData){
                return Container();
              }

              return ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index){
                  final item = snapshot.data![index];
                  // parsed 변환됐다.
                  final pItem = RestaurantModel.fromJson(
                      json: item,
                    );
                  //   final pItem = RestaurantModel(
                  //   id: item['id'],
                  //   name: item['name'],
                  //   thumbUrl: 'http://$ip${item['thumbUrl']}',
                  //   tags: List<String>.from(item['tags']),
                  //   priceRange: RestaurantPriceRange.values.firstWhere(
                  //     (e) => e.name == item['priceRange'],
                  //   ),
                  //   ratings: item['ratings'],
                  //   ratingsCount: item['ratingsCount'],
                  //   deliveryTime: item['deliveryTime'],
                  //   deliveryFee: item['deliveryFee'],
                  // );

                  return  RestaurantCard.fromModel(
                    model: pItem,
                    // image: Image.network(
                    //   pItem.thumbUrl,
                    //   fit: BoxFit.cover,
                    // ),
                    // // image: Image.asset(
                    // //   'asset/img/food/ddeok_bok_gi.jpg',
                    // //   fit: BoxFit.cover,
                    // // ),
                    // name: pItem.name,
                    // tags: pItem.tags,
                    // ratingsCount: pItem.ratingsCount,
                    // deliveryTime: pItem.deliveryTime,
                    // deliveryFee: pItem.deliveryFee,
                    // ratings: pItem.ratings,
                  );
                },
                separatorBuilder: (_,index){
                  return SizedBox(height: 16.0); // 각각의 사이사이에 들어오는 것
                },
              );
            },
          )
        ),
      ),
    );
  }
}
