import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db_chat_app/home/bloc/chat_bloc.dart';
import 'package:local_db_chat_app/home/models/contact.dart';
import 'package:local_db_chat_app/home/models/conversation.dart';
import 'package:local_db_chat_app/home/models/item_fetcher.dart';
import 'package:local_db_chat_app/home/repository/chat_repository.dart';
import 'package:local_db_chat_app/home/view/home_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/pump_app.dart';

class MockChatRepository extends Mock implements ChatRepository {}

class TestChatBloc extends ChatBloc {
  TestChatBloc({required super.chatRepository});

  void setStateForTest(ChatState state) => emit(state);
}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('HomePage Golden', () {
    late MockChatRepository mockRepository;

    setUp(() {
      mockRepository = MockChatRepository();
      when(() => mockRepository.onInit()).thenAnswer((_) async {});
      when(
        () => mockRepository.watchConversations(),
      ).thenAnswer((_) => Stream.value([]));
      when(
        () => mockRepository.watchContacts(),
      ).thenAnswer((_) => Stream.value([]));
    });

    testWidgets('HomeView loading matches golden', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await tester.binding.setSurfaceSize(const Size(375, 812));

        final testBloc = TestChatBloc(chatRepository: mockRepository)
          ..setStateForTest(
            const ChatState(
              conversations: ItemFetcher.loading(),
              contacts: ItemFetcher.loading(),
            ),
          );

        await tester.pumpApp(
          RepositoryProvider<ChatRepository>(
            create: (_) => mockRepository,
            child: BlocProvider<ChatBloc>.value(
              value: testBloc,
              child: const HomeView(),
            ),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        await expectLater(
          find.byType(HomeView),
          matchesGoldenFile('goldens/home_view_loading.png'),
        );

        await tester.binding.setSurfaceSize(null);
      });
    });

    testWidgets('HomeView error matches golden', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await tester.binding.setSurfaceSize(const Size(375, 812));

        final testBloc = TestChatBloc(chatRepository: mockRepository)
          ..setStateForTest(
            const ChatState(
              conversations: ItemFetcher.failed('error'),
              contacts: ItemFetcher.failed('error'),
            ),
          );

        await tester.pumpApp(
          RepositoryProvider<ChatRepository>(
            create: (_) => mockRepository,
            child: BlocProvider<ChatBloc>.value(
              value: testBloc,
              child: const HomeView(),
            ),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        await expectLater(
          find.byType(HomeView),
          matchesGoldenFile('goldens/home_view_error.png'),
        );

        await tester.binding.setSurfaceSize(null);
      });
    });

    testWidgets('HomeView loaded matches golden', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await tester.binding.setSurfaceSize(const Size(375, 812));

        final testBloc = TestChatBloc(chatRepository: mockRepository);

        final conversations = List.generate(3, (_) => Conversation.mock());
        final contacts = List.generate(5, (_) => Contact.mock());

        testBloc.setStateForTest(
          ChatState(
            conversations: ItemFetcher.success(conversations),
            contacts: ItemFetcher.success(contacts),
          ),
        );

        await tester.pumpApp(
          RepositoryProvider<ChatRepository>(
            create: (_) => mockRepository,
            child: BlocProvider<ChatBloc>.value(
              value: testBloc,
              child: const HomeView(),
            ),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        await expectLater(
          find.byType(HomeView),
          matchesGoldenFile('goldens/home_view_loaded.png'),
        );

        await tester.binding.setSurfaceSize(null);
      });
    });
  });
}
