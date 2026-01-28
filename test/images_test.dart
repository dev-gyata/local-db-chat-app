import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_db_chat_app/shared/resources/resources.dart';

void main() {
  test('images assets test', () {
    expect(File(Images.whatsapp).existsSync(), isTrue);
  });
}
