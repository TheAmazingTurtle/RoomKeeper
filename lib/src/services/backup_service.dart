import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/database.dart';

class BackupService {
  BackupService(
    this._db, {
    Future<Directory> Function()? documentsDirectory,
    Future<Directory> Function()? temporaryDirectory,
  }) : _documentsDirectory =
           documentsDirectory ?? getApplicationDocumentsDirectory,
       _temporaryDirectory = temporaryDirectory ?? getTemporaryDirectory;

  final AppDatabase _db;
  final Future<Directory> Function() _documentsDirectory;
  final Future<Directory> Function() _temporaryDirectory;

  Future<String> exportJson() async {
    final inventory = await _db.select(_db.inventoryItems).get();
    final envelope = <String, Object?>{
      'schemaVersion': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'tables': {
        'areas': (await _db.select(_db.areas).get())
            .map((row) => row.toJson())
            .toList(),
        'inventoryItems': inventory.map((row) => row.toJson()).toList(),
        'foodStocks': (await _db.select(_db.foodStocks).get())
            .map((row) => row.toJson())
            .toList(),
        'laundryLogs': (await _db.select(_db.laundryLogs).get())
            .map((row) => row.toJson())
            .toList(),
        'paymentLogs': (await _db.select(_db.paymentLogs).get())
            .map((row) => row.toJson())
            .toList(),
        'todoItems': (await _db.select(_db.todoItems).get())
            .map((row) => row.toJson())
            .toList(),
        'roomLayouts': (await _db.select(_db.roomLayouts).get())
            .map((row) => row.toJson())
            .toList(),
        'layoutObjects': (await _db.select(_db.layoutObjects).get())
            .map((row) => row.toJson())
            .toList(),
        'reminders': (await _db.select(_db.reminders).get())
            .map((row) => row.toJson())
            .toList(),
      },
      'photos': await _encodedInventoryPhotos(inventory),
    };

    return const JsonEncoder.withIndent('  ').convert(envelope);
  }

  Future<File> writeBackupFile() async {
    final directory = await _temporaryDirectory();
    return _writeBackupFile(directory);
  }

  Future<File> saveBackupFile() async {
    final documents = await _documentsDirectory();
    final directory = Directory(
      p.join(documents.path, 'RoomKeeper', 'backups'),
    );
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return _writeBackupFile(directory);
  }

  Future<File> _writeBackupFile(Directory directory) async {
    final json = await exportJson();
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    final file = File(p.join(directory.path, 'roomkeeper_backup_$stamp.json'));
    await file.writeAsString(json);
    return file;
  }

  Future<void> shareBackupFile() async {
    final file = await writeBackupFile();
    await Share.shareXFiles([
      XFile(file.path, mimeType: 'application/json'),
    ], text: 'RoomKeeper local backup');
  }

