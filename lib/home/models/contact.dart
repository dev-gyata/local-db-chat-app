import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  const Contact({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  factory Contact.mock() {
    return const Contact(
      id: 1,
      name: 'John Doe',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
    );
  }

  final int id;
  final String name;
  final String avatarUrl;

  @override
  List<Object?> get props => [id, name, avatarUrl];
}
