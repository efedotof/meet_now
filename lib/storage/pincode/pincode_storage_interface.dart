abstract interface class PincodeStorageInterface {
  String getPinCode();
  Future<void> setPinCode({required String pincode});
  Future<void> clearPinCode();
}
