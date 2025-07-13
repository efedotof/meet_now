import 'package:meet_now_app/server/model/temporary/temporary_chat.dart';

abstract interface class SearchInterface {
  Future<TemporaryChat> randomSearch();
}
