import 'package:flutter/material.dart';
import 'package:local_db_chat_app/l10n/l10n.dart';

class GroupsTab extends StatelessWidget {
  const GroupsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(child: Text(l10n.groups));
  }
}
