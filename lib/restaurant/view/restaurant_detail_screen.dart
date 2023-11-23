import 'package:code_factory_middle/common/layout/default_layout.dart';
import 'package:code_factory_middle/product/component/product_card.dart';
import 'package:code_factory_middle/restaurant/model/restaurant_detail_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/const/data.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder<Map<String, dynamic>>(
        future: getRestaurantDetail(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          print("RestaurantDetailScreen snapshot.error: ${snapshot.error}");
          print("RestaurantDetailScreen snapshot.data: ${snapshot.data}");

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final item = RestaurantDetailModel.fromJson(json: snapshot.data!);

          return CustomScrollView(
            slivers: [
              renderTop(),
              renderLabel(),
              renderProducts(),
            ],
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getRestaurantDetail() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final resp = await dio.get(
      'http://$ip/restaurant/$id',
      options: Options(
        headers: {
          'Authorization': "Bearer $accessToken",
        },
      ),
    );
    return resp.data;
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  SliverPadding renderProducts() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: ProductCard(),
          ),
          childCount: 10,
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop() {
    return SliverToBoxAdapter(
      child: Text(
        'adfs',
        style: TextStyle(
          fontSize: 24.0,
        ),
      ),
    );
  }
}
