import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/common/model/pagination_params.dart';
import 'package:flutter_study/common/repository/base_pagination_repository.dart';
import 'package:flutter_study/restaurant/model/restaurant_model.dart';
import 'package:retrofit/http.dart';

import '../../common/const/data.dart';
import '../../common/dio/dio.dart';
import '../../common/model/cursor_pagination_model.dart';
import '../model/restaurant_detail_model.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    final repository =
        RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

    return repository;
  },
);

@RestApi()
abstract class RestaurantRepository
    implements IBasePaginationRepository<RestaurantModel>{
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
    _RestaurantRepository;

  // http://$ip/restaurant/
  // 페이지네이트 하는 부분 가져오는 것
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  // http://$ip/restaurant/:id/
  // 레스토랑 상세 정보 가져오는 것
  @GET('/{id}')
  @Headers({
    'accessToken' : 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}




