abstract interface class UploadImageInterface {
  Future<String> uploadAvatar(String filePath);
  Future<List<String>> uploadsImages(List<String> filesPath);
}
