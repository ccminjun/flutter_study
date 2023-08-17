import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/restaurant/model/restaurant_model.dart';

import '../repository/restaurant_repository.dart';


// RestaurantStateNotifier 생성이 되는 순간 paginate 가 됨
class RestaurantStateNotifier extends StateNotifier<List<RestaurantModel>>{
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super([]){
    paginate();
  }

  paginate()async{
    final resp = await repository.paginate();

    state = resp.data;
  }
}