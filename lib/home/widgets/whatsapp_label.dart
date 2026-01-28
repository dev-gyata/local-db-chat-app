import 'package:flutter/material.dart';
import 'package:local_db_chat_app/shared/resources/resources.dart';
import 'package:local_db_chat_app/shared/theme/colors.dart';

class WhatsappLabel extends StatelessWidget {
  const WhatsappLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        children: [
          Image.asset(
            Images.whatsapp,
            width: 30,
            height: 30,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            width: 8,
          ),
          const Text(
            'Whatsapp',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
