// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AreasTable extends Areas with TableInfo<$AreasTable, Area> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AreasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('custom'),
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#3B82F6'),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, type, colorHex, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'areas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Area> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {name},
  ];
  @override
  Area map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Area(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $AreasTable createAlias(String alias) {
    return $AreasTable(attachedDatabase, alias);
  }
}

class Area extends DataClass implements Insertable<Area> {
  final int id;
  final String name;
  final String type;
  final String colorHex;
  final int sortOrder;
  const Area({
    required this.id,
    required this.name,
    required this.type,
    required this.colorHex,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['color_hex'] = Variable<String>(colorHex);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  AreasCompanion toCompanion(bool nullToAbsent) {
    return AreasCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      colorHex: Value(colorHex),
      sortOrder: Value(sortOrder),
    );
  }

  factory Area.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Area(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'colorHex': serializer.toJson<String>(colorHex),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Area copyWith({
    int? id,
    String? name,
    String? type,
    String? colorHex,
    int? sortOrder,
  }) => Area(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    colorHex: colorHex ?? this.colorHex,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Area copyWithCompanion(AreasCompanion data) {
    return Area(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Area(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('colorHex: $colorHex, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, colorHex, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Area &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.colorHex == this.colorHex &&
          other.sortOrder == this.sortOrder);
}

class AreasCompanion extends UpdateCompanion<Area> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> colorHex;
  final Value<int> sortOrder;
  const AreasCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  AreasCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.type = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Area> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? colorHex,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (colorHex != null) 'color_hex': colorHex,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  AreasCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String>? colorHex,
    Value<int>? sortOrder,
  }) {
    return AreasCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      colorHex: colorHex ?? this.colorHex,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AreasCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('colorHex: $colorHex, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $InventoryItemsTable extends InventoryItems
    with TableInfo<$InventoryItemsTable, InventoryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _areaIdMeta = const VerificationMeta('areaId');
  @override
  late final GeneratedColumn<int> areaId = GeneratedColumn<int>(
    'area_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES areas (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _conditionMeta = const VerificationMeta(
    'condition',
  );
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Good'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    areaId,
    name,
    quantity,
    condition,
    notes,
    photoPath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('area_id')) {
      context.handle(
        _areaIdMeta,
        areaId.isAcceptableOrUnknown(data['area_id']!, _areaIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      areaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}area_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      condition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InventoryItemsTable createAlias(String alias) {
    return $InventoryItemsTable(attachedDatabase, alias);
  }
}

class InventoryItem extends DataClass implements Insertable<InventoryItem> {
  final int id;
  final int? areaId;
  final String name;
  final int quantity;
  final String condition;
  final String? notes;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const InventoryItem({
    required this.id,
    this.areaId,
    required this.name,
    required this.quantity,
    required this.condition,
    this.notes,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || areaId != null) {
      map['area_id'] = Variable<int>(areaId);
    }
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<int>(quantity);
    map['condition'] = Variable<String>(condition);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InventoryItemsCompanion toCompanion(bool nullToAbsent) {
    return InventoryItemsCompanion(
      id: Value(id),
      areaId: areaId == null && nullToAbsent
          ? const Value.absent()
          : Value(areaId),
      name: Value(name),
      quantity: Value(quantity),
      condition: Value(condition),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory InventoryItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryItem(
      id: serializer.fromJson<int>(json['id']),
      areaId: serializer.fromJson<int?>(json['areaId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<int>(json['quantity']),
      condition: serializer.fromJson<String>(json['condition']),
      notes: serializer.fromJson<String?>(json['notes']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'areaId': serializer.toJson<int?>(areaId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<int>(quantity),
      'condition': serializer.toJson<String>(condition),
      'notes': serializer.toJson<String?>(notes),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  InventoryItem copyWith({
    int? id,
    Value<int?> areaId = const Value.absent(),
    String? name,
    int? quantity,
    String? condition,
    Value<String?> notes = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => InventoryItem(
    id: id ?? this.id,
    areaId: areaId.present ? areaId.value : this.areaId,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    condition: condition ?? this.condition,
    notes: notes.present ? notes.value : this.notes,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InventoryItem copyWithCompanion(InventoryItemsCompanion data) {
    return InventoryItem(
      id: data.id.present ? data.id.value : this.id,
      areaId: data.areaId.present ? data.areaId.value : this.areaId,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      condition: data.condition.present ? data.condition.value : this.condition,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItem(')
          ..write('id: $id, ')
          ..write('areaId: $areaId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('condition: $condition, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    areaId,
    name,
    quantity,
    condition,
    notes,
    photoPath,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryItem &&
          other.id == this.id &&
          other.areaId == this.areaId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.condition == this.condition &&
          other.notes == this.notes &&
          other.photoPath == this.photoPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InventoryItemsCompanion extends UpdateCompanion<InventoryItem> {
  final Value<int> id;
  final Value<int?> areaId;
  final Value<String> name;
  final Value<int> quantity;
  final Value<String> condition;
  final Value<String?> notes;
  final Value<String?> photoPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const InventoryItemsCompanion({
    this.id = const Value.absent(),
    this.areaId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.condition = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  InventoryItemsCompanion.insert({
    this.id = const Value.absent(),
    this.areaId = const Value.absent(),
    required String name,
    this.quantity = const Value.absent(),
    this.condition = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<InventoryItem> custom({
    Expression<int>? id,
    Expression<int>? areaId,
    Expression<String>? name,
    Expression<int>? quantity,
    Expression<String>? condition,
    Expression<String>? notes,
    Expression<String>? photoPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (areaId != null) 'area_id': areaId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (condition != null) 'condition': condition,
      if (notes != null) 'notes': notes,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  InventoryItemsCompanion copyWith({
    Value<int>? id,
    Value<int?>? areaId,
    Value<String>? name,
    Value<int>? quantity,
    Value<String>? condition,
    Value<String?>? notes,
    Value<String?>? photoPath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return InventoryItemsCompanion(
      id: id ?? this.id,
      areaId: areaId ?? this.areaId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      condition: condition ?? this.condition,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (areaId.present) {
      map['area_id'] = Variable<int>(areaId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItemsCompanion(')
          ..write('id: $id, ')
          ..write('areaId: $areaId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('condition: $condition, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FoodStocksTable extends FoodStocks
    with TableInfo<$FoodStocksTable, FoodStock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodStocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _areaIdMeta = const VerificationMeta('areaId');
  @override
  late final GeneratedColumn<int> areaId = GeneratedColumn<int>(
    'area_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES areas (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Pantry'),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pcs'),
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
    'expiry_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lowStockThresholdMeta = const VerificationMeta(
    'lowStockThreshold',
  );
  @override
  late final GeneratedColumn<double> lowStockThreshold =
      GeneratedColumn<double>(
        'low_stock_threshold',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    areaId,
    name,
    category,
    quantity,
    unit,
    expiryDate,
    lowStockThreshold,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_stocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodStock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('area_id')) {
      context.handle(
        _areaIdMeta,
        areaId.isAcceptableOrUnknown(data['area_id']!, _areaIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    }
    if (data.containsKey('low_stock_threshold')) {
      context.handle(
        _lowStockThresholdMeta,
        lowStockThreshold.isAcceptableOrUnknown(
          data['low_stock_threshold']!,
          _lowStockThresholdMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodStock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodStock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      areaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}area_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_date'],
      ),
      lowStockThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}low_stock_threshold'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FoodStocksTable createAlias(String alias) {
    return $FoodStocksTable(attachedDatabase, alias);
  }
}

class FoodStock extends DataClass implements Insertable<FoodStock> {
  final int id;
  final int? areaId;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final DateTime? expiryDate;
  final double? lowStockThreshold;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FoodStock({
    required this.id,
    this.areaId,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    this.expiryDate,
    this.lowStockThreshold,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || areaId != null) {
      map['area_id'] = Variable<int>(areaId);
    }
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    if (!nullToAbsent || lowStockThreshold != null) {
      map['low_stock_threshold'] = Variable<double>(lowStockThreshold);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FoodStocksCompanion toCompanion(bool nullToAbsent) {
    return FoodStocksCompanion(
      id: Value(id),
      areaId: areaId == null && nullToAbsent
          ? const Value.absent()
          : Value(areaId),
      name: Value(name),
      category: Value(category),
      quantity: Value(quantity),
      unit: Value(unit),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      lowStockThreshold: lowStockThreshold == null && nullToAbsent
          ? const Value.absent()
          : Value(lowStockThreshold),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FoodStock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodStock(
      id: serializer.fromJson<int>(json['id']),
      areaId: serializer.fromJson<int?>(json['areaId']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      lowStockThreshold: serializer.fromJson<double?>(
        json['lowStockThreshold'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'areaId': serializer.toJson<int?>(areaId),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'lowStockThreshold': serializer.toJson<double?>(lowStockThreshold),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FoodStock copyWith({
    int? id,
    Value<int?> areaId = const Value.absent(),
    String? name,
    String? category,
    double? quantity,
    String? unit,
    Value<DateTime?> expiryDate = const Value.absent(),
    Value<double?> lowStockThreshold = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FoodStock(
    id: id ?? this.id,
    areaId: areaId.present ? areaId.value : this.areaId,
    name: name ?? this.name,
    category: category ?? this.category,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
    lowStockThreshold: lowStockThreshold.present
        ? lowStockThreshold.value
        : this.lowStockThreshold,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FoodStock copyWithCompanion(FoodStocksCompanion data) {
    return FoodStock(
      id: data.id.present ? data.id.value : this.id,
      areaId: data.areaId.present ? data.areaId.value : this.areaId,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      lowStockThreshold: data.lowStockThreshold.present
          ? data.lowStockThreshold.value
          : this.lowStockThreshold,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodStock(')
          ..write('id: $id, ')
          ..write('areaId: $areaId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    areaId,
    name,
    category,
    quantity,
    unit,
    expiryDate,
    lowStockThreshold,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodStock &&
          other.id == this.id &&
          other.areaId == this.areaId &&
          other.name == this.name &&
          other.category == this.category &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.expiryDate == this.expiryDate &&
          other.lowStockThreshold == this.lowStockThreshold &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FoodStocksCompanion extends UpdateCompanion<FoodStock> {
  final Value<int> id;
  final Value<int?> areaId;
  final Value<String> name;
  final Value<String> category;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<DateTime?> expiryDate;
  final Value<double?> lowStockThreshold;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FoodStocksCompanion({
    this.id = const Value.absent(),
    this.areaId = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FoodStocksCompanion.insert({
    this.id = const Value.absent(),
    this.areaId = const Value.absent(),
    required String name,
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FoodStock> custom({
    Expression<int>? id,
    Expression<int>? areaId,
    Expression<String>? name,
    Expression<String>? category,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<DateTime>? expiryDate,
    Expression<double>? lowStockThreshold,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (areaId != null) 'area_id': areaId,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (lowStockThreshold != null) 'low_stock_threshold': lowStockThreshold,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FoodStocksCompanion copyWith({
    Value<int>? id,
    Value<int?>? areaId,
    Value<String>? name,
    Value<String>? category,
    Value<double>? quantity,
    Value<String>? unit,
    Value<DateTime?>? expiryDate,
    Value<double?>? lowStockThreshold,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return FoodStocksCompanion(
      id: id ?? this.id,
      areaId: areaId ?? this.areaId,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (areaId.present) {
      map['area_id'] = Variable<int>(areaId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (lowStockThreshold.present) {
      map['low_stock_threshold'] = Variable<double>(lowStockThreshold.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodStocksCompanion(')
          ..write('id: $id, ')
          ..write('areaId: $areaId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $LaundryLogsTable extends LaundryLogs
    with TableInfo<$LaundryLogsTable, LaundryLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LaundryLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextReminderAtMeta = const VerificationMeta(
    'nextReminderAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextReminderAt =
      GeneratedColumn<DateTime>(
        'next_reminder_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    completedAt,
    notes,
    nextReminderAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'laundry_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<LaundryLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('next_reminder_at')) {
      context.handle(
        _nextReminderAtMeta,
        nextReminderAt.isAcceptableOrUnknown(
          data['next_reminder_at']!,
          _nextReminderAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LaundryLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LaundryLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      nextReminderAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_reminder_at'],
      ),
    );
  }

  @override
  $LaundryLogsTable createAlias(String alias) {
    return $LaundryLogsTable(attachedDatabase, alias);
  }
}

class LaundryLog extends DataClass implements Insertable<LaundryLog> {
  final int id;
  final DateTime completedAt;
  final String? notes;
  final DateTime? nextReminderAt;
  const LaundryLog({
    required this.id,
    required this.completedAt,
    this.notes,
    this.nextReminderAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['completed_at'] = Variable<DateTime>(completedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || nextReminderAt != null) {
      map['next_reminder_at'] = Variable<DateTime>(nextReminderAt);
    }
    return map;
  }

  LaundryLogsCompanion toCompanion(bool nullToAbsent) {
    return LaundryLogsCompanion(
      id: Value(id),
      completedAt: Value(completedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      nextReminderAt: nextReminderAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReminderAt),
    );
  }

  factory LaundryLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LaundryLog(
      id: serializer.fromJson<int>(json['id']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      nextReminderAt: serializer.fromJson<DateTime?>(json['nextReminderAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'notes': serializer.toJson<String?>(notes),
      'nextReminderAt': serializer.toJson<DateTime?>(nextReminderAt),
    };
  }

  LaundryLog copyWith({
    int? id,
    DateTime? completedAt,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> nextReminderAt = const Value.absent(),
  }) => LaundryLog(
    id: id ?? this.id,
    completedAt: completedAt ?? this.completedAt,
    notes: notes.present ? notes.value : this.notes,
    nextReminderAt: nextReminderAt.present
        ? nextReminderAt.value
        : this.nextReminderAt,
  );
  LaundryLog copyWithCompanion(LaundryLogsCompanion data) {
    return LaundryLog(
      id: data.id.present ? data.id.value : this.id,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      nextReminderAt: data.nextReminderAt.present
          ? data.nextReminderAt.value
          : this.nextReminderAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LaundryLog(')
          ..write('id: $id, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes, ')
          ..write('nextReminderAt: $nextReminderAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, completedAt, notes, nextReminderAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LaundryLog &&
          other.id == this.id &&
          other.completedAt == this.completedAt &&
          other.notes == this.notes &&
          other.nextReminderAt == this.nextReminderAt);
}

class LaundryLogsCompanion extends UpdateCompanion<LaundryLog> {
  final Value<int> id;
  final Value<DateTime> completedAt;
  final Value<String?> notes;
  final Value<DateTime?> nextReminderAt;
  const LaundryLogsCompanion({
    this.id = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.nextReminderAt = const Value.absent(),
  });
  LaundryLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime completedAt,
    this.notes = const Value.absent(),
    this.nextReminderAt = const Value.absent(),
  }) : completedAt = Value(completedAt);
  static Insertable<LaundryLog> custom({
    Expression<int>? id,
    Expression<DateTime>? completedAt,
    Expression<String>? notes,
    Expression<DateTime>? nextReminderAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (completedAt != null) 'completed_at': completedAt,
      if (notes != null) 'notes': notes,
      if (nextReminderAt != null) 'next_reminder_at': nextReminderAt,
    });
  }

  LaundryLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? completedAt,
    Value<String?>? notes,
    Value<DateTime?>? nextReminderAt,
  }) {
    return LaundryLogsCompanion(
      id: id ?? this.id,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      nextReminderAt: nextReminderAt ?? this.nextReminderAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (nextReminderAt.present) {
      map['next_reminder_at'] = Variable<DateTime>(nextReminderAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LaundryLogsCompanion(')
          ..write('id: $id, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes, ')
          ..write('nextReminderAt: $nextReminderAt')
          ..write(')'))
        .toString();
  }
}

class $PaymentLogsTable extends PaymentLogs
    with TableInfo<$PaymentLogsTable, PaymentLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _billTypeMeta = const VerificationMeta(
    'billType',
  );
  @override
  late final GeneratedColumn<String> billType = GeneratedColumn<String>(
    'bill_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('rent'),
  );
  static const VerificationMeta _billingMonthMeta = const VerificationMeta(
    'billingMonth',
  );
  @override
  late final GeneratedColumn<String> billingMonth = GeneratedColumn<String>(
    'billing_month',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 7,
      maxTextLength: 7,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextReminderAtMeta = const VerificationMeta(
    'nextReminderAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextReminderAt =
      GeneratedColumn<DateTime>(
        'next_reminder_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    billType,
    billingMonth,
    paidAt,
    amountCents,
    notes,
    nextReminderAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bill_type')) {
      context.handle(
        _billTypeMeta,
        billType.isAcceptableOrUnknown(data['bill_type']!, _billTypeMeta),
      );
    }
    if (data.containsKey('billing_month')) {
      context.handle(
        _billingMonthMeta,
        billingMonth.isAcceptableOrUnknown(
          data['billing_month']!,
          _billingMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_billingMonthMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('next_reminder_at')) {
      context.handle(
        _nextReminderAtMeta,
        nextReminderAt.isAcceptableOrUnknown(
          data['next_reminder_at']!,
          _nextReminderAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      billType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bill_type'],
      )!,
      billingMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}billing_month'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      nextReminderAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_reminder_at'],
      ),
    );
  }

  @override
  $PaymentLogsTable createAlias(String alias) {
    return $PaymentLogsTable(attachedDatabase, alias);
  }
}

class PaymentLog extends DataClass implements Insertable<PaymentLog> {
  final int id;
  final String billType;
  final String billingMonth;
  final DateTime paidAt;
  final int amountCents;
  final String? notes;
  final DateTime? nextReminderAt;
  const PaymentLog({
    required this.id,
    required this.billType,
    required this.billingMonth,
    required this.paidAt,
    required this.amountCents,
    this.notes,
    this.nextReminderAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bill_type'] = Variable<String>(billType);
    map['billing_month'] = Variable<String>(billingMonth);
    map['paid_at'] = Variable<DateTime>(paidAt);
    map['amount_cents'] = Variable<int>(amountCents);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || nextReminderAt != null) {
      map['next_reminder_at'] = Variable<DateTime>(nextReminderAt);
    }
    return map;
  }

  PaymentLogsCompanion toCompanion(bool nullToAbsent) {
    return PaymentLogsCompanion(
      id: Value(id),
      billType: Value(billType),
      billingMonth: Value(billingMonth),
      paidAt: Value(paidAt),
      amountCents: Value(amountCents),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      nextReminderAt: nextReminderAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReminderAt),
    );
  }

  factory PaymentLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentLog(
      id: serializer.fromJson<int>(json['id']),
      billType: serializer.fromJson<String>(json['billType']),
      billingMonth: serializer.fromJson<String>(json['billingMonth']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      notes: serializer.fromJson<String?>(json['notes']),
      nextReminderAt: serializer.fromJson<DateTime?>(json['nextReminderAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'billType': serializer.toJson<String>(billType),
      'billingMonth': serializer.toJson<String>(billingMonth),
      'paidAt': serializer.toJson<DateTime>(paidAt),
      'amountCents': serializer.toJson<int>(amountCents),
      'notes': serializer.toJson<String?>(notes),
      'nextReminderAt': serializer.toJson<DateTime?>(nextReminderAt),
    };
  }

  PaymentLog copyWith({
    int? id,
    String? billType,
    String? billingMonth,
    DateTime? paidAt,
    int? amountCents,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> nextReminderAt = const Value.absent(),
  }) => PaymentLog(
    id: id ?? this.id,
    billType: billType ?? this.billType,
    billingMonth: billingMonth ?? this.billingMonth,
    paidAt: paidAt ?? this.paidAt,
    amountCents: amountCents ?? this.amountCents,
    notes: notes.present ? notes.value : this.notes,
    nextReminderAt: nextReminderAt.present
        ? nextReminderAt.value
        : this.nextReminderAt,
  );
  PaymentLog copyWithCompanion(PaymentLogsCompanion data) {
    return PaymentLog(
      id: data.id.present ? data.id.value : this.id,
      billType: data.billType.present ? data.billType.value : this.billType,
      billingMonth: data.billingMonth.present
          ? data.billingMonth.value
          : this.billingMonth,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      notes: data.notes.present ? data.notes.value : this.notes,
      nextReminderAt: data.nextReminderAt.present
          ? data.nextReminderAt.value
          : this.nextReminderAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentLog(')
          ..write('id: $id, ')
          ..write('billType: $billType, ')
          ..write('billingMonth: $billingMonth, ')
          ..write('paidAt: $paidAt, ')
          ..write('amountCents: $amountCents, ')
          ..write('notes: $notes, ')
          ..write('nextReminderAt: $nextReminderAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    billType,
    billingMonth,
    paidAt,
    amountCents,
    notes,
    nextReminderAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentLog &&
          other.id == this.id &&
          other.billType == this.billType &&
          other.billingMonth == this.billingMonth &&
          other.paidAt == this.paidAt &&
          other.amountCents == this.amountCents &&
          other.notes == this.notes &&
          other.nextReminderAt == this.nextReminderAt);
}

class PaymentLogsCompanion extends UpdateCompanion<PaymentLog> {
  final Value<int> id;
  final Value<String> billType;
  final Value<String> billingMonth;
  final Value<DateTime> paidAt;
  final Value<int> amountCents;
  final Value<String?> notes;
  final Value<DateTime?> nextReminderAt;
  const PaymentLogsCompanion({
    this.id = const Value.absent(),
    this.billType = const Value.absent(),
    this.billingMonth = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.notes = const Value.absent(),
    this.nextReminderAt = const Value.absent(),
  });
  PaymentLogsCompanion.insert({
    this.id = const Value.absent(),
    this.billType = const Value.absent(),
    required String billingMonth,
    required DateTime paidAt,
    this.amountCents = const Value.absent(),
    this.notes = const Value.absent(),
    this.nextReminderAt = const Value.absent(),
  }) : billingMonth = Value(billingMonth),
       paidAt = Value(paidAt);
  static Insertable<PaymentLog> custom({
    Expression<int>? id,
    Expression<String>? billType,
    Expression<String>? billingMonth,
    Expression<DateTime>? paidAt,
    Expression<int>? amountCents,
    Expression<String>? notes,
    Expression<DateTime>? nextReminderAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (billType != null) 'bill_type': billType,
      if (billingMonth != null) 'billing_month': billingMonth,
      if (paidAt != null) 'paid_at': paidAt,
      if (amountCents != null) 'amount_cents': amountCents,
      if (notes != null) 'notes': notes,
      if (nextReminderAt != null) 'next_reminder_at': nextReminderAt,
    });
  }

  PaymentLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? billType,
    Value<String>? billingMonth,
    Value<DateTime>? paidAt,
    Value<int>? amountCents,
    Value<String?>? notes,
    Value<DateTime?>? nextReminderAt,
  }) {
    return PaymentLogsCompanion(
      id: id ?? this.id,
      billType: billType ?? this.billType,
      billingMonth: billingMonth ?? this.billingMonth,
      paidAt: paidAt ?? this.paidAt,
      amountCents: amountCents ?? this.amountCents,
      notes: notes ?? this.notes,
      nextReminderAt: nextReminderAt ?? this.nextReminderAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (billType.present) {
      map['bill_type'] = Variable<String>(billType.value);
    }
    if (billingMonth.present) {
      map['billing_month'] = Variable<String>(billingMonth.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (nextReminderAt.present) {
      map['next_reminder_at'] = Variable<DateTime>(nextReminderAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentLogsCompanion(')
          ..write('id: $id, ')
          ..write('billType: $billType, ')
          ..write('billingMonth: $billingMonth, ')
          ..write('paidAt: $paidAt, ')
          ..write('amountCents: $amountCents, ')
          ..write('notes: $notes, ')
          ..write('nextReminderAt: $nextReminderAt')
          ..write(')'))
        .toString();
  }
}

class $TodoItemsTable extends TodoItems
    with TableInfo<$TodoItemsTable, TodoItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 140,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderAtMeta = const VerificationMeta(
    'reminderAt',
  );
  @override
  late final GeneratedColumn<DateTime> reminderAt = GeneratedColumn<DateTime>(
    'reminder_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    notes,
    isDone,
    dueAt,
    reminderAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TodoItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('reminder_at')) {
      context.handle(
        _reminderAtMeta,
        reminderAt.isAcceptableOrUnknown(data['reminder_at']!, _reminderAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      ),
      reminderAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reminder_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TodoItemsTable createAlias(String alias) {
    return $TodoItemsTable(attachedDatabase, alias);
  }
}

class TodoItem extends DataClass implements Insertable<TodoItem> {
  final int id;
  final String title;
  final String? notes;
  final bool isDone;
  final DateTime? dueAt;
  final DateTime? reminderAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TodoItem({
    required this.id,
    required this.title,
    this.notes,
    required this.isDone,
    this.dueAt,
    this.reminderAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_done'] = Variable<bool>(isDone);
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    if (!nullToAbsent || reminderAt != null) {
      map['reminder_at'] = Variable<DateTime>(reminderAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TodoItemsCompanion toCompanion(bool nullToAbsent) {
    return TodoItemsCompanion(
      id: Value(id),
      title: Value(title),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isDone: Value(isDone),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      reminderAt: reminderAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TodoItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoItem(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      reminderAt: serializer.fromJson<DateTime?>(json['reminderAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'isDone': serializer.toJson<bool>(isDone),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'reminderAt': serializer.toJson<DateTime?>(reminderAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TodoItem copyWith({
    int? id,
    String? title,
    Value<String?> notes = const Value.absent(),
    bool? isDone,
    Value<DateTime?> dueAt = const Value.absent(),
    Value<DateTime?> reminderAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TodoItem(
    id: id ?? this.id,
    title: title ?? this.title,
    notes: notes.present ? notes.value : this.notes,
    isDone: isDone ?? this.isDone,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    reminderAt: reminderAt.present ? reminderAt.value : this.reminderAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TodoItem copyWithCompanion(TodoItemsCompanion data) {
    return TodoItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      reminderAt: data.reminderAt.present
          ? data.reminderAt.value
          : this.reminderAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('isDone: $isDone, ')
          ..write('dueAt: $dueAt, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    notes,
    isDone,
    dueAt,
    reminderAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.isDone == this.isDone &&
          other.dueAt == this.dueAt &&
          other.reminderAt == this.reminderAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TodoItemsCompanion extends UpdateCompanion<TodoItem> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> notes;
  final Value<bool> isDone;
  final Value<DateTime?> dueAt;
  final Value<DateTime?> reminderAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TodoItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.isDone = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TodoItemsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.notes = const Value.absent(),
    this.isDone = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.reminderAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TodoItem> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<bool>? isDone,
    Expression<DateTime>? dueAt,
    Expression<DateTime>? reminderAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (isDone != null) 'is_done': isDone,
      if (dueAt != null) 'due_at': dueAt,
      if (reminderAt != null) 'reminder_at': reminderAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TodoItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? notes,
    Value<bool>? isDone,
    Value<DateTime?>? dueAt,
    Value<DateTime?>? reminderAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TodoItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      isDone: isDone ?? this.isDone,
      dueAt: dueAt ?? this.dueAt,
      reminderAt: reminderAt ?? this.reminderAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (reminderAt.present) {
      map['reminder_at'] = Variable<DateTime>(reminderAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('isDone: $isDone, ')
          ..write('dueAt: $dueAt, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RoomLayoutsTable extends RoomLayouts
    with TableInfo<$RoomLayoutsTable, RoomLayout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomLayoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('My Room'),
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<double> width = GeneratedColumn<double>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(360),
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(520),
  );
  static const VerificationMeta _gridSizeMeta = const VerificationMeta(
    'gridSize',
  );
  @override
  late final GeneratedColumn<double> gridSize = GeneratedColumn<double>(
    'grid_size',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    width,
    height,
    gridSize,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'room_layouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoomLayout> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('grid_size')) {
      context.handle(
        _gridSizeMeta,
        gridSize.isAcceptableOrUnknown(data['grid_size']!, _gridSizeMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoomLayout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoomLayout(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height'],
      )!,
      gridSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grid_size'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RoomLayoutsTable createAlias(String alias) {
    return $RoomLayoutsTable(attachedDatabase, alias);
  }
}

class RoomLayout extends DataClass implements Insertable<RoomLayout> {
  final int id;
  final String name;
  final double width;
  final double height;
  final double gridSize;
  final DateTime updatedAt;
  const RoomLayout({
    required this.id,
    required this.name,
    required this.width,
    required this.height,
    required this.gridSize,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['width'] = Variable<double>(width);
    map['height'] = Variable<double>(height);
    map['grid_size'] = Variable<double>(gridSize);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RoomLayoutsCompanion toCompanion(bool nullToAbsent) {
    return RoomLayoutsCompanion(
      id: Value(id),
      name: Value(name),
      width: Value(width),
      height: Value(height),
      gridSize: Value(gridSize),
      updatedAt: Value(updatedAt),
    );
  }

  factory RoomLayout.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoomLayout(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      width: serializer.fromJson<double>(json['width']),
      height: serializer.fromJson<double>(json['height']),
      gridSize: serializer.fromJson<double>(json['gridSize']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'width': serializer.toJson<double>(width),
      'height': serializer.toJson<double>(height),
      'gridSize': serializer.toJson<double>(gridSize),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RoomLayout copyWith({
    int? id,
    String? name,
    double? width,
    double? height,
    double? gridSize,
    DateTime? updatedAt,
  }) => RoomLayout(
    id: id ?? this.id,
    name: name ?? this.name,
    width: width ?? this.width,
    height: height ?? this.height,
    gridSize: gridSize ?? this.gridSize,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RoomLayout copyWithCompanion(RoomLayoutsCompanion data) {
    return RoomLayout(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      gridSize: data.gridSize.present ? data.gridSize.value : this.gridSize,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoomLayout(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('gridSize: $gridSize, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, width, height, gridSize, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoomLayout &&
          other.id == this.id &&
          other.name == this.name &&
          other.width == this.width &&
          other.height == this.height &&
          other.gridSize == this.gridSize &&
          other.updatedAt == this.updatedAt);
}

class RoomLayoutsCompanion extends UpdateCompanion<RoomLayout> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> width;
  final Value<double> height;
  final Value<double> gridSize;
  final Value<DateTime> updatedAt;
  const RoomLayoutsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.gridSize = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RoomLayoutsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.gridSize = const Value.absent(),
    required DateTime updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<RoomLayout> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? width,
    Expression<double>? height,
    Expression<double>? gridSize,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (gridSize != null) 'grid_size': gridSize,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RoomLayoutsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? width,
    Value<double>? height,
    Value<double>? gridSize,
    Value<DateTime>? updatedAt,
  }) {
    return RoomLayoutsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      width: width ?? this.width,
      height: height ?? this.height,
      gridSize: gridSize ?? this.gridSize,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (width.present) {
      map['width'] = Variable<double>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (gridSize.present) {
      map['grid_size'] = Variable<double>(gridSize.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomLayoutsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('gridSize: $gridSize, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $LayoutObjectsTable extends LayoutObjects
    with TableInfo<$LayoutObjectsTable, LayoutObject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LayoutObjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _layoutIdMeta = const VerificationMeta(
    'layoutId',
  );
  @override
  late final GeneratedColumn<int> layoutId = GeneratedColumn<int>(
    'layout_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES room_layouts (id)',
    ),
  );
  static const VerificationMeta _linkedAreaIdMeta = const VerificationMeta(
    'linkedAreaId',
  );
  @override
  late final GeneratedColumn<int> linkedAreaId = GeneratedColumn<int>(
    'linked_area_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES areas (id)',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('zone'),
  );
  static const VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedColumn<double> x = GeneratedColumn<double>(
    'x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedColumn<double> y = GeneratedColumn<double>(
    'y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<double> width = GeneratedColumn<double>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(80),
  );
  static const VerificationMeta _rotationMeta = const VerificationMeta(
    'rotation',
  );
  @override
  late final GeneratedColumn<double> rotation = GeneratedColumn<double>(
    'rotation',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#3B82F6'),
  );
  static const VerificationMeta _zOrderMeta = const VerificationMeta('zOrder');
  @override
  late final GeneratedColumn<int> zOrder = GeneratedColumn<int>(
    'z_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    layoutId,
    linkedAreaId,
    label,
    kind,
    x,
    y,
    width,
    height,
    rotation,
    colorHex,
    zOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'layout_objects';
  @override
  VerificationContext validateIntegrity(
    Insertable<LayoutObject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('layout_id')) {
      context.handle(
        _layoutIdMeta,
        layoutId.isAcceptableOrUnknown(data['layout_id']!, _layoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_layoutIdMeta);
    }
    if (data.containsKey('linked_area_id')) {
      context.handle(
        _linkedAreaIdMeta,
        linkedAreaId.isAcceptableOrUnknown(
          data['linked_area_id']!,
          _linkedAreaIdMeta,
        ),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('rotation')) {
      context.handle(
        _rotationMeta,
        rotation.isAcceptableOrUnknown(data['rotation']!, _rotationMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('z_order')) {
      context.handle(
        _zOrderMeta,
        zOrder.isAcceptableOrUnknown(data['z_order']!, _zOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LayoutObject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LayoutObject(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      layoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}layout_id'],
      )!,
      linkedAreaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}linked_area_id'],
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      x: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}x'],
      )!,
      y: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}y'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height'],
      )!,
      rotation: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rotation'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      zOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}z_order'],
      )!,
    );
  }

  @override
  $LayoutObjectsTable createAlias(String alias) {
    return $LayoutObjectsTable(attachedDatabase, alias);
  }
}

class LayoutObject extends DataClass implements Insertable<LayoutObject> {
  final int id;
  final int layoutId;
  final int? linkedAreaId;
  final String label;
  final String kind;
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation;
  final String colorHex;
  final int zOrder;
  const LayoutObject({
    required this.id,
    required this.layoutId,
    this.linkedAreaId,
    required this.label,
    required this.kind,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.rotation,
    required this.colorHex,
    required this.zOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['layout_id'] = Variable<int>(layoutId);
    if (!nullToAbsent || linkedAreaId != null) {
      map['linked_area_id'] = Variable<int>(linkedAreaId);
    }
    map['label'] = Variable<String>(label);
    map['kind'] = Variable<String>(kind);
    map['x'] = Variable<double>(x);
    map['y'] = Variable<double>(y);
    map['width'] = Variable<double>(width);
    map['height'] = Variable<double>(height);
    map['rotation'] = Variable<double>(rotation);
    map['color_hex'] = Variable<String>(colorHex);
    map['z_order'] = Variable<int>(zOrder);
    return map;
  }

  LayoutObjectsCompanion toCompanion(bool nullToAbsent) {
    return LayoutObjectsCompanion(
      id: Value(id),
      layoutId: Value(layoutId),
      linkedAreaId: linkedAreaId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedAreaId),
      label: Value(label),
      kind: Value(kind),
      x: Value(x),
      y: Value(y),
      width: Value(width),
      height: Value(height),
      rotation: Value(rotation),
      colorHex: Value(colorHex),
      zOrder: Value(zOrder),
    );
  }

  factory LayoutObject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LayoutObject(
      id: serializer.fromJson<int>(json['id']),
      layoutId: serializer.fromJson<int>(json['layoutId']),
      linkedAreaId: serializer.fromJson<int?>(json['linkedAreaId']),
      label: serializer.fromJson<String>(json['label']),
      kind: serializer.fromJson<String>(json['kind']),
      x: serializer.fromJson<double>(json['x']),
      y: serializer.fromJson<double>(json['y']),
      width: serializer.fromJson<double>(json['width']),
      height: serializer.fromJson<double>(json['height']),
      rotation: serializer.fromJson<double>(json['rotation']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      zOrder: serializer.fromJson<int>(json['zOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'layoutId': serializer.toJson<int>(layoutId),
      'linkedAreaId': serializer.toJson<int?>(linkedAreaId),
      'label': serializer.toJson<String>(label),
      'kind': serializer.toJson<String>(kind),
      'x': serializer.toJson<double>(x),
      'y': serializer.toJson<double>(y),
      'width': serializer.toJson<double>(width),
      'height': serializer.toJson<double>(height),
      'rotation': serializer.toJson<double>(rotation),
      'colorHex': serializer.toJson<String>(colorHex),
      'zOrder': serializer.toJson<int>(zOrder),
    };
  }

  LayoutObject copyWith({
    int? id,
    int? layoutId,
    Value<int?> linkedAreaId = const Value.absent(),
    String? label,
    String? kind,
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
    String? colorHex,
    int? zOrder,
  }) => LayoutObject(
    id: id ?? this.id,
    layoutId: layoutId ?? this.layoutId,
    linkedAreaId: linkedAreaId.present ? linkedAreaId.value : this.linkedAreaId,
    label: label ?? this.label,
    kind: kind ?? this.kind,
    x: x ?? this.x,
    y: y ?? this.y,
    width: width ?? this.width,
    height: height ?? this.height,
    rotation: rotation ?? this.rotation,
    colorHex: colorHex ?? this.colorHex,
    zOrder: zOrder ?? this.zOrder,
  );
  LayoutObject copyWithCompanion(LayoutObjectsCompanion data) {
    return LayoutObject(
      id: data.id.present ? data.id.value : this.id,
      layoutId: data.layoutId.present ? data.layoutId.value : this.layoutId,
      linkedAreaId: data.linkedAreaId.present
          ? data.linkedAreaId.value
          : this.linkedAreaId,
      label: data.label.present ? data.label.value : this.label,
      kind: data.kind.present ? data.kind.value : this.kind,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      rotation: data.rotation.present ? data.rotation.value : this.rotation,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      zOrder: data.zOrder.present ? data.zOrder.value : this.zOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LayoutObject(')
          ..write('id: $id, ')
          ..write('layoutId: $layoutId, ')
          ..write('linkedAreaId: $linkedAreaId, ')
          ..write('label: $label, ')
          ..write('kind: $kind, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('rotation: $rotation, ')
          ..write('colorHex: $colorHex, ')
          ..write('zOrder: $zOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    layoutId,
    linkedAreaId,
    label,
    kind,
    x,
    y,
    width,
    height,
    rotation,
    colorHex,
    zOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LayoutObject &&
          other.id == this.id &&
          other.layoutId == this.layoutId &&
          other.linkedAreaId == this.linkedAreaId &&
          other.label == this.label &&
          other.kind == this.kind &&
          other.x == this.x &&
          other.y == this.y &&
          other.width == this.width &&
          other.height == this.height &&
          other.rotation == this.rotation &&
          other.colorHex == this.colorHex &&
          other.zOrder == this.zOrder);
}

class LayoutObjectsCompanion extends UpdateCompanion<LayoutObject> {
  final Value<int> id;
  final Value<int> layoutId;
  final Value<int?> linkedAreaId;
  final Value<String> label;
  final Value<String> kind;
  final Value<double> x;
  final Value<double> y;
  final Value<double> width;
  final Value<double> height;
  final Value<double> rotation;
  final Value<String> colorHex;
  final Value<int> zOrder;
  const LayoutObjectsCompanion({
    this.id = const Value.absent(),
    this.layoutId = const Value.absent(),
    this.linkedAreaId = const Value.absent(),
    this.label = const Value.absent(),
    this.kind = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.rotation = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.zOrder = const Value.absent(),
  });
  LayoutObjectsCompanion.insert({
    this.id = const Value.absent(),
    required int layoutId,
    this.linkedAreaId = const Value.absent(),
    required String label,
    this.kind = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.rotation = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.zOrder = const Value.absent(),
  }) : layoutId = Value(layoutId),
       label = Value(label);
  static Insertable<LayoutObject> custom({
    Expression<int>? id,
    Expression<int>? layoutId,
    Expression<int>? linkedAreaId,
    Expression<String>? label,
    Expression<String>? kind,
    Expression<double>? x,
    Expression<double>? y,
    Expression<double>? width,
    Expression<double>? height,
    Expression<double>? rotation,
    Expression<String>? colorHex,
    Expression<int>? zOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (layoutId != null) 'layout_id': layoutId,
      if (linkedAreaId != null) 'linked_area_id': linkedAreaId,
      if (label != null) 'label': label,
      if (kind != null) 'kind': kind,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (rotation != null) 'rotation': rotation,
      if (colorHex != null) 'color_hex': colorHex,
      if (zOrder != null) 'z_order': zOrder,
    });
  }

  LayoutObjectsCompanion copyWith({
    Value<int>? id,
    Value<int>? layoutId,
    Value<int?>? linkedAreaId,
    Value<String>? label,
    Value<String>? kind,
    Value<double>? x,
    Value<double>? y,
    Value<double>? width,
    Value<double>? height,
    Value<double>? rotation,
    Value<String>? colorHex,
    Value<int>? zOrder,
  }) {
    return LayoutObjectsCompanion(
      id: id ?? this.id,
      layoutId: layoutId ?? this.layoutId,
      linkedAreaId: linkedAreaId ?? this.linkedAreaId,
      label: label ?? this.label,
      kind: kind ?? this.kind,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
      colorHex: colorHex ?? this.colorHex,
      zOrder: zOrder ?? this.zOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (layoutId.present) {
      map['layout_id'] = Variable<int>(layoutId.value);
    }
    if (linkedAreaId.present) {
      map['linked_area_id'] = Variable<int>(linkedAreaId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (x.present) {
      map['x'] = Variable<double>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<double>(y.value);
    }
    if (width.present) {
      map['width'] = Variable<double>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (rotation.present) {
      map['rotation'] = Variable<double>(rotation.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (zOrder.present) {
      map['z_order'] = Variable<int>(zOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LayoutObjectsCompanion(')
          ..write('id: $id, ')
          ..write('layoutId: $layoutId, ')
          ..write('linkedAreaId: $linkedAreaId, ')
          ..write('label: $label, ')
          ..write('kind: $kind, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('rotation: $rotation, ')
          ..write('colorHex: $colorHex, ')
          ..write('zOrder: $zOrder')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerTypeMeta = const VerificationMeta(
    'ownerType',
  );
  @override
  late final GeneratedColumn<String> ownerType = GeneratedColumn<String>(
    'owner_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
    'owner_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 140,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
    'notification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerType,
    ownerId,
    title,
    body,
    scheduledAt,
    notificationId,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_type')) {
      context.handle(
        _ownerTypeMeta,
        ownerType.isAcceptableOrUnknown(data['owner_type']!, _ownerTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerTypeMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_type'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      ),
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      )!,
      notificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final String ownerType;
  final int? ownerId;
  final String title;
  final String? body;
  final DateTime scheduledAt;
  final int notificationId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Reminder({
    required this.id,
    required this.ownerType,
    this.ownerId,
    required this.title,
    this.body,
    required this.scheduledAt,
    required this.notificationId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_type'] = Variable<String>(ownerType);
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<int>(ownerId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    map['notification_id'] = Variable<int>(notificationId);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      ownerType: Value(ownerType),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
      title: Value(title),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      scheduledAt: Value(scheduledAt),
      notificationId: Value(notificationId),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      ownerType: serializer.fromJson<String>(json['ownerType']),
      ownerId: serializer.fromJson<int?>(json['ownerId']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String?>(json['body']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      notificationId: serializer.fromJson<int>(json['notificationId']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerType': serializer.toJson<String>(ownerType),
      'ownerId': serializer.toJson<int?>(ownerId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String?>(body),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'notificationId': serializer.toJson<int>(notificationId),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Reminder copyWith({
    int? id,
    String? ownerType,
    Value<int?> ownerId = const Value.absent(),
    String? title,
    Value<String?> body = const Value.absent(),
    DateTime? scheduledAt,
    int? notificationId,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Reminder(
    id: id ?? this.id,
    ownerType: ownerType ?? this.ownerType,
    ownerId: ownerId.present ? ownerId.value : this.ownerId,
    title: title ?? this.title,
    body: body.present ? body.value : this.body,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    notificationId: notificationId ?? this.notificationId,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      ownerType: data.ownerType.present ? data.ownerType.value : this.ownerType,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('ownerType: $ownerType, ')
          ..write('ownerId: $ownerId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('notificationId: $notificationId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerType,
    ownerId,
    title,
    body,
    scheduledAt,
    notificationId,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.ownerType == this.ownerType &&
          other.ownerId == this.ownerId &&
          other.title == this.title &&
          other.body == this.body &&
          other.scheduledAt == this.scheduledAt &&
          other.notificationId == this.notificationId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<String> ownerType;
  final Value<int?> ownerId;
  final Value<String> title;
  final Value<String?> body;
  final Value<DateTime> scheduledAt;
  final Value<int> notificationId;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.ownerType = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required String ownerType,
    this.ownerId = const Value.absent(),
    required String title,
    this.body = const Value.absent(),
    required DateTime scheduledAt,
    required int notificationId,
    this.status = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : ownerType = Value(ownerType),
       title = Value(title),
       scheduledAt = Value(scheduledAt),
       notificationId = Value(notificationId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<String>? ownerType,
    Expression<int>? ownerId,
    Expression<String>? title,
    Expression<String>? body,
    Expression<DateTime>? scheduledAt,
    Expression<int>? notificationId,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerType != null) 'owner_type': ownerType,
      if (ownerId != null) 'owner_id': ownerId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (notificationId != null) 'notification_id': notificationId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<String>? ownerType,
    Value<int?>? ownerId,
    Value<String>? title,
    Value<String?>? body,
    Value<DateTime>? scheduledAt,
    Value<int>? notificationId,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      ownerType: ownerType ?? this.ownerType,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      notificationId: notificationId ?? this.notificationId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerType.present) {
      map['owner_type'] = Variable<String>(ownerType.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('ownerType: $ownerType, ')
          ..write('ownerId: $ownerId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('notificationId: $notificationId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AreasTable areas = $AreasTable(this);
  late final $InventoryItemsTable inventoryItems = $InventoryItemsTable(this);
  late final $FoodStocksTable foodStocks = $FoodStocksTable(this);
  late final $LaundryLogsTable laundryLogs = $LaundryLogsTable(this);
  late final $PaymentLogsTable paymentLogs = $PaymentLogsTable(this);
  late final $TodoItemsTable todoItems = $TodoItemsTable(this);
  late final $RoomLayoutsTable roomLayouts = $RoomLayoutsTable(this);
  late final $LayoutObjectsTable layoutObjects = $LayoutObjectsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    areas,
    inventoryItems,
    foodStocks,
    laundryLogs,
    paymentLogs,
    todoItems,
    roomLayouts,
    layoutObjects,
    reminders,
  ];
}

typedef $$AreasTableCreateCompanionBuilder =
    AreasCompanion Function({
      Value<int> id,
      required String name,
      Value<String> type,
      Value<String> colorHex,
      Value<int> sortOrder,
    });
typedef $$AreasTableUpdateCompanionBuilder =
    AreasCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> type,
      Value<String> colorHex,
      Value<int> sortOrder,
    });

final class $$AreasTableReferences
    extends BaseReferences<_$AppDatabase, $AreasTable, Area> {
  $$AreasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InventoryItemsTable, List<InventoryItem>>
  _inventoryItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inventoryItems,
    aliasName: 'areas__id__inventory_items__area_id',
  );

  $$InventoryItemsTableProcessedTableManager get inventoryItemsRefs {
    final manager = $$InventoryItemsTableTableManager(
      $_db,
      $_db.inventoryItems,
    ).filter((f) => f.areaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_inventoryItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FoodStocksTable, List<FoodStock>>
  _foodStocksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.foodStocks,
    aliasName: 'areas__id__food_stocks__area_id',
  );

  $$FoodStocksTableProcessedTableManager get foodStocksRefs {
    final manager = $$FoodStocksTableTableManager(
      $_db,
      $_db.foodStocks,
    ).filter((f) => f.areaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_foodStocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LayoutObjectsTable, List<LayoutObject>>
  _layoutObjectsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.layoutObjects,
    aliasName: 'areas__id__layout_objects__linked_area_id',
  );

  $$LayoutObjectsTableProcessedTableManager get layoutObjectsRefs {
    final manager = $$LayoutObjectsTableTableManager(
      $_db,
      $_db.layoutObjects,
    ).filter((f) => f.linkedAreaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_layoutObjectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AreasTableFilterComposer extends Composer<_$AppDatabase, $AreasTable> {
  $$AreasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> inventoryItemsRefs(
    Expression<bool> Function($$InventoryItemsTableFilterComposer f) f,
  ) {
    final $$InventoryItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventoryItems,
      getReferencedColumn: (t) => t.areaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryItemsTableFilterComposer(
            $db: $db,
            $table: $db.inventoryItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> foodStocksRefs(
    Expression<bool> Function($$FoodStocksTableFilterComposer f) f,
  ) {
    final $$FoodStocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodStocks,
      getReferencedColumn: (t) => t.areaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodStocksTableFilterComposer(
            $db: $db,
            $table: $db.foodStocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> layoutObjectsRefs(
    Expression<bool> Function($$LayoutObjectsTableFilterComposer f) f,
  ) {
    final $$LayoutObjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.layoutObjects,
      getReferencedColumn: (t) => t.linkedAreaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutObjectsTableFilterComposer(
            $db: $db,
            $table: $db.layoutObjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AreasTableOrderingComposer
    extends Composer<_$AppDatabase, $AreasTable> {
  $$AreasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AreasTableAnnotationComposer
    extends Composer<_$AppDatabase, $AreasTable> {
  $$AreasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> inventoryItemsRefs<T extends Object>(
    Expression<T> Function($$InventoryItemsTableAnnotationComposer a) f,
  ) {
    final $$InventoryItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventoryItems,
      getReferencedColumn: (t) => t.areaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.inventoryItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> foodStocksRefs<T extends Object>(
    Expression<T> Function($$FoodStocksTableAnnotationComposer a) f,
  ) {
    final $$FoodStocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodStocks,
      getReferencedColumn: (t) => t.areaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodStocksTableAnnotationComposer(
            $db: $db,
            $table: $db.foodStocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> layoutObjectsRefs<T extends Object>(
    Expression<T> Function($$LayoutObjectsTableAnnotationComposer a) f,
  ) {
    final $$LayoutObjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.layoutObjects,
      getReferencedColumn: (t) => t.linkedAreaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutObjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.layoutObjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AreasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AreasTable,
          Area,
          $$AreasTableFilterComposer,
          $$AreasTableOrderingComposer,
          $$AreasTableAnnotationComposer,
          $$AreasTableCreateCompanionBuilder,
          $$AreasTableUpdateCompanionBuilder,
          (Area, $$AreasTableReferences),
          Area,
          PrefetchHooks Function({
            bool inventoryItemsRefs,
            bool foodStocksRefs,
            bool layoutObjectsRefs,
          })
        > {
  $$AreasTableTableManager(_$AppDatabase db, $AreasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AreasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AreasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AreasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => AreasCompanion(
                id: id,
                name: name,
                type: type,
                colorHex: colorHex,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> type = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => AreasCompanion.insert(
                id: id,
                name: name,
                type: type,
                colorHex: colorHex,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$AreasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                inventoryItemsRefs = false,
                foodStocksRefs = false,
                layoutObjectsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (inventoryItemsRefs) db.inventoryItems,
                    if (foodStocksRefs) db.foodStocks,
                    if (layoutObjectsRefs) db.layoutObjects,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (inventoryItemsRefs)
                        await $_getPrefetchedData<
                          Area,
                          $AreasTable,
                          InventoryItem
                        >(
                          currentTable: table,
                          referencedTable: $$AreasTableReferences
                              ._inventoryItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AreasTableReferences(
                                db,
                                table,
                                p0,
                              ).inventoryItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.areaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (foodStocksRefs)
                        await $_getPrefetchedData<Area, $AreasTable, FoodStock>(
                          currentTable: table,
                          referencedTable: $$AreasTableReferences
                              ._foodStocksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AreasTableReferences(
                                db,
                                table,
                                p0,
                              ).foodStocksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.areaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (layoutObjectsRefs)
                        await $_getPrefetchedData<
                          Area,
                          $AreasTable,
                          LayoutObject
                        >(
                          currentTable: table,
                          referencedTable: $$AreasTableReferences
                              ._layoutObjectsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AreasTableReferences(
                                db,
                                table,
                                p0,
                              ).layoutObjectsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.linkedAreaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AreasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AreasTable,
      Area,
      $$AreasTableFilterComposer,
      $$AreasTableOrderingComposer,
      $$AreasTableAnnotationComposer,
      $$AreasTableCreateCompanionBuilder,
      $$AreasTableUpdateCompanionBuilder,
      (Area, $$AreasTableReferences),
      Area,
      PrefetchHooks Function({
        bool inventoryItemsRefs,
        bool foodStocksRefs,
        bool layoutObjectsRefs,
      })
    >;
typedef $$InventoryItemsTableCreateCompanionBuilder =
    InventoryItemsCompanion Function({
      Value<int> id,
      Value<int?> areaId,
      required String name,
      Value<int> quantity,
      Value<String> condition,
      Value<String?> notes,
      Value<String?> photoPath,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$InventoryItemsTableUpdateCompanionBuilder =
    InventoryItemsCompanion Function({
      Value<int> id,
      Value<int?> areaId,
      Value<String> name,
      Value<int> quantity,
      Value<String> condition,
      Value<String?> notes,
      Value<String?> photoPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$InventoryItemsTableReferences
    extends BaseReferences<_$AppDatabase, $InventoryItemsTable, InventoryItem> {
  $$InventoryItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AreasTable _areaIdTable(_$AppDatabase db) =>
      db.areas.createAlias('inventory_items__area_id__areas__id');

  $$AreasTableProcessedTableManager? get areaId {
    final $_column = $_itemColumn<int>('area_id');
    if ($_column == null) return null;
    final manager = $$AreasTableTableManager(
      $_db,
      $_db.areas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_areaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InventoryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AreasTableFilterComposer get areaId {
    final $$AreasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.areaId,
      referencedTable: $db.areas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AreasTableFilterComposer(
            $db: $db,
            $table: $db.areas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AreasTableOrderingComposer get areaId {
    final $$AreasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.areaId,
      referencedTable: $db.areas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AreasTableOrderingComposer(
            $db: $db,
            $table: $db.areas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AreasTableAnnotationComposer get areaId {
    final $$AreasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.areaId,
      referencedTable: $db.areas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AreasTableAnnotationComposer(
            $db: $db,
            $table: $db.areas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryItemsTable,
          InventoryItem,
          $$InventoryItemsTableFilterComposer,
          $$InventoryItemsTableOrderingComposer,
          $$InventoryItemsTableAnnotationComposer,
          $$InventoryItemsTableCreateCompanionBuilder,
          $$InventoryItemsTableUpdateCompanionBuilder,
          (InventoryItem, $$InventoryItemsTableReferences),
          InventoryItem,
          PrefetchHooks Function({bool areaId})
        > {
  $$InventoryItemsTableTableManager(
    _$AppDatabase db,
    $InventoryItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> areaId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String> condition = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => InventoryItemsCompanion(
                id: id,
                areaId: areaId,
                name: name,
                quantity: quantity,
                condition: condition,
                notes: notes,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> areaId = const Value.absent(),
                required String name,
                Value<int> quantity = const Value.absent(),
                Value<String> condition = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => InventoryItemsCompanion.insert(
                id: id,
                areaId: areaId,
                name: name,
                quantity: quantity,
                condition: condition,
                notes: notes,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InventoryItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({areaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (areaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.areaId,
                                referencedTable: $$InventoryItemsTableReferences
                                    ._areaIdTable(db),
                                referencedColumn:
                                    $$InventoryItemsTableReferences
                                        ._areaIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InventoryItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryItemsTable,
      InventoryItem,
      $$InventoryItemsTableFilterComposer,
      $$InventoryItemsTableOrderingComposer,
      $$InventoryItemsTableAnnotationComposer,
      $$InventoryItemsTableCreateCompanionBuilder,
      $$InventoryItemsTableUpdateCompanionBuilder,
      (InventoryItem, $$InventoryItemsTableReferences),
      InventoryItem,
      PrefetchHooks Function({bool areaId})
    >;
typedef $$FoodStocksTableCreateCompanionBuilder =
    FoodStocksCompanion Function({
      Value<int> id,
      Value<int?> areaId,
      required String name,
      Value<String> category,
      Value<double> quantity,
      Value<String> unit,
      Value<DateTime?> expiryDate,
      Value<double?> lowStockThreshold,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$FoodStocksTableUpdateCompanionBuilder =
    FoodStocksCompanion Function({
      Value<int> id,
      Value<int?> areaId,
      Value<String> name,
      Value<String> category,
      Value<double> quantity,
      Value<String> unit,
      Value<DateTime?> expiryDate,
      Value<double?> lowStockThreshold,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$FoodStocksTableReferences
    extends BaseReferences<_$AppDatabase, $FoodStocksTable, FoodStock> {
  $$FoodStocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AreasTable _areaIdTable(_$AppDatabase db) =>
      db.areas.createAlias('food_stocks__area_id__areas__id');

  $$AreasTableProcessedTableManager? get areaId {
    final $_column = $_itemColumn<int>('area_id');
    if ($_column == null) return null;
    final manager = $$AreasTableTableManager(
      $_db,
      $_db.areas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_areaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FoodStocksTableFilterComposer
    extends Composer<_$AppDatabase, $FoodStocksTable> {
  $$FoodStocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AreasTableFilterComposer get areaId {
    final $$AreasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.areaId,
      referencedTable: $db.areas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AreasTableFilterComposer(
            $db: $db,
            $table: $db.areas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodStocksTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodStocksTable> {
  $$FoodStocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AreasTableOrderingComposer get areaId {
    final $$AreasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.areaId,
      referencedTable: $db.areas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AreasTableOrderingComposer(
            $db: $db,
            $table: $db.areas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodStocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodStocksTable> {
  $$FoodStocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AreasTableAnnotationComposer get areaId {
    final $$AreasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.areaId,
      referencedTable: $db.areas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AreasTableAnnotationComposer(
            $db: $db,
            $table: $db.areas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodStocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodStocksTable,
          FoodStock,
          $$FoodStocksTableFilterComposer,
          $$FoodStocksTableOrderingComposer,
          $$FoodStocksTableAnnotationComposer,
          $$FoodStocksTableCreateCompanionBuilder,
          $$FoodStocksTableUpdateCompanionBuilder,
          (FoodStock, $$FoodStocksTableReferences),
          FoodStock,
          PrefetchHooks Function({bool areaId})
        > {
  $$FoodStocksTableTableManager(_$AppDatabase db, $FoodStocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodStocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodStocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodStocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> areaId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<double?> lowStockThreshold = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FoodStocksCompanion(
                id: id,
                areaId: areaId,
                name: name,
                category: category,
                quantity: quantity,
                unit: unit,
                expiryDate: expiryDate,
                lowStockThreshold: lowStockThreshold,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> areaId = const Value.absent(),
                required String name,
                Value<String> category = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<double?> lowStockThreshold = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => FoodStocksCompanion.insert(
                id: id,
                areaId: areaId,
                name: name,
                category: category,
                quantity: quantity,
                unit: unit,
                expiryDate: expiryDate,
                lowStockThreshold: lowStockThreshold,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FoodStocksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({areaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (areaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.areaId,
                                referencedTable: $$FoodStocksTableReferences
                                    ._areaIdTable(db),
                                referencedColumn: $$FoodStocksTableReferences
                                    ._areaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FoodStocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodStocksTable,
      FoodStock,
      $$FoodStocksTableFilterComposer,
      $$FoodStocksTableOrderingComposer,
      $$FoodStocksTableAnnotationComposer,
      $$FoodStocksTableCreateCompanionBuilder,
      $$FoodStocksTableUpdateCompanionBuilder,
      (FoodStock, $$FoodStocksTableReferences),
      FoodStock,
      PrefetchHooks Function({bool areaId})
    >;
typedef $$LaundryLogsTableCreateCompanionBuilder =
    LaundryLogsCompanion Function({
      Value<int> id,
      required DateTime completedAt,
      Value<String?> notes,
      Value<DateTime?> nextReminderAt,
    });
typedef $$LaundryLogsTableUpdateCompanionBuilder =
    LaundryLogsCompanion Function({
      Value<int> id,
      Value<DateTime> completedAt,
      Value<String?> notes,
      Value<DateTime?> nextReminderAt,
    });

class $$LaundryLogsTableFilterComposer
    extends Composer<_$AppDatabase, $LaundryLogsTable> {
  $$LaundryLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReminderAt => $composableBuilder(
    column: $table.nextReminderAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LaundryLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $LaundryLogsTable> {
  $$LaundryLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReminderAt => $composableBuilder(
    column: $table.nextReminderAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LaundryLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LaundryLogsTable> {
  $$LaundryLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get nextReminderAt => $composableBuilder(
    column: $table.nextReminderAt,
    builder: (column) => column,
  );
}

class $$LaundryLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LaundryLogsTable,
          LaundryLog,
          $$LaundryLogsTableFilterComposer,
          $$LaundryLogsTableOrderingComposer,
          $$LaundryLogsTableAnnotationComposer,
          $$LaundryLogsTableCreateCompanionBuilder,
          $$LaundryLogsTableUpdateCompanionBuilder,
          (
            LaundryLog,
            BaseReferences<_$AppDatabase, $LaundryLogsTable, LaundryLog>,
          ),
          LaundryLog,
          PrefetchHooks Function()
        > {
  $$LaundryLogsTableTableManager(_$AppDatabase db, $LaundryLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LaundryLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LaundryLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LaundryLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> nextReminderAt = const Value.absent(),
              }) => LaundryLogsCompanion(
                id: id,
                completedAt: completedAt,
                notes: notes,
                nextReminderAt: nextReminderAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime completedAt,
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> nextReminderAt = const Value.absent(),
              }) => LaundryLogsCompanion.insert(
                id: id,
                completedAt: completedAt,
                notes: notes,
                nextReminderAt: nextReminderAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LaundryLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LaundryLogsTable,
      LaundryLog,
      $$LaundryLogsTableFilterComposer,
      $$LaundryLogsTableOrderingComposer,
      $$LaundryLogsTableAnnotationComposer,
      $$LaundryLogsTableCreateCompanionBuilder,
      $$LaundryLogsTableUpdateCompanionBuilder,
      (
        LaundryLog,
        BaseReferences<_$AppDatabase, $LaundryLogsTable, LaundryLog>,
      ),
      LaundryLog,
      PrefetchHooks Function()
    >;
typedef $$PaymentLogsTableCreateCompanionBuilder =
    PaymentLogsCompanion Function({
      Value<int> id,
      Value<String> billType,
      required String billingMonth,
      required DateTime paidAt,
      Value<int> amountCents,
      Value<String?> notes,
      Value<DateTime?> nextReminderAt,
    });
typedef $$PaymentLogsTableUpdateCompanionBuilder =
    PaymentLogsCompanion Function({
      Value<int> id,
      Value<String> billType,
      Value<String> billingMonth,
      Value<DateTime> paidAt,
      Value<int> amountCents,
      Value<String?> notes,
      Value<DateTime?> nextReminderAt,
    });

class $$PaymentLogsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentLogsTable> {
  $$PaymentLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billType => $composableBuilder(
    column: $table.billType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billingMonth => $composableBuilder(
    column: $table.billingMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReminderAt => $composableBuilder(
    column: $table.nextReminderAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentLogsTable> {
  $$PaymentLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billType => $composableBuilder(
    column: $table.billType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billingMonth => $composableBuilder(
    column: $table.billingMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReminderAt => $composableBuilder(
    column: $table.nextReminderAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentLogsTable> {
  $$PaymentLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get billType =>
      $composableBuilder(column: $table.billType, builder: (column) => column);

  GeneratedColumn<String> get billingMonth => $composableBuilder(
    column: $table.billingMonth,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get nextReminderAt => $composableBuilder(
    column: $table.nextReminderAt,
    builder: (column) => column,
  );
}

class $$PaymentLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentLogsTable,
          PaymentLog,
          $$PaymentLogsTableFilterComposer,
          $$PaymentLogsTableOrderingComposer,
          $$PaymentLogsTableAnnotationComposer,
          $$PaymentLogsTableCreateCompanionBuilder,
          $$PaymentLogsTableUpdateCompanionBuilder,
          (
            PaymentLog,
            BaseReferences<_$AppDatabase, $PaymentLogsTable, PaymentLog>,
          ),
          PaymentLog,
          PrefetchHooks Function()
        > {
  $$PaymentLogsTableTableManager(_$AppDatabase db, $PaymentLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> billType = const Value.absent(),
                Value<String> billingMonth = const Value.absent(),
                Value<DateTime> paidAt = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> nextReminderAt = const Value.absent(),
              }) => PaymentLogsCompanion(
                id: id,
                billType: billType,
                billingMonth: billingMonth,
                paidAt: paidAt,
                amountCents: amountCents,
                notes: notes,
                nextReminderAt: nextReminderAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> billType = const Value.absent(),
                required String billingMonth,
                required DateTime paidAt,
                Value<int> amountCents = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> nextReminderAt = const Value.absent(),
              }) => PaymentLogsCompanion.insert(
                id: id,
                billType: billType,
                billingMonth: billingMonth,
                paidAt: paidAt,
                amountCents: amountCents,
                notes: notes,
                nextReminderAt: nextReminderAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentLogsTable,
      PaymentLog,
      $$PaymentLogsTableFilterComposer,
      $$PaymentLogsTableOrderingComposer,
      $$PaymentLogsTableAnnotationComposer,
      $$PaymentLogsTableCreateCompanionBuilder,
      $$PaymentLogsTableUpdateCompanionBuilder,
      (
        PaymentLog,
        BaseReferences<_$AppDatabase, $PaymentLogsTable, PaymentLog>,
      ),
      PaymentLog,
      PrefetchHooks Function()
    >;
typedef $$TodoItemsTableCreateCompanionBuilder =
    TodoItemsCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> notes,
      Value<bool> isDone,
      Value<DateTime?> dueAt,
      Value<DateTime?> reminderAt,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$TodoItemsTableUpdateCompanionBuilder =
    TodoItemsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> notes,
      Value<bool> isDone,
      Value<DateTime?> dueAt,
      Value<DateTime?> reminderAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$TodoItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TodoItemsTable> {
  $$TodoItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TodoItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoItemsTable> {
  $$TodoItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodoItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoItemsTable> {
  $$TodoItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TodoItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodoItemsTable,
          TodoItem,
          $$TodoItemsTableFilterComposer,
          $$TodoItemsTableOrderingComposer,
          $$TodoItemsTableAnnotationComposer,
          $$TodoItemsTableCreateCompanionBuilder,
          $$TodoItemsTableUpdateCompanionBuilder,
          (TodoItem, BaseReferences<_$AppDatabase, $TodoItemsTable, TodoItem>),
          TodoItem,
          PrefetchHooks Function()
        > {
  $$TodoItemsTableTableManager(_$AppDatabase db, $TodoItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<DateTime?> reminderAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TodoItemsCompanion(
                id: id,
                title: title,
                notes: notes,
                isDone: isDone,
                dueAt: dueAt,
                reminderAt: reminderAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> notes = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<DateTime?> reminderAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => TodoItemsCompanion.insert(
                id: id,
                title: title,
                notes: notes,
                isDone: isDone,
                dueAt: dueAt,
                reminderAt: reminderAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TodoItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodoItemsTable,
      TodoItem,
      $$TodoItemsTableFilterComposer,
      $$TodoItemsTableOrderingComposer,
      $$TodoItemsTableAnnotationComposer,
      $$TodoItemsTableCreateCompanionBuilder,
      $$TodoItemsTableUpdateCompanionBuilder,
      (TodoItem, BaseReferences<_$AppDatabase, $TodoItemsTable, TodoItem>),
      TodoItem,
      PrefetchHooks Function()
    >;
typedef $$RoomLayoutsTableCreateCompanionBuilder =
    RoomLayoutsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> width,
      Value<double> height,
      Value<double> gridSize,
      required DateTime updatedAt,
    });
typedef $$RoomLayoutsTableUpdateCompanionBuilder =
    RoomLayoutsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> width,
      Value<double> height,
      Value<double> gridSize,
      Value<DateTime> updatedAt,
    });

final class $$RoomLayoutsTableReferences
    extends BaseReferences<_$AppDatabase, $RoomLayoutsTable, RoomLayout> {
  $$RoomLayoutsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LayoutObjectsTable, List<LayoutObject>>
  _layoutObjectsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.layoutObjects,
    aliasName: 'room_layouts__id__layout_objects__layout_id',
  );

  $$LayoutObjectsTableProcessedTableManager get layoutObjectsRefs {
    final manager = $$LayoutObjectsTableTableManager(
      $_db,
      $_db.layoutObjects,
    ).filter((f) => f.layoutId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_layoutObjectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoomLayoutsTableFilterComposer
    extends Composer<_$AppDatabase, $RoomLayoutsTable> {
  $$RoomLayoutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gridSize => $composableBuilder(
    column: $table.gridSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> layoutObjectsRefs(
    Expression<bool> Function($$LayoutObjectsTableFilterComposer f) f,
  ) {
    final $$LayoutObjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.layoutObjects,
      getReferencedColumn: (t) => t.layoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutObjectsTableFilterComposer(
            $db: $db,
            $table: $db.layoutObjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoomLayoutsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomLayoutsTable> {
  $$RoomLayoutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gridSize => $composableBuilder(
    column: $table.gridSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoomLayoutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomLayoutsTable> {
  $$RoomLayoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<double> get gridSize =>
      $composableBuilder(column: $table.gridSize, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> layoutObjectsRefs<T extends Object>(
    Expression<T> Function($$LayoutObjectsTableAnnotationComposer a) f,
  ) {
    final $$LayoutObjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.layoutObjects,
      getReferencedColumn: (t) => t.layoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutObjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.layoutObjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoomLayoutsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoomLayoutsTable,
          RoomLayout,
          $$RoomLayoutsTableFilterComposer,
          $$RoomLayoutsTableOrderingComposer,
          $$RoomLayoutsTableAnnotationComposer,
          $$RoomLayoutsTableCreateCompanionBuilder,
          $$RoomLayoutsTableUpdateCompanionBuilder,
          (RoomLayout, $$RoomLayoutsTableReferences),
          RoomLayout,
          PrefetchHooks Function({bool layoutObjectsRefs})
        > {
  $$RoomLayoutsTableTableManager(_$AppDatabase db, $RoomLayoutsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomLayoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomLayoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomLayoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> width = const Value.absent(),
                Value<double> height = const Value.absent(),
                Value<double> gridSize = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RoomLayoutsCompanion(
                id: id,
                name: name,
                width: width,
                height: height,
                gridSize: gridSize,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> width = const Value.absent(),
                Value<double> height = const Value.absent(),
                Value<double> gridSize = const Value.absent(),
                required DateTime updatedAt,
              }) => RoomLayoutsCompanion.insert(
                id: id,
                name: name,
                width: width,
                height: height,
                gridSize: gridSize,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoomLayoutsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({layoutObjectsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (layoutObjectsRefs) db.layoutObjects,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (layoutObjectsRefs)
                    await $_getPrefetchedData<
                      RoomLayout,
                      $RoomLayoutsTable,
                      LayoutObject
                    >(
                      currentTable: table,
                      referencedTable: $$RoomLayoutsTableReferences
                          ._layoutObjectsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RoomLayoutsTableReferences(
                            db,
                            table,
                            p0,
                          ).layoutObjectsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.layoutId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RoomLayoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoomLayoutsTable,
      RoomLayout,
      $$RoomLayoutsTableFilterComposer,
      $$RoomLayoutsTableOrderingComposer,
      $$RoomLayoutsTableAnnotationComposer,
      $$RoomLayoutsTableCreateCompanionBuilder,
      $$RoomLayoutsTableUpdateCompanionBuilder,
      (RoomLayout, $$RoomLayoutsTableReferences),
      RoomLayout,
      PrefetchHooks Function({bool layoutObjectsRefs})
    >;
typedef $$LayoutObjectsTableCreateCompanionBuilder =
    LayoutObjectsCompanion Function({
      Value<int> id,
      required int layoutId,
      Value<int?> linkedAreaId,
      required String label,
      Value<String> kind,
      Value<double> x,
      Value<double> y,
      Value<double> width,
      Value<double> height,
      Value<double> rotation,
      Value<String> colorHex,
      Value<int> zOrder,
    });
typedef $$LayoutObjectsTableUpdateCompanionBuilder =
    LayoutObjectsCompanion Function({
      Value<int> id,
      Value<int> layoutId,
      Value<int?> linkedAreaId,
      Value<String> label,
      Value<String> kind,
      Value<double> x,
      Value<double> y,
      Value<double> width,
      Value<double> height,
      Value<double> rotation,
      Value<String> colorHex,
      Value<int> zOrder,
    });

final class $$LayoutObjectsTableReferences
    extends BaseReferences<_$AppDatabase, $LayoutObjectsTable, LayoutObject> {
  $$LayoutObjectsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoomLayoutsTable _layoutIdTable(_$AppDatabase db) =>
      db.roomLayouts.createAlias('layout_objects__layout_id__room_layouts__id');

  $$RoomLayoutsTableProcessedTableManager get layoutId {
    final $_column = $_itemColumn<int>('layout_id')!;

    final manager = $$RoomLayoutsTableTableManager(
      $_db,
      $_db.roomLayouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_layoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AreasTable _linkedAreaIdTable(_$AppDatabase db) =>
      db.areas.createAlias('layout_objects__linked_area_id__areas__id');

  $$AreasTableProcessedTableManager? get linkedAreaId {
    final $_column = $_itemColumn<int>('linked_area_id');
    if ($_column == null) return null;
    final manager = $$AreasTableTableManager(
      $_db,
      $_db.areas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_linkedAreaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LayoutObjectsTableFilterComposer
    extends Composer<_$AppDatabase, $LayoutObjectsTable> {
  $$LayoutObjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rotation => $composableBuilder(
    column: $table.rotation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get zOrder => $composableBuilder(
    column: $table.zOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$RoomLayoutsTableFilterComposer get layoutId {
    final $$RoomLayoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.layoutId,
      referencedTable: $db.roomLayouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomLayoutsTableFilterComposer(
            $db: $db,
            $table: $db.roomLayouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AreasTableFilterComposer get linkedAreaId {
    final $$AreasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedAreaId,
      referencedTable: $db.areas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AreasTableFilterComposer(
            $db: $db,
            $table: $db.areas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LayoutObjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $LayoutObjectsTable> {
  $$LayoutObjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rotation => $composableBuilder(
    column: $table.rotation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get zOrder => $composableBuilder(
    column: $table.zOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoomLayoutsTableOrderingComposer get layoutId {
    final $$RoomLayoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.layoutId,
      referencedTable: $db.roomLayouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomLayoutsTableOrderingComposer(
            $db: $db,
            $table: $db.roomLayouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AreasTableOrderingComposer get linkedAreaId {
    final $$AreasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedAreaId,
      referencedTable: $db.areas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AreasTableOrderingComposer(
            $db: $db,
            $table: $db.areas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LayoutObjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LayoutObjectsTable> {
  $$LayoutObjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<double> get x =>
      $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<double> get y =>
      $composableBuilder(column: $table.y, builder: (column) => column);

  GeneratedColumn<double> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<double> get rotation =>
      $composableBuilder(column: $table.rotation, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<int> get zOrder =>
      $composableBuilder(column: $table.zOrder, builder: (column) => column);

  $$RoomLayoutsTableAnnotationComposer get layoutId {
    final $$RoomLayoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.layoutId,
      referencedTable: $db.roomLayouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomLayoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.roomLayouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AreasTableAnnotationComposer get linkedAreaId {
    final $$AreasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedAreaId,
      referencedTable: $db.areas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AreasTableAnnotationComposer(
            $db: $db,
            $table: $db.areas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LayoutObjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LayoutObjectsTable,
          LayoutObject,
          $$LayoutObjectsTableFilterComposer,
          $$LayoutObjectsTableOrderingComposer,
          $$LayoutObjectsTableAnnotationComposer,
          $$LayoutObjectsTableCreateCompanionBuilder,
          $$LayoutObjectsTableUpdateCompanionBuilder,
          (LayoutObject, $$LayoutObjectsTableReferences),
          LayoutObject,
          PrefetchHooks Function({bool layoutId, bool linkedAreaId})
        > {
  $$LayoutObjectsTableTableManager(_$AppDatabase db, $LayoutObjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LayoutObjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LayoutObjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LayoutObjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> layoutId = const Value.absent(),
                Value<int?> linkedAreaId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<double> x = const Value.absent(),
                Value<double> y = const Value.absent(),
                Value<double> width = const Value.absent(),
                Value<double> height = const Value.absent(),
                Value<double> rotation = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<int> zOrder = const Value.absent(),
              }) => LayoutObjectsCompanion(
                id: id,
                layoutId: layoutId,
                linkedAreaId: linkedAreaId,
                label: label,
                kind: kind,
                x: x,
                y: y,
                width: width,
                height: height,
                rotation: rotation,
                colorHex: colorHex,
                zOrder: zOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int layoutId,
                Value<int?> linkedAreaId = const Value.absent(),
                required String label,
                Value<String> kind = const Value.absent(),
                Value<double> x = const Value.absent(),
                Value<double> y = const Value.absent(),
                Value<double> width = const Value.absent(),
                Value<double> height = const Value.absent(),
                Value<double> rotation = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<int> zOrder = const Value.absent(),
              }) => LayoutObjectsCompanion.insert(
                id: id,
                layoutId: layoutId,
                linkedAreaId: linkedAreaId,
                label: label,
                kind: kind,
                x: x,
                y: y,
                width: width,
                height: height,
                rotation: rotation,
                colorHex: colorHex,
                zOrder: zOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LayoutObjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({layoutId = false, linkedAreaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (layoutId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.layoutId,
                                referencedTable: $$LayoutObjectsTableReferences
                                    ._layoutIdTable(db),
                                referencedColumn: $$LayoutObjectsTableReferences
                                    ._layoutIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (linkedAreaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.linkedAreaId,
                                referencedTable: $$LayoutObjectsTableReferences
                                    ._linkedAreaIdTable(db),
                                referencedColumn: $$LayoutObjectsTableReferences
                                    ._linkedAreaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LayoutObjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LayoutObjectsTable,
      LayoutObject,
      $$LayoutObjectsTableFilterComposer,
      $$LayoutObjectsTableOrderingComposer,
      $$LayoutObjectsTableAnnotationComposer,
      $$LayoutObjectsTableCreateCompanionBuilder,
      $$LayoutObjectsTableUpdateCompanionBuilder,
      (LayoutObject, $$LayoutObjectsTableReferences),
      LayoutObject,
      PrefetchHooks Function({bool layoutId, bool linkedAreaId})
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      required String ownerType,
      Value<int?> ownerId,
      required String title,
      Value<String?> body,
      required DateTime scheduledAt,
      required int notificationId,
      Value<String> status,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      Value<String> ownerType,
      Value<int?> ownerId,
      Value<String> title,
      Value<String?> body,
      Value<DateTime> scheduledAt,
      Value<int> notificationId,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerType => $composableBuilder(
    column: $table.ownerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerType => $composableBuilder(
    column: $table.ownerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerType =>
      $composableBuilder(column: $table.ownerType, builder: (column) => column);

  GeneratedColumn<int> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> ownerType = const Value.absent(),
                Value<int?> ownerId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> body = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<int> notificationId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                ownerType: ownerType,
                ownerId: ownerId,
                title: title,
                body: body,
                scheduledAt: scheduledAt,
                notificationId: notificationId,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String ownerType,
                Value<int?> ownerId = const Value.absent(),
                required String title,
                Value<String?> body = const Value.absent(),
                required DateTime scheduledAt,
                required int notificationId,
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => RemindersCompanion.insert(
                id: id,
                ownerType: ownerType,
                ownerId: ownerId,
                title: title,
                body: body,
                scheduledAt: scheduledAt,
                notificationId: notificationId,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AreasTableTableManager get areas =>
      $$AreasTableTableManager(_db, _db.areas);
  $$InventoryItemsTableTableManager get inventoryItems =>
      $$InventoryItemsTableTableManager(_db, _db.inventoryItems);
  $$FoodStocksTableTableManager get foodStocks =>
      $$FoodStocksTableTableManager(_db, _db.foodStocks);
  $$LaundryLogsTableTableManager get laundryLogs =>
      $$LaundryLogsTableTableManager(_db, _db.laundryLogs);
  $$PaymentLogsTableTableManager get paymentLogs =>
      $$PaymentLogsTableTableManager(_db, _db.paymentLogs);
  $$TodoItemsTableTableManager get todoItems =>
      $$TodoItemsTableTableManager(_db, _db.todoItems);
  $$RoomLayoutsTableTableManager get roomLayouts =>
      $$RoomLayoutsTableTableManager(_db, _db.roomLayouts);
  $$LayoutObjectsTableTableManager get layoutObjects =>
      $$LayoutObjectsTableTableManager(_db, _db.layoutObjects);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
}
