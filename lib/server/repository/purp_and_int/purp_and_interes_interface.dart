import 'package:meet_now_app/server/model/interes/interest.dart';
import 'package:meet_now_app/server/model/purpose/purpose.dart';

abstract interface class PurpAndInteresInterface {
  Future<List<Interest>> getAllInterest();
  Future<List<Purpose>> getAllPurpose();
}