  Future<bool> importFromPicker() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    final path = result?.files.single.path;
    if (path == null) {
      return false;
    }
    await importJson(await File(path).readAsString());
    return true;
  }

  Future<void> importJson(String rawJson) async {
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('RoomKeeper backup must be a JSON object.');
    }
    if (decoded['schemaVersion'] != 1) {
      throw const FormatException('Unsupported RoomKeeper backup version.');
    }

    final tables = decoded['tables'];
    if (tables is! Map<String, Object?>) {
      throw const FormatException('RoomKeeper backup is missing tables.');
    }

    final photos = decoded['photos'] is Map
        ? Map<String, Object?>.from(decoded['photos'] as Map)
        : <String, Object?>{};

    await _db.transaction(() async {
      await _deleteAll();
      await _db.batch((batch) {
        batch.insertAll(
          _db.areas,
          _rows(
            tables,
            'areas',
          ).map((json) => Area.fromJson(json).toCompanion(true)),
        );
        batch.insertAll(
          _db.inventoryItems,
          _rows(tables, 'inventoryItems').map((json) {
            final row = Map<String, Object?>.from(json);
            if (!photos.containsKey('${row['id']}')) {
              row['photoPath'] = null;
            }
            return InventoryItem.fromJson(row).toCompanion(true);
          }),
        );
        batch.insertAll(
          _db.foodStocks,
          _rows(
            tables,
            'foodStocks',
          ).map((json) => FoodStock.fromJson(json).toCompanion(true)),
        );
        batch.insertAll(
          _db.laundryLogs,
          _rows(
            tables,
            'laundryLogs',
          ).map((json) => LaundryLog.fromJson(json).toCompanion(true)),
        );
        batch.insertAll(
          _db.paymentLogs,
          _rows(
            tables,
            'paymentLogs',
          ).map((json) => PaymentLog.fromJson(json).toCompanion(true)),
        );
        batch.insertAll(
          _db.todoItems,
          _rows(
            tables,
            'todoItems',
          ).map((json) => TodoItem.fromJson(json).toCompanion(true)),
        );
        batch.insertAll(
          _db.roomLayouts,
          _rows(
            tables,
            'roomLayouts',
          ).map((json) => RoomLayout.fromJson(json).toCompanion(true)),
        );
        batch.insertAll(
          _db.layoutObjects,
          _rows(
            tables,
            'layoutObjects',
          ).map((json) => LayoutObject.fromJson(json).toCompanion(true)),
        );
        batch.insertAll(
          _db.reminders,
          _rows(
            tables,
            'reminders',
          ).map((json) => Reminder.fromJson(json).toCompanion(true)),
        );
      });
    });

    await _restoreInventoryPhotos(photos);
  }

  Future<Map<String, Object?>> _encodedInventoryPhotos(
    List<InventoryItem> inventory,
  ) async {
    final result = <String, Object?>{};
    for (final item in inventory) {
      final path = item.photoPath;
      if (path == null) {
        continue;
      }
      final file = File(path);
      if (!await file.exists()) {
        continue;
      }
      result['${item.id}'] = {
        'fileName': p.basename(path),
        'base64': base64Encode(await file.readAsBytes()),
      };
    }
    return result;
  }

  Future<void> _restoreInventoryPhotos(Map<String, Object?> photos) async {
    if (photos.isEmpty) {
      return;
    }

    final docs = await _documentsDirectory();
    final photoDirectory = Directory(p.join(docs.path, 'inventory_photos'));
    if (!await photoDirectory.exists()) {
      await photoDirectory.create(recursive: true);
    }

    for (final entry in photos.entries) {
      final itemId = int.tryParse(entry.key);
      final payload = entry.value;
      if (itemId == null || payload is! Map) {
        continue;
      }

      final photoJson = Map<String, Object?>.from(payload);
      final encoded = photoJson['base64'];
      if (encoded is! String) {
        continue;
      }

      final fileName = photoJson['fileName'] is String
          ? photoJson['fileName'] as String
          : 'inventory_$itemId.jpg';
      final safeName = fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
      final file = File(
        p.join(
          photoDirectory.path,
          '${DateTime.now().microsecondsSinceEpoch}_$safeName',
        ),
      );
      await file.writeAsBytes(base64Decode(encoded));
      await (_db.update(_db.inventoryItems)
            ..where((table) => table.id.equals(itemId)))
          .write(InventoryItemsCompanion(photoPath: Value(file.path)));
    }
  }

  List<Map<String, Object?>> _rows(Map<String, Object?> tables, String name) {
    final rows = tables[name];
    if (rows is! List) {
      return const [];
    }
    return rows.map((row) => Map<String, Object?>.from(row as Map)).toList();
  }

  Future<void> _deleteAll() async {
    await _db.delete(_db.reminders).go();
    await _db.delete(_db.layoutObjects).go();
    await _db.delete(_db.roomLayouts).go();
    await _db.delete(_db.todoItems).go();
    await _db.delete(_db.paymentLogs).go();
    await _db.delete(_db.laundryLogs).go();
    await _db.delete(_db.foodStocks).go();
    await _db.delete(_db.inventoryItems).go();
    await _db.delete(_db.areas).go();
  }
}
