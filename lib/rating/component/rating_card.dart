import 'package:code_factory_middle/common/const/colors.dart';
import 'package:code_factory_middle/rating/model/rating_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class RatingCard extends StatelessWidget {
  // ImageProvider -> NetworkImage, AssetImage 관리
  // CircleAvatar 에 넣을 것이라 입력받아서 사용
  final ImageProvider avatarImage; // 아이콘 이미지
  // 리스트로 위젯 이미지를 보여줄떄
  final List<Image> images; // 리뷰 이미지
  final int rating; // 별점
  final String email; // 이메일
  final String content; // 리뷰내용

  const RatingCard({
    super.key,
    required this.avatarImage,
    required this.images,
    required this.rating,
    required this.email,
    required this.content,
  });

  factory RatingCard.fromModel({
    required RatingModel model,
  }) {
    return RatingCard(
      avatarImage: NetworkImage(model.user.imageUrl),
      images: model.imgUrls.map((e) => Image.network(e)).toList(),
      rating: model.rating,
      email: model.user.username,
      content: model.content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(avatarImage: avatarImage, rating: rating, email: email),
        const SizedBox(height: 8.0),
        _Body(content: content),
        if (images.isNotEmpty)
          SizedBox(
            height: 100.0,
            child: _Images(images: images),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage; // 아이콘 이미지
  final String email; // 이메일
  final int rating; // 별점

  const _Header({
    super.key,
    required this.avatarImage,
    required this.email,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: avatarImage,
          radius: 12.0, // 반지름
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...List.generate(
          5,
          (index) => Icon(
            index < rating ? Icons.star_rounded : Icons.star_border_rounded,
            color: PRIMARY_COLOR,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content; // 리뷰내용

  const _Body({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: TextStyle(
              color: BODY_TEXT_COLOR,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images; // 리뷰 이미지

  const _Images({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images
          .mapIndexed(
            (index, element) => Padding(
              padding: EdgeInsets.only(
                right: index == (images.length - 1) ? 0.0 : 16.0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: element,
              ),
            ),
          )
          .toList(),
    );
  }
}
