import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/common/model/cursor_pagination_model.dart';
import 'package:flutter_study/common/model/pagination_params.dart';
import 'package:flutter_study/restaurant/model/restaurant_model.dart';

import '../repository/restaurant_repository.dart';


// RestaurantStateNotifier 생성이 되는 순간 paginate 가 됨
class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase>{
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()){
    paginate();
  }

  void paginate({
    int fetchCount = 20,
    // 데이터가 있는 상태인데 마지막값에 추가로 데이터를 가져와라
    // true -- 추가로 데이터 더 가져옴
    // false -- 새로고침(현재 상태를 덮어씌움)
    bool fetchMore = false,
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    // 5가지 가능성 CursorPaginationBase가 5개이기 때문에
    // State의 상태

    // [상태가]
    // 1) CursorPagination - 정상적으로 데이터가 있는 상태
    // 2) CursorPaginationLoading - 데이터가 로딩중인 상태(현재 캐시 없음)
    // 3) CursorPaginationError - 에러가 있는 상태
    // 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져 올 때
    // 5) CursorPaginationFetcMore - 추가 데이터를 paginate 해오라는 요청을 받았을때때

    // 바로 반환하는 상황
    // 1) hasMore = false ( 기존 상태에서 이미 다음 데이터가 업다)
    // 2) 로딩중 - fetchMore : true 앱에서 스크롤을 가서 더 추가를 가져와라
    //     fetchMore 아닐때 - 새로고침에 의도가 있을 수 있다.
    if(state is CursorPagination && !forceRefetch){
      final pState = state as CursorPagination;

      if(!pState.meta.hasMore){
        return;
      }
    }
    final isLoading = state is CursorPaginationLoading;
    final isRefectching = state is CursorPaginationRefetching;
    final isFetchingMore = state is CursorPaginationFetchingMore;
    
    // 2번 반환 상환
    if(fetchMore && (isLoading || isRefectching || isFetchingMore)){
      return;
    }

    // PaginationParams 생성
    PaginationParams paginationParams = PaginationParams(
      count: fetchCount,
    );

    // fetchMore
    // 데이터를 추가로 더 가져오는 상황
    if(fetchMore){
      // 데이터를 가지고 있어야 하니까 CursorPagination을 extend하고 있어야 한다.
      final pState = state as CursorPagination;

      // 데이터를 더 가져올꺼니까 형태를 바꿔줄꺼니까 바꿔준다.
      state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
      );

      // 페이지네이션 가져와서 마지막꺼에 id를 넣어줘야하니까 이해가죠??쉽다!!명강의!!
      paginationParams = paginationParams.copyWith(
        after: pState.data.last.id,
      );
    }

    final resp = await repository.paginate(
      paginationParams: paginationParams,
    );

    if(state is CursorPaginationFetchingMore){
      final pState = state as CursorPaginationFetchingMore;

      // 기존 데이터에
      // 새로운 데이터 추가
      state = resp.copyWith(
        //최신데이터를 가져올것이므로
        data: [
          // 기존에 있던 데이터
          ...pState.data,
          // 새로운 데이터
          ...resp.data
        ]
      );
    }
  }
}