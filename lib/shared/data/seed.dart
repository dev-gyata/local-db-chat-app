typedef UserListSeedTypedef =
    List<
      ({
        String name,
        String avatarUrl,
      })
    >;

typedef ChatListSeedTypedef =
    List<
      ({
        int id,
        int userId,
        int unreadCount,
        String message,
        DateTime createdAt,
        bool isSentByMe,
      })
    >;

abstract class Seed {
  static const UserListSeedTypedef userListSeed = [
    (name: 'John Doe', avatarUrl: 'https://i.pravatar.cc/150?img=1'),
    (name: 'Felix', avatarUrl: 'https://i.pravatar.cc/150?img=2'),
    (name: 'Elvis', avatarUrl: 'https://i.pravatar.cc/150?img=3'),
    (name: 'Clarence', avatarUrl: 'https://i.pravatar.cc/150?img=4'),
    (name: 'Sam', avatarUrl: 'https://i.pravatar.cc/150?img=5'),
    (name: 'Paul', avatarUrl: 'https://i.pravatar.cc/150?img=6'),
    (name: 'Elliot', avatarUrl: 'https://i.pravatar.cc/150?img=7'),
    (name: 'Michael', avatarUrl: 'https://i.pravatar.cc/150?img=8'),
    (name: 'Mary', avatarUrl: 'https://i.pravatar.cc/150?img=9'),
    (name: 'Jack', avatarUrl: 'https://i.pravatar.cc/150?img=10'),
  ];

  static ChatListSeedTypedef chatListSeed(List<int> userIds) => [
    (
      id: 1,
      userId: userIds[0],
      unreadCount: 0,
      createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
      message: 'hey',
      isSentByMe: true,
    ),
    (
      id: 2,
      userId: userIds[1],
      unreadCount: 5,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      message: 'Hi how are you?',
      isSentByMe: true,
    ),
    (
      id: 3,
      userId: userIds[2],
      unreadCount: 0,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      message: 'I am going out bro',
      isSentByMe: false,
    ),
    (
      id: 4,
      userId: userIds[3],
      unreadCount: 0,
      createdAt: DateTime.now(),
      message: 'What are you doing darling',
      isSentByMe: false,
    ),
    (
      id: 5,
      userId: userIds[4],
      unreadCount: 1,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      message: 'Hi how are you?',
      isSentByMe: true,
    ),
    (
      id: 6,
      userId: userIds[5],
      unreadCount: 1,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      message: 'Hi how are you?',
      isSentByMe: false,
    ),
    (
      id: 7,
      userId: userIds[6],
      unreadCount: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      message: 'Hi',
      isSentByMe: true,
    ),
    (
      id: 8,
      userId: userIds[7],
      unreadCount: 1,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      message: 'Bro, I am here',
      isSentByMe: false,
    ),
    (
      id: 9,
      userId: userIds[8],
      unreadCount: 1,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      message: 'Lets go',
      isSentByMe: true,
    ),
    (
      id: 10,
      userId: userIds[9],
      unreadCount: 1,
      createdAt: DateTime.now().subtract(const Duration(days: 31)),
      message: 'When will you leave?',
      isSentByMe: false,
    ),
  ];
}
