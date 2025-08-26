import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:meet_now_app/server/model/interes/interest.dart';
import 'package:meet_now_app/server/model/purpose/purpose.dart';

abstract interface class StorageHiveInterface {
  Future<void> init();

  Box<Interest> get interestBox;
  Box<Purpose> get purposeBox;

  ValueListenable<Box<Interest>> get listenableInterestBox;
  ValueListenable<Box<Purpose>> get listenablePurposeBox;

  Future<void> addInterestBox({required Interest item});
  Future<void> addAllInterestBox({required List<Interest> items});
  Future<void> updateInterestBox({required int index, required Interest item});
  Future<void> deleteInterestBox({required int index});
  Future<void> clearInterestBox();

  Future<void> addPurposeBox({required Purpose item});
  Future<void> addAllPurposeBox({required List<Purpose> items});
  Future<void> updatePurposeBox({required int index, required Purpose item});
  Future<void> deletePurposeBox({required int index});
  Future<void> clearPurposeBox();

  Future<void> clearAll();
}
