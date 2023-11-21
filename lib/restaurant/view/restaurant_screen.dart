import 'package:code_factory_middle/common/const/data.dart';
import 'package:code_factory_middle/restaurant/component/restaurant_card.dart';
import 'package:code_factory_middle/restaurant/model/restaurant_model.dart';
import 'package:code_factory_middle/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant',
      options: Options(headers: {
        "Authorization": 'Bearer $accessToken',
      }),
    );

    return resp.data['data']; // body
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List>(
            future: paginateRestaurant(),
            // builder: (context, snapshot) {
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              print("snapshot.data: ${snapshot.data}"); // List<dynamic>?
              print("snapshot.error: ${snapshot.error}");

              if (!snapshot.hasData) {
                // 물론 데이터가 없을때는 다른 방법으로 제어해야 한다.
                // 임의로 넣은 것이다.
                return Container();
              }
              return ListView.separated(
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  // parsedItem
                  final pItem = RestaurantModel.fromJson(
                    json: item,
                  );

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RestaurantDetailScreen(),
                        ),
                      );
                    },
                    child: RestaurantCard.fromModel(
                      model: pItem,
                    ),
                  );
                },
                separatorBuilder: (_, value) {
                  return const SizedBox(height: 16.0);
                },
                itemCount: snapshot.data!.length, // 어차피 데이터 없으면 위에서 걸린다.
              );
            },
          ),
        ),
      ),
    );
  }
}
