import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:local_db_chat_app/home/widgets/chats_tab.dart';
import 'package:local_db_chat_app/home/widgets/groups_tab.dart';
import 'package:local_db_chat_app/l10n/l10n.dart';
import 'package:local_db_chat_app/shared/shared.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key, this.initalIndex = 0});
  final int initalIndex;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final ValueNotifier<int> selectedIndexNotifier;

  @override
  void initState() {
    super.initState();
    selectedIndexNotifier = ValueNotifier<int>(widget.initalIndex);
  }

  @override
  void dispose() {
    selectedIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.white,
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: AppColors.borderColor,
              width: .8,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...[
                l10n.chats,
                l10n.groups,
              ].mapIndexed((index, text) {
                return Expanded(
                  child: Semantics(
                    button: true,
                    child: GestureDetector(
                      onTap: () {
                        selectedIndexNotifier.value = index;
                      },
                      child: ValueListenableBuilder(
                        valueListenable: selectedIndexNotifier,
                        builder: (context, selectedIndex, child) {
                          final isSelected = selectedIndex == index;
                          return AnimatedContainer(
                            curve: Curves.easeIn,
                            duration: AppConstants.defaultAnimationDuration,
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: isSelected ? AppColors.green2 : null,
                            ),
                            child: Center(
                              child: Text(
                                text,
                                style: TextStyle(
                                  color: isSelected ? AppColors.white : null,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: selectedIndexNotifier,
            builder: (context, selectedIndex, child) {
              return IndexedStack(
                index: selectedIndex,
                children: const [
                  ChatsTab(),
                  GroupsTab(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
