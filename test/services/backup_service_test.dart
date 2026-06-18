import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:roomkeeper/src/data/roomkeeper_repository.dart';
import 'package:roomkeeper/src/providers.dart';
import 'package:roomkeeper/src/services/backup_service.dart';

void main() {
  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  test(
    'backup export and import round-trips records and inventory photos',
    () async {
      final sourceDb = inMemoryDatabaseForTests();
      final targetDb = inMemoryDatabaseForTests();
      addTearDown(sourceDb.close);
      addTearDown(targetDb.close);

      final temp = await Directory.systemTemp.createTemp(
        'roomkeeper_backup_test',
      );
      addTearDown(() => temp.delete(recursive: true));
      final sourcePhoto = File('${temp.path}/photo.jpg');
      await sourcePhoto.writeAsBytes([1, 2, 3, 4, 5]);

      final sourceRepo = RoomkeeperRepository(sourceDb);
      await sourceRepo.ensureDefaults();
      final bed = (await sourceRepo.getAreas()).firstWhere(
        (area) => area.name == 'Bed',
      );
      await sourceRepo.addInventoryItem(
        name: 'Pillow',
        areaId: bed.id,
        photoPath: sourcePhoto.path,
      );
      await sourceRepo.addTodoItem(title: 'Wash pillowcase');

      final sourceBackup = BackupService(
        sourceDb,
        documentsDirectory: () async => Directory('${temp.path}/source_docs'),
        temporaryDirectory: () async => temp,
      );
      final json = await sourceBackup.exportJson();

      final targetRepo = RoomkeeperRepository(targetDb);
      final targetBackup = BackupService(
        targetDb,
        documentsDirectory: () async => Directory('${temp.path}/target_docs'),
        temporaryDirectory: () async => temp,
      );
      await targetBackup.importJson(json);

      final items = await targetRepo.getInventoryItems();
      expect(items, hasLength(1));
      expect(items.single.name, 'Pillow');
      expect(items.single.photoPath, isNotNull);
      expect(await File(items.single.photoPath!).exists(), isTrue);
    },
  );

  test('save backup writes to a dedicated RoomKeeper backups folder', () async {
    final database = inMemoryDatabaseForTests();
    addTearDown(database.close);

    final temp = await Directory.systemTemp.createTemp(
      'roomkeeper_save_backup_test',
    );
    addTearDown(() => temp.delete(recursive: true));
    final existingFolder = Directory('${temp.path}/RoomKeeper/backups');
    await existingFolder.create(recursive: true);

    final repository = RoomkeeperRepository(database);
    await repository.ensureDefaults();

    final backup = BackupService(
      database,
      documentsDirectory: () async => temp,
      temporaryDirectory: () async => Directory('${temp.path}/tmp'),
    );
    final file = await backup.saveBackupFile();

    expect(file.path, contains('RoomKeeper'));
    expect(file.path, contains('backups'));
    expect(file.path, endsWith('.json'));
    expect(await file.exists(), isTrue);
    expect(await existingFolder.exists(), isTrue);
  });
}
