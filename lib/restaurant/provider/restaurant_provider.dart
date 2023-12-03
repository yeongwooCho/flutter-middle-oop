import 'package:code_factory_middle/restaurant/model/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantStateNotifier extends StateNotifier<List<RestaurantModel>> {
  RestaurantStateNotifier() : super([]);
}
