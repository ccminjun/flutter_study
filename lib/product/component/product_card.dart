import 'package:flutter/material.dart';
import 'package:flutter_study/common/const/colors.dart';
import 'package:flutter_study/restaurant/model/restaurant_detail_model.dart';

class ProductCard extends StatelessWidget {

  // 'asset/img/food/ddeok_bok_gi.jpg',
  // width: 110,
  // height: 110,
  // // 이미지 정사각형되게
  // fit: BoxFit.cover,
  //

  final Image image;
  final String name;
  final String detail;
  final int price;

  const ProductCard({
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    Key? key
  }) : super(key: key);

  factory ProductCard.fromModel({
    required RestaurantProductModel model,
}){
    return ProductCard(
      image: Image.network(
          model.imgUrl,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
    );
  }


  @override
  Widget build(BuildContext context) {


    // 이렇게 해줘야 Expanded된 것의 크기를 끝까지 키울 수 있음
    return IntrinsicHeight(
      // 좌에서 우로 배치할때는 Row 위젯
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              8.0,),
            child: image,
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // 이렇게 넣어도 안바뀐다. 공간이 작게 가져가기 때문에
              // children 안에다 넣으면 각각 고유의 높이를 가져가기 때문에
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  detail,
                  // ellipsis = 넘어가면 ... 으로 표현
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    color: BODY_TEXT_COLOR,
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  '￦$price',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: PRIMARY_COLOR,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
