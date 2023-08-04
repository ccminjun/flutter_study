import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

import '../model/restaurant_detail_model.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository{
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
    _RestaurantRepository;


  // http://$ip/restaurant/
  // 페이지네이트 하는 부분 가져오는 것
  // @GET('/')
  // paginate();

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




