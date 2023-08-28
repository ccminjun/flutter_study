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



class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {

  final ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.addListener(scrollListener);
  }

  void scrollListener(){
    // 현재 위치가
    // 최대 길이보다 조금 덜되는 위치까지 왔다면
    // 새로운 데이터를 추가 요청
    // 300픽셀만큼 적은 지점
    if(controller.offset > controller.position.maxScrollExtent - 300){
      ref.read(restaurantProvider.notifier).paginate(
        fetchMore: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 불러오면은 생성한다. 생성한채로 그대로 둠. restaurantProvider 한번
    // 생성되면 그대로 유지 됨
    final data = ref.watch(restaurantProvider);

    // 완전 처음 로딩일 때
    if(data is CursorPaginationLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러
    if(data is CursorPaginationError){
      return Center(
        child: Text(data.message),
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefeching

    // 중간 단계로 씀
    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: controller,
        itemCount: cp.data.length +1,
        itemBuilder: (_, index) {
          if(index == cp.data.length){
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Center(
                child: data is CursorPaginationFetchingMore
                    ? CircularProgressIndicator()
                    : Text('마지막 데이터입니다 ㅜㅜ'),
              ),
            );
          }

          final pItem = cp.data[index];


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
