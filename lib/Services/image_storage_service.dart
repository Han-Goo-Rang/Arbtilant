import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageStorageService {
  static final ImageStorageService _instance = ImageStorageService._internal();

  factory ImageStorageService() {
    return _instance;
  }

  ImageStorageService._internal();

  static const String _imageFolder = 'scan_images';

  /// Get the permanent images directory
  Future<Directory> _getImagesDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${directory.path}/$_imageFolder');

    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
      print('✅ Created images directory: ${imageDir.path}');
    }

    return imageDir;
  }

  /// Save image file to permanent location and return the path
  /// This directly moves/renames the temp file instead of copying
  Future<String> saveImage(String tempImagePath, String fileName) async {
    try {
      print("📁 Processing image: $tempImagePath");
      final tempFile = File(tempImagePath);

      if (!await tempFile.exists()) {
        throw Exception('Temp image file not found: $tempImagePath');
      }
      final tempSize = await tempFile.length();
      print("✅ Temp file exists, size: $tempSize bytes");

      final imageDir = await _getImagesDirectory();
      final permanentFile = File('${imageDir.path}/$fileName');

      print("📋 Moving to: ${permanentFile.path}");

      // Try to rename (move) first - faster and more reliable
      try {
        await tempFile.rename(permanentFile.path);
        print('✅ Image moved: ${permanentFile.path}');
      } catch (e) {
        // If rename fails, try copy
        print("⚠️ Rename failed, trying copy: $e");
        await tempFile.copy(permanentFile.path);
        print('✅ Image copied: ${permanentFile.path}');
      }

      // Verify file exists
      if (!await permanentFile.exists()) {
        throw Exception('Failed to save image to permanent location');
      }
      final finalSize = await permanentFile.length();
      print('✅ Image saved successfully ($finalSize bytes)');

      return permanentFile.path;
    } catch (e) {
      print('❌ Error saving image: $e');
      rethrow;
    }
  }

  /// Get image file by path
  Future<File?> getImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        return file;
      }
      print('⚠️ Image file not found: $imagePath');
      return null;
    } catch (e) {
      print('❌ Error getting image: $e');
      return null;
    }
  }

  /// Delete image file
  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        print('✅ Image deleted: $imagePath');
      }
    } catch (e) {
      print('❌ Error deleting image: $e');
    }
  }

  /// Clear all scan images
  Future<void> clearAllImages() async {
    try {
      final imageDir = await _getImagesDirectory();
      if (await imageDir.exists()) {
        await imageDir.delete(recursive: true);
        print('✅ All images cleared');
      }
    } catch (e) {
      print('❌ Error clearing images: $e');
    }
  }
}
