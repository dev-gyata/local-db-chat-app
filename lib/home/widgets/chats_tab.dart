import 'package:flutter/material.dart';
import 'package:local_db_chat_app/shared/shared.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, _) {
        return ListTile(
          onTap: () {},
          title: const Text('Felix'),
          subtitle: const Text('How are you doing?'),
          leading: const ImageAvatar(),
          trailing: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Oct 2'),
              SizedBox(height: 8),
              CircleAvatar(
                radius: 10,
                backgroundColor: AppColors.ufoGreen,
                child: Text(
                  '4',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, _) => const Divider(
        height: 8,
      ),
      itemCount: 20,
    );
  }
}
