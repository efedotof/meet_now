import 'package:flutter/foundation.dart';
import 'package:meet_now_app/server/model/interes/interest.dart';
import 'package:meet_now_app/server/model/purpose/purpose.dart';
import 'storage_hive_interface.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class StorageHiveRepository implements StorageHiveInterface {
  late Box<Interest> _interestBox;
  late Box<Purpose> _purposeBox;

  @override
  Box<Interest> get interestBox => _interestBox;

  @override
  Box<Purpose> get purposeBox => _purposeBox;

  @override
  ValueListenable<Box<Interest>> get listenableInterestBox =>
      _interestBox.listenable();

  @override
  ValueListenable<Box<Purpose>> get listenablePurposeBox =>
      _purposeBox.listenable();

  @override
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(InterestAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(PurposeAdapter());

    _interestBox = await Hive.openBox<Interest>('interest_box');
    if (_interestBox.isOpen) {
      debugPrint("Box: interest_box is open");
    }

    _purposeBox = await Hive.openBox<Purpose>('purpose_box');
    if (_purposeBox.isOpen) {
      debugPrint("Box: purpose_box is open");
    }
  }

  @override
  Future<void> addInterestBox({required Interest item}) async {
    await _interestBox.add(item);
    debugPrint('StorageRepository: Added item to interestBox => $item');
  }

  @override
  Future<void> addAllInterestBox({required List<Interest> items}) async {
    await _interestBox.addAll(items);
    debugPrint('StorageRepository: Added ${items.length} items to interestBox');
  }

  @override
  Future<void> updateInterestBox({
    required int index,
    required Interest item,
  }) async {
    await _interestBox.putAt(index, item);
    debugPrint(
      'StorageRepository: Updated interestBox at index $index => $item',
    );
  }

  @override
  Future<void> deleteInterestBox({required int index}) async {
    await _interestBox.deleteAt(index);
    debugPrint(
      'StorageRepository: Deleted item from interestBox at index $index',
    );
  }

  @override
  Future<void> clearInterestBox() async {
    await _interestBox.clear();
    debugPrint('StorageRepository: Cleared all items from interestBox');
  }

  @override
  Future<void> addPurposeBox({required Purpose item}) async {
    await _purposeBox.add(item);
    debugPrint('StorageRepository: Added item to purposeBox => $item');
  }

  @override
  Future<void> addAllPurposeBox({required List<Purpose> items}) async {
    await _purposeBox.addAll(items);
    debugPrint('StorageRepository: Added ${items.length} items to purposeBox');
  }

  @override
  Future<void> updatePurposeBox({
    required int index,
    required Purpose item,
  }) async {
    await _purposeBox.putAt(index, item);
    debugPrint(
      'StorageRepository: Updated purposeBox at index $index => $item',
    );
  }

  @override
  Future<void> deletePurposeBox({required int index}) async {
    await _purposeBox.deleteAt(index);
    debugPrint(
      'StorageRepository: Deleted item from purposeBox at index $index',
    );
  }

  @override
  Future<void> clearPurposeBox() async {
    await _purposeBox.clear();
    debugPrint('StorageRepository: Cleared all items from purposeBox');
  }

  @override
  Future<void> clearAll() async {
    await clearInterestBox();
    await clearPurposeBox();
  }

  Future<void> close() async {
    await _interestBox.close();
    await _purposeBox.close();
  }
}
