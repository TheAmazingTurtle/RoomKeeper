import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageStorageService {
  ImageStorageService({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<String?> pickAndStoreInventoryPhoto() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 82,
      maxWidth: 1600,
    );
    if (image == null) {
      return null;
    }
    return storeInventoryPhoto(image);
  }

  Future<String> storeInventoryPhoto(XFile image) async {
    final directory = await _inventoryPhotoDirectory();
    final extension = p.extension(image.path).isEmpty
        ? '.jpg'
        : p.extension(image.path);
    final fileName =
        '${DateTime.now().microsecondsSinceEpoch}_${p.basenameWithoutExtension(image.path)}$extension';
    final destination = File(p.join(directory.path, fileName));
    await File(image.path).copy(destination.path);
    return destination.path;
  }

  Future<Directory> _inventoryPhotoDirectory() async {
    final docs = await getApplicationDocumentsDirectory();
    final directory = Directory(p.join(docs.path, 'inventory_photos'));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }
}
