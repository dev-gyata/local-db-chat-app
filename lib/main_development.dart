import 'package:local_db_chat_app/app/app.dart';
import 'package:local_db_chat_app/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
