import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/common/layout/default_layout.dart';
import 'package:flutter_study/product/component/product_card.dart';
import 'package:flutter_study/restaurant/model/restaurant_detail_model.dart';

import '../../common/const/data.dart';
import '../component/restaurant_card.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({
    required this.id,
    Key? key}) : super(key: key);

  Future<Map<String, dynamic>> getRestaurantDetail() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant/$id',
      options: Options(
        headers: {'authorization': 'Bearer $accessToken'
        },
      ),
    );

    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 떢복이',
      child: FutureBuilder<Map<String,dynamic>>(
        future: getRestaurantDetail(),
        builder: (_, AsyncSnapshot<Map<String,dynamic>> snapshot) {
          if(!snapshot.hasData){
            return const Center(
              // 로딩하는 부분 추가
              child: CircularProgressIndicator(),
            );
          }

          final item = RestaurantDetailModel.fromJson(
              snapshot.data!,
          );

          return CustomScrollView(
            slivers: [
              renderTop(
                model : item,
              ),
              renderLabel(),
              renderProducts(
                products: item.products,
              ),
            ],
          );
        },
      ), // child:
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
    required RestaurantDetailModel model,
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

