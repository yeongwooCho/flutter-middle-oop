import 'package:code_factory_middle/common/layout/default_layout.dart';
import 'package:code_factory_middle/restaurant/component/restaurant_card.dart';
import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: Column(
        children: [
          // RestaurantCard(
          //   image: image,
          //   name: name,
          //   tags: tags,
          //   ratingsCount: ratingsCount,
          //   deliveryTime: deliveryTime,
          //   deliveryFee: deliveryFee,
          //   ratings: ratings,
          // ),
        ],
      ),
    );
  }
}
