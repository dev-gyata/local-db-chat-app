import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_db_chat_app/home/bloc/chat_bloc.dart';
import 'package:local_db_chat_app/home/repository/chat_repository.dart';
import 'package:local_db_chat_app/home/repository/chat_repository_impl.dart';
import 'package:local_db_chat_app/home/widgets/bottom_nav_bar.dart';
import 'package:local_db_chat_app/home/widgets/contacts.dart';
import 'package:local_db_chat_app/home/widgets/home_tab.dart';
import 'package:local_db_chat_app/shared/db/local_db.dart';
import 'package:local_db_chat_app/shared/shared.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ChatRepository>(
      create: (context) => ChatRepositoryImpl(localDb: LocalDb()),
      child: BlocProvider(
        create: (context) => ChatBloc(
          chatRepository: context.read<ChatRepository>(),
        )..add(const InitializeChatBloc()),
        child: const HomeView(),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              spacing: 20,
              children: [
                const SizedBox(height: 10),
                const Contacts(),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      color: AppColors.white,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(child: HomeTab()),
                          SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Positioned(
              bottom: 20,
              right: 0,
              left: 0,
              child: BottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }
}
