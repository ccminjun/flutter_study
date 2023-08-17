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
import '../provider/restaurant_provider.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, List<RestaurantModel>>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);

    final notifier = RestaurantStateNotifier(repository: repository);

    return notifier;
  },
);

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 불러오면은 생성한다. 생성한채로 그대로 둠. restaurantProvider 한번
    // 생성되면 그대로 유지 됨
    final data = ref.watch(restaurantProvider);

    // 대충의 에러처리
    if(data.length == 0){
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        itemCount: data.length,
        itemBuilder: (_, index) {
          final pItem = data[index];


          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) =>
                    RestaurantDetailScreen(
                      id: pItem.id,
                    ),
                ),
              );
            },
            child: RestaurantCard.fromModel(
              model: pItem,
            ),
          );
        },
        separatorBuilder: (_, index) {
          return const SizedBox(height: 16.0); // 각각의 사이사이에 들어오는 것
        },
      ),
    );
  }
}
