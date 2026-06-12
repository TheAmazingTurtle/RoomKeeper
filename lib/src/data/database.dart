import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Areas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get type => text().withDefault(const Constant('custom'))();
  TextColumn get colorHex => text().withDefault(const Constant('#3B82F6'))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {name},
  ];
}

class InventoryItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get areaId => integer().nullable().references(Areas, #id)();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get condition => text().withDefault(const Constant('Good'))();
  TextColumn get notes => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class FoodStocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get areaId => integer().nullable().references(Areas, #id)();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get category => text().withDefault(const Constant('Pantry'))();
  RealColumn get quantity => real().withDefault(const Constant(1))();
  TextColumn get unit => text().withDefault(const Constant('pcs'))();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  RealColumn get lowStockThreshold => real().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class LaundryLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get completedAt => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get nextReminderAt => dateTime().nullable()();
}

class PaymentLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get billType => text().withDefault(const Constant('rent'))();
  TextColumn get billingMonth => text().withLength(min: 7, max: 7)();
  DateTimeColumn get paidAt => dateTime()();
  IntColumn get amountCents => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get nextReminderAt => dateTime().nullable()();
}

class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 140)();
  TextColumn get notes => text().nullable()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  DateTimeColumn get dueAt => dateTime().nullable()();
  DateTimeColumn get reminderAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class RoomLayouts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withDefault(const Constant('My Room'))();
  RealColumn get width => real().withDefault(const Constant(360))();
  RealColumn get height => real().withDefault(const Constant(520))();
  RealColumn get gridSize => real().withDefault(const Constant(20))();
  DateTimeColumn get updatedAt => dateTime()();
}

class LayoutObjects extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get layoutId => integer().references(RoomLayouts, #id)();
  IntColumn get linkedAreaId => integer().nullable().references(Areas, #id)();
  TextColumn get label => text().withLength(min: 1, max: 80)();
  TextColumn get kind => text().withDefault(const Constant('zone'))();
  RealColumn get x => real().withDefault(const Constant(0))();
  RealColumn get y => real().withDefault(const Constant(0))();
  RealColumn get width => real().withDefault(const Constant(100))();
  RealColumn get height => real().withDefault(const Constant(80))();
  RealColumn get rotation => real().withDefault(const Constant(0))();
  TextColumn get colorHex => text().withDefault(const Constant('#3B82F6'))();
  IntColumn get zOrder => integer().withDefault(const Constant(0))();
}

class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ownerType => text().withLength(min: 1, max: 40)();
  IntColumn get ownerId => integer().nullable()();
  TextColumn get title => text().withLength(min: 1, max: 140)();
  TextColumn get body => text().nullable()();
  DateTimeColumn get scheduledAt => dateTime()();
  IntColumn get notificationId => integer()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DriftDatabase(
  tables: [
    Areas,
    InventoryItems,
    FoodStocks,
    LaundryLogs,
    PaymentLogs,
    TodoItems,
    RoomLayouts,
    LayoutObjects,
    Reminders,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) => migrator.createAll(),
    beforeOpen: (OpeningDetails details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'roomkeeper.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
