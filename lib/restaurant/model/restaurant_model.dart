import 'package:code_factory_middle/common/model/model_with_id.dart';
import 'package:code_factory_middle/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

@JsonSerializable()
class RestaurantModel implements IModelWithId {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

// // json 으로부터 인스턴스를 만든다.
// factory RestaurantModel.fromJson({
//   required Map<String, dynamic> json, // json 은 항상 이렇다.
// }) {
//   return RestaurantModel(
//     id: json['id'],
//     name: json['name'],
//     thumbUrl: 'http://$ip${json['thumbUrl']}',
//     tags: List<String>.from(json['tags']),
//     priceRange: RestaurantPriceRange.values.firstWhere(
//       (element) => element.name == json['priceRange'],
//     ),
//     ratings: json['ratings'],
//     ratingsCount: json['ratingsCount'],
//     deliveryTime: json['deliveryTime'],
//     deliveryFee: json['deliveryFee'],
//   );
// }
}
