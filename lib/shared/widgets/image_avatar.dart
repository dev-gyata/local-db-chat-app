import 'package:flutter/material.dart';
import 'package:local_db_chat_app/shared/shared.dart';

class ImageAvatar extends StatelessWidget {
  const ImageAvatar({this.radius = 24, super.key});
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: AppColors.ufoGreen,
        shape: BoxShape.circle,
        image: const DecorationImage(
          image: NetworkImage(
            AppConstants.imageUrl,
          ),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: AppColors.ufoGreen,
          width: 2,
        ),
      ),
    );
  }
}
