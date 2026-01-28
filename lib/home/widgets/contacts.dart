import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_db_chat_app/home/bloc/chat_bloc.dart';
import 'package:local_db_chat_app/home/models/contact.dart';
import 'package:local_db_chat_app/shared/shared.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = context.select(
      (ChatBloc bloc) => bloc.state.contacts,
    );
    return contacts.when(
      success: (contacts) {
        return _ContactsList(contacts: contacts);
      },
      failure: (error) {
        return const _ContactsList(contacts: []);
      },
      loading: () {
        final mockContacts = List.generate(
          20,
          (index) => Contact.mock(),
        );
        return Skeletonizer(
          child: _ContactsList(contacts: mockContacts),
        );
      },
    );
  }
}

class _ContactsList extends StatelessWidget {
  const _ContactsList({required this.contacts});
  final List<Contact> contacts;

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
            ...contacts.map(
              (contact) => Semantics(
                child: GestureDetector(
                  child: Column(
                    children: [
                      ImageAvatar(
                        imageUrl: contact.avatarUrl,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 48,
                        child: Text(
                          contact.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.white),
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
