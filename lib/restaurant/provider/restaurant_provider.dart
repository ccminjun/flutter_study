import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/common/model/cursor_pagination_model.dart';
import 'package:flutter_study/common/provider/pagination_provider.dart';
import 'package:flutter_study/restaurant/model/restaurant_model.dart';

import '../repository/restaurant_repository.dart';

// 레스토랑 디테일을 생성할때 provider에 id값을 넣어줌
final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  // 커서페이지네이션이 아니라는 뜻은 리스트가 없다는 뜻
  if (state is! CursorPagination) {
    return null;
  }


  // 입력해준 id에 해당하는 id를 반환한다.
  return state.data.firstWhere((element) => element.id == id);
  
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);

    final notifier = RestaurantStateNotifier(repository: repository);

    return notifier;
  },
);

// RestaurantStateNotifier 생성이 되는 순간 paginate 가 됨
class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  //extends StateNotifier<CursorPaginationBase> {
  // final RestaurantRepository repository;

  RestaurantStateNotifier({
    // required this.repository,
    required super.repository,
  });
  // : super(CursorPaginationLoading()) {
  //   paginate();
  // }

  getDetail({
    required String id,
  }) async {
    // 만약에 아직 데이터가 하나도 없는 상태라면 (CursorPagination이 아니라면)
    // 데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await this.paginate();
    }

    // state가 CursorPagination이 아닐 때 그냥 리턴
    if (state is! CursorPagination) {
      return;
    }

    // 여기까지 오면 무조건 CursorPagination
    final pState = state as CursorPagination;

    final resp = await repository.getRestaurantDetail(id: id);

    // [RestaurantModel(1), RestaurantModel(2), RestaurantModel(3)]
    //  id : 2인 친구를 Detail 모델을 가져와라
    //  getDetail(id:2)
    // [RestaurantMode(1), RestaurantModeDetailModel(2), RestaurantMode(3)]

    // pState 안에 데이터를 루프돌면서 데이터의 id가 함수에서 입력한 id랑 똑같으면 새로입력한
    // 아이디로 대체, 아닐경우 원래 데이터 반환
    state = pState.copyWith(
      data: pState.data
          .map<RestaurantModel>(
            (e) => e.id == id ? resp : e,
          )
          .toList(),
    );
  }
}
