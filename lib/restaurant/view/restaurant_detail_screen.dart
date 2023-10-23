import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/common/dio/dio.dart';
import 'package:flutter_study/common/layout/default_layout.dart';
import 'package:flutter_study/common/model/cursor_pagination_model.dart';
import 'package:flutter_study/product/component/product_card.dart';
import 'package:flutter_study/rating/component/rating_card.dart';
import 'package:flutter_study/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_study/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_study/restaurant/provider/restaurant_rating_provider.dart';
import 'package:flutter_study/restaurant/repository/restaurant_repository.dart';
import 'package:skeletons/skeletons.dart';

import '../../common/const/data.dart';
import '../../rating/model/rating_model.dart';
import '../component/restaurant_card.dart';
import '../model/restaurant_model.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const RestaurantDetailScreen({
    required this.id,
    Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //디테일 화면에 갈때마다 디테일 정보를 가져옴
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }


  @override
  Widget build(BuildContext context) {

    final state = ref.watch(restaurantDetailProvider(widget.id));

    final ratingState = ref.watch(restaurantRatingProvider(widget.id));

    if(state ==null) {
      return DefaultLayout(
          child: Center(
            child: CircularProgressIndicator(),
          ),
      );
    }

    return DefaultLayout(
        title: '불타는 떢복이',
        child: CustomScrollView(
          slivers: [
            renderTop(
              model: state,
            ),
            if(state is! RestaurantDetailModel) renderLoading(),
            if(state is RestaurantDetailModel)
            renderLabel(),
            if(state is RestaurantDetailModel)
            renderProducts(
              products: state.products,
            ),
            if(ratingState is CursorPagination<RatingModel>)
            renderRatings(models: ratingState.data),
          ],
        )
    );
  }

  SliverPadding renderRatings({
  required List<RatingModel> models,
}){
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => Padding(
              padding: const EdgeInsets.only(bottom:16.0),
              child: RatingCard.fromModel(
                model: models[index],
              ),
            ),
            childCount: models.length,
          ),
        )
    );
  }

  SliverPadding renderLoading(){
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: SkeletonParagraph(
              style: SkeletonParagraphStyle(
                lines: 5,
                // 줄 간격 사이 없애는 것
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        )),
      ),
    );
  }

  SliverPadding renderLabel() {
    return  const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SliverPadding renderProducts({
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];

            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(
                model: model,
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  // 일반 위젯을 넣으려면 SliverToBoxAdapter 써줘야 됨
  SliverToBoxAdapter renderTop({
    required RestaurantModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
        // image: Image.asset('asset/img/food/ddeok_bok_gi.jpg'),
        // name: '불타는 떡볶이',
        // tags: ['떡볶이', '맛있음', '치즈'],
        // ratingsCount: 100,
        // deliveryTime: 30,
        // deliveryFee: 3000,
        // ratings: 4.76,
        // isDetail: true,
        // detail: '맛있는 떡볶이',
      ),
    );
  }
}

