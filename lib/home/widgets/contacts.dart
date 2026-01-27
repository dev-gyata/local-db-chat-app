import 'package:flutter/material.dart';
import 'package:local_db_chat_app/shared/shared.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          spacing: 15,
          children: [
            Semantics(
              button: true,
              child: GestureDetector(
                onTap: () {},
                child: const Column(
                  children: [
                    DottedCircle(
                      child: Icon(
                        Icons.add,
                        color: AppColors.ufoGreen,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Add',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ),
            ...List.generate(
              20,
              (_) => Semantics(
                child: GestureDetector(
                  child: const Column(
                    children: [
                      ImageAvatar(),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 48,
                        child: Text(
                          'Felix',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
