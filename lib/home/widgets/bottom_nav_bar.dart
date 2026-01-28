import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:local_db_chat_app/shared/theme/colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, this.onTap, this.selectedIndex = 0});
  final ValueChanged<int>? onTap;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(
            color: AppColors.textMuted,
            size: 20,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...[
              Icons.home,
              Icons.call,
              Icons.add_circle,
              Icons.camera_alt_rounded,
              Icons.person_2,
            ].mapIndexed((index, icon) {
              final isSelected = selectedIndex == index;
              return Column(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      onTap?.call(index);
                    },
                    icon: Column(
                      children: [
                        Icon(
                          icon,
                          color: switch (isSelected) {
                            true => AppColors.white,
                            _ when icon == Icons.add_circle => AppColors.white,
                            _ => null,
                          },
                          size: icon == Icons.add_circle ? 32 : null,
                        ),
                        if (isSelected) ...[
                          const CircleAvatar(
                            radius: 2,
                            backgroundColor: AppColors.white,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
