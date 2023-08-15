import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/common/model/cursor_pagination_model.dart';
import 'package:flutter_study/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_study/restaurant/view/restaurant_detail_screen.dart';

import '../../common/const/data.dart';
import '../../common/dio/dio.dart';
import '../component/restaurant_card.dart';
import '../model/restaurant_model.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  // Future<List<RestaurantModel>> paginateRestaurant(WidgetRef ref) async {
  //   // final dio = Dio();
  //   //
  //   // dio.interceptors.add(
  //   //   CustomInterceptor(
  //   //       storage: storage ),
  //   // );
  //   final dio = ref.watch(dioProvider);
  //
  //   final resp =
  //       await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant')
  //           .paginate();
  //
  //   // // 유효기간 5분
  //   // final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
  //   //
  //   // // final accessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoiYWNjZXNzIiwiaWF0IjoxNjkwODA3NjM4LCJleHAiOjE2OTA4MDc5Mzh9.cKexwzADjr4WYFRHGK_zhBKrH8ydAltxCGr1KJtUO1g';
  //   //
  //   // final resp = await dio.get(
  //   //   'http://$ip/restaurant',
  //   //   // 'http//127.0.0.1:3000/restaurant',
  //   //   options: Options(
  //   //       headers: {
  //   //         'authorization': 'Bearer $accessToken',
  //   //       },
  //   //   ),
  //   // );
  //
  //   return resp.data;
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<CursorPagination<RestaurantModel>>(
              future: ref.watch(restaurantRepositoryProvider).paginate(),
              // paginateRestaurant(ref),
              builder:
                  (context, AsyncSnapshot<CursorPagination<RestaurantModel>> snapshot) {
                // print(snapshot.error);
                // print(snapshot.data);
                if (!snapshot.hasData) {
                  return const Center(
                    // 로딩하는 부분 추가
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.separated(
                itemCount: snapshot.data!.data.length,
                itemBuilder: (_, index){
                  final pItem = snapshot.data!.data[index];
                  // parsed 변환됐다.
                  // final pItem = RestaurantModel.fromJson(
                  //     item,
                  //   );
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

                  return  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => RestaurantDetailScreen(
                          id: pItem.id,
                        ),
                        ),
                      );
                    },
                    child: RestaurantCard.fromModel(
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
                    ),
                  );
                },
                separatorBuilder: (_,index){
                  return const SizedBox(height: 16.0); // 각각의 사이사이에 들어오는 것
                },
              );
            },
          )
        ),
      ),
    );
  }
}
