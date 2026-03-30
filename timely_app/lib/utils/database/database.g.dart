// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class Chunks extends Table with TableInfo<Chunks, Chunk> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Chunks(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    true,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (type IN (\'periodic\', \'daily\'))',
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'isActive',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  static const VerificationMeta _startHourMeta = const VerificationMeta(
    'startHour',
  );
  late final GeneratedColumn<int> startHour = GeneratedColumn<int>(
    'startHour',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _startMinuteMeta = const VerificationMeta(
    'startMinute',
  );
  late final GeneratedColumn<int> startMinute = GeneratedColumn<int>(
    'startMinute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _endHourMeta = const VerificationMeta(
    'endHour',
  );
  late final GeneratedColumn<int> endHour = GeneratedColumn<int>(
    'endHour',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _endMinuteMeta = const VerificationMeta(
    'endMinute',
  );
  late final GeneratedColumn<int> endMinute = GeneratedColumn<int>(
    'endMinute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  late final GeneratedColumn<String> weekday = GeneratedColumn<String>(
    'weekday',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    isActive,
    startHour,
    startMinute,
    endHour,
    endMinute,
    date,
    weekday,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chunks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chunk> instance, {
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
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('isActive')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['isActive']!, _isActiveMeta),
      );
    }
    if (data.containsKey('startHour')) {
      context.handle(
        _startHourMeta,
        startHour.isAcceptableOrUnknown(data['startHour']!, _startHourMeta),
      );
    }
    if (data.containsKey('startMinute')) {
      context.handle(
        _startMinuteMeta,
        startMinute.isAcceptableOrUnknown(
          data['startMinute']!,
          _startMinuteMeta,
        ),
      );
    }
    if (data.containsKey('endHour')) {
      context.handle(
        _endHourMeta,
        endHour.isAcceptableOrUnknown(data['endHour']!, _endHourMeta),
      );
    }
    if (data.containsKey('endMinute')) {
      context.handle(
        _endMinuteMeta,
        endMinute.isAcceptableOrUnknown(data['endMinute']!, _endMinuteMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chunk map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chunk(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}isActive'],
      )!,
      startHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}startHour'],
      ),
      startMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}startMinute'],
      )!,
      endHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}endHour'],
      ),
      endMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}endMinute'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      ),
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weekday'],
      ),
    );
  }

  @override
  Chunks createAlias(String alias) {
    return Chunks(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'CHECK((type = \'daily\' AND startHour IS NOT NULL AND endHour IS NOT NULL AND date IS NULL AND weekday IS NULL)OR(type = \'periodic\' AND date IS NOT NULL AND startHour IS NOT NULL AND endHour IS NOT NULL AND weekday IS NOT NULL))',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class Chunk extends DataClass implements Insertable<Chunk> {
  final int? id;
  final String name;
  final String type;
  final int isActive;
  final int? startHour;
  final int startMinute;
  final int? endHour;
  final int endMinute;
  final String? date;
  final String? weekday;
  const Chunk({
    this.id,
    required this.name,
    required this.type,
    required this.isActive,
    this.startHour,
    required this.startMinute,
    this.endHour,
    required this.endMinute,
    this.date,
    this.weekday,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['isActive'] = Variable<int>(isActive);
    if (!nullToAbsent || startHour != null) {
      map['startHour'] = Variable<int>(startHour);
    }
    map['startMinute'] = Variable<int>(startMinute);
    if (!nullToAbsent || endHour != null) {
      map['endHour'] = Variable<int>(endHour);
    }
    map['endMinute'] = Variable<int>(endMinute);
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<String>(date);
    }
    if (!nullToAbsent || weekday != null) {
      map['weekday'] = Variable<String>(weekday);
    }
    return map;
  }

  ChunksCompanion toCompanion(bool nullToAbsent) {
    return ChunksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: Value(name),
      type: Value(type),
      isActive: Value(isActive),
      startHour: startHour == null && nullToAbsent
          ? const Value.absent()
          : Value(startHour),
      startMinute: Value(startMinute),
      endHour: endHour == null && nullToAbsent
          ? const Value.absent()
          : Value(endHour),
      endMinute: Value(endMinute),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      weekday: weekday == null && nullToAbsent
          ? const Value.absent()
          : Value(weekday),
    );
  }

  factory Chunk.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chunk(
      id: serializer.fromJson<int?>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      isActive: serializer.fromJson<int>(json['isActive']),
      startHour: serializer.fromJson<int?>(json['startHour']),
      startMinute: serializer.fromJson<int>(json['startMinute']),
      endHour: serializer.fromJson<int?>(json['endHour']),
      endMinute: serializer.fromJson<int>(json['endMinute']),
      date: serializer.fromJson<String?>(json['date']),
      weekday: serializer.fromJson<String?>(json['weekday']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'isActive': serializer.toJson<int>(isActive),
      'startHour': serializer.toJson<int?>(startHour),
      'startMinute': serializer.toJson<int>(startMinute),
      'endHour': serializer.toJson<int?>(endHour),
      'endMinute': serializer.toJson<int>(endMinute),
      'date': serializer.toJson<String?>(date),
      'weekday': serializer.toJson<String?>(weekday),
    };
  }

  Chunk copyWith({
    Value<int?> id = const Value.absent(),
    String? name,
    String? type,
    int? isActive,
    Value<int?> startHour = const Value.absent(),
    int? startMinute,
    Value<int?> endHour = const Value.absent(),
    int? endMinute,
    Value<String?> date = const Value.absent(),
    Value<String?> weekday = const Value.absent(),
  }) => Chunk(
    id: id.present ? id.value : this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    isActive: isActive ?? this.isActive,
    startHour: startHour.present ? startHour.value : this.startHour,
    startMinute: startMinute ?? this.startMinute,
    endHour: endHour.present ? endHour.value : this.endHour,
    endMinute: endMinute ?? this.endMinute,
    date: date.present ? date.value : this.date,
    weekday: weekday.present ? weekday.value : this.weekday,
  );
  Chunk copyWithCompanion(ChunksCompanion data) {
    return Chunk(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      startHour: data.startHour.present ? data.startHour.value : this.startHour,
      startMinute: data.startMinute.present
          ? data.startMinute.value
          : this.startMinute,
      endHour: data.endHour.present ? data.endHour.value : this.endHour,
      endMinute: data.endMinute.present ? data.endMinute.value : this.endMinute,
      date: data.date.present ? data.date.value : this.date,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chunk(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('isActive: $isActive, ')
          ..write('startHour: $startHour, ')
          ..write('startMinute: $startMinute, ')
          ..write('endHour: $endHour, ')
          ..write('endMinute: $endMinute, ')
          ..write('date: $date, ')
          ..write('weekday: $weekday')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    isActive,
    startHour,
    startMinute,
    endHour,
    endMinute,
    date,
    weekday,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chunk &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.isActive == this.isActive &&
          other.startHour == this.startHour &&
          other.startMinute == this.startMinute &&
          other.endHour == this.endHour &&
          other.endMinute == this.endMinute &&
          other.date == this.date &&
          other.weekday == this.weekday);
}

class ChunksCompanion extends UpdateCompanion<Chunk> {
  final Value<int?> id;
  final Value<String> name;
  final Value<String> type;
  final Value<int> isActive;
  final Value<int?> startHour;
  final Value<int> startMinute;
  final Value<int?> endHour;
  final Value<int> endMinute;
  final Value<String?> date;
  final Value<String?> weekday;
  const ChunksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.isActive = const Value.absent(),
    this.startHour = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endHour = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.date = const Value.absent(),
    this.weekday = const Value.absent(),
  });
  ChunksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    this.isActive = const Value.absent(),
    this.startHour = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endHour = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.date = const Value.absent(),
    this.weekday = const Value.absent(),
  }) : name = Value(name),
       type = Value(type);
  static Insertable<Chunk> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? isActive,
    Expression<int>? startHour,
    Expression<int>? startMinute,
    Expression<int>? endHour,
    Expression<int>? endMinute,
    Expression<String>? date,
    Expression<String>? weekday,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (isActive != null) 'isActive': isActive,
      if (startHour != null) 'startHour': startHour,
      if (startMinute != null) 'startMinute': startMinute,
      if (endHour != null) 'endHour': endHour,
      if (endMinute != null) 'endMinute': endMinute,
      if (date != null) 'date': date,
      if (weekday != null) 'weekday': weekday,
    });
  }

  ChunksCompanion copyWith({
    Value<int?>? id,
    Value<String>? name,
    Value<String>? type,
    Value<int>? isActive,
    Value<int?>? startHour,
    Value<int>? startMinute,
    Value<int?>? endHour,
    Value<int>? endMinute,
    Value<String?>? date,
    Value<String?>? weekday,
  }) {
    return ChunksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      date: date ?? this.date,
      weekday: weekday ?? this.weekday,
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
    if (isActive.present) {
      map['isActive'] = Variable<int>(isActive.value);
    }
    if (startHour.present) {
      map['startHour'] = Variable<int>(startHour.value);
    }
    if (startMinute.present) {
      map['startMinute'] = Variable<int>(startMinute.value);
    }
    if (endHour.present) {
      map['endHour'] = Variable<int>(endHour.value);
    }
    if (endMinute.present) {
      map['endMinute'] = Variable<int>(endMinute.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<String>(weekday.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChunksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('isActive: $isActive, ')
          ..write('startHour: $startHour, ')
          ..write('startMinute: $startMinute, ')
          ..write('endHour: $endHour, ')
          ..write('endMinute: $endMinute, ')
          ..write('date: $date, ')
          ..write('weekday: $weekday')
          ..write(')'))
        .toString();
  }
}

class Activities extends Table with TableInfo<Activities, Activity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Activities(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    true,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (type IN (\'everyday\', \'periodic\', \'range\'))',
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  late final GeneratedColumn<String> weekday = GeneratedColumn<String>(
    'weekday',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'startDate',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'endDate',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'startTime',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'endTime',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  late final GeneratedColumn<int> completed = GeneratedColumn<int>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _chunkIdMeta = const VerificationMeta(
    'chunkId',
  );
  late final GeneratedColumn<int> chunkId = GeneratedColumn<int>(
    'chunkId',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES chunks(id)ON DELETE CASCADE',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    description,
    type,
    date,
    weekday,
    startDate,
    endDate,
    startTime,
    endTime,
    completed,
    chunkId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Activity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    }
    if (data.containsKey('startDate')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['startDate']!, _startDateMeta),
      );
    }
    if (data.containsKey('endDate')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['endDate']!, _endDateMeta),
      );
    }
    if (data.containsKey('startTime')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['startTime']!, _startTimeMeta),
      );
    }
    if (data.containsKey('endTime')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['endTime']!, _endTimeMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('chunkId')) {
      context.handle(
        _chunkIdMeta,
        chunkId.isAcceptableOrUnknown(data['chunkId']!, _chunkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chunkIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Activity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Activity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      ),
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weekday'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}startDate'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}endDate'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}startTime'],
      ),
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}endTime'],
      ),
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed'],
      )!,
      chunkId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chunkId'],
      )!,
    );
  }

  @override
  Activities createAlias(String alias) {
    return Activities(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'CHECK((type = \'everyday\' AND date IS NOT NULL AND startDate IS NULL AND endDate IS NULL)OR(type = \'periodic\' AND weekday IS NOT NULL AND startDate IS NULL AND endDate IS NULL)OR(type = \'range\' AND date IS NULL AND startDate IS NOT NULL AND endDate IS NOT NULL AND startDate <= endDate))',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class Activity extends DataClass implements Insertable<Activity> {
  final int? id;
  final String description;
  final String type;
  final String? date;
  final String? weekday;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final int completed;
  final int chunkId;
  const Activity({
    this.id,
    required this.description,
    required this.type,
    this.date,
    this.weekday,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    required this.completed,
    required this.chunkId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    map['description'] = Variable<String>(description);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<String>(date);
    }
    if (!nullToAbsent || weekday != null) {
      map['weekday'] = Variable<String>(weekday);
    }
    if (!nullToAbsent || startDate != null) {
      map['startDate'] = Variable<String>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['endDate'] = Variable<String>(endDate);
    }
    if (!nullToAbsent || startTime != null) {
      map['startTime'] = Variable<String>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['endTime'] = Variable<String>(endTime);
    }
    map['completed'] = Variable<int>(completed);
    map['chunkId'] = Variable<int>(chunkId);
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      description: Value(description),
      type: Value(type),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      weekday: weekday == null && nullToAbsent
          ? const Value.absent()
          : Value(weekday),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      completed: Value(completed),
      chunkId: Value(chunkId),
    );
  }

  factory Activity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Activity(
      id: serializer.fromJson<int?>(json['id']),
      description: serializer.fromJson<String>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      date: serializer.fromJson<String?>(json['date']),
      weekday: serializer.fromJson<String?>(json['weekday']),
      startDate: serializer.fromJson<String?>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      startTime: serializer.fromJson<String?>(json['startTime']),
      endTime: serializer.fromJson<String?>(json['endTime']),
      completed: serializer.fromJson<int>(json['completed']),
      chunkId: serializer.fromJson<int>(json['chunkId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'description': serializer.toJson<String>(description),
      'type': serializer.toJson<String>(type),
      'date': serializer.toJson<String?>(date),
      'weekday': serializer.toJson<String?>(weekday),
      'startDate': serializer.toJson<String?>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'startTime': serializer.toJson<String?>(startTime),
      'endTime': serializer.toJson<String?>(endTime),
      'completed': serializer.toJson<int>(completed),
      'chunkId': serializer.toJson<int>(chunkId),
    };
  }

  Activity copyWith({
    Value<int?> id = const Value.absent(),
    String? description,
    String? type,
    Value<String?> date = const Value.absent(),
    Value<String?> weekday = const Value.absent(),
    Value<String?> startDate = const Value.absent(),
    Value<String?> endDate = const Value.absent(),
    Value<String?> startTime = const Value.absent(),
    Value<String?> endTime = const Value.absent(),
    int? completed,
    int? chunkId,
  }) => Activity(
    id: id.present ? id.value : this.id,
    description: description ?? this.description,
    type: type ?? this.type,
    date: date.present ? date.value : this.date,
    weekday: weekday.present ? weekday.value : this.weekday,
    startDate: startDate.present ? startDate.value : this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    startTime: startTime.present ? startTime.value : this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    completed: completed ?? this.completed,
    chunkId: chunkId ?? this.chunkId,
  );
  Activity copyWithCompanion(ActivitiesCompanion data) {
    return Activity(
      id: data.id.present ? data.id.value : this.id,
      description: data.description.present
          ? data.description.value
          : this.description,
      type: data.type.present ? data.type.value : this.type,
      date: data.date.present ? data.date.value : this.date,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      completed: data.completed.present ? data.completed.value : this.completed,
      chunkId: data.chunkId.present ? data.chunkId.value : this.chunkId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Activity(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('weekday: $weekday, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('completed: $completed, ')
          ..write('chunkId: $chunkId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    description,
    type,
    date,
    weekday,
    startDate,
    endDate,
    startTime,
    endTime,
    completed,
    chunkId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activity &&
          other.id == this.id &&
          other.description == this.description &&
          other.type == this.type &&
          other.date == this.date &&
          other.weekday == this.weekday &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.completed == this.completed &&
          other.chunkId == this.chunkId);
}

class ActivitiesCompanion extends UpdateCompanion<Activity> {
  final Value<int?> id;
  final Value<String> description;
  final Value<String> type;
  final Value<String?> date;
  final Value<String?> weekday;
  final Value<String?> startDate;
  final Value<String?> endDate;
  final Value<String?> startTime;
  final Value<String?> endTime;
  final Value<int> completed;
  final Value<int> chunkId;
  const ActivitiesCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.date = const Value.absent(),
    this.weekday = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.completed = const Value.absent(),
    this.chunkId = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    this.id = const Value.absent(),
    required String description,
    required String type,
    this.date = const Value.absent(),
    this.weekday = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.completed = const Value.absent(),
    required int chunkId,
  }) : description = Value(description),
       type = Value(type),
       chunkId = Value(chunkId);
  static Insertable<Activity> custom({
    Expression<int>? id,
    Expression<String>? description,
    Expression<String>? type,
    Expression<String>? date,
    Expression<String>? weekday,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<int>? completed,
    Expression<int>? chunkId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
      if (weekday != null) 'weekday': weekday,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
      if (completed != null) 'completed': completed,
      if (chunkId != null) 'chunkId': chunkId,
    });
  }

  ActivitiesCompanion copyWith({
    Value<int?>? id,
    Value<String>? description,
    Value<String>? type,
    Value<String?>? date,
    Value<String?>? weekday,
    Value<String?>? startDate,
    Value<String?>? endDate,
    Value<String?>? startTime,
    Value<String?>? endTime,
    Value<int>? completed,
    Value<int>? chunkId,
  }) {
    return ActivitiesCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
      type: type ?? this.type,
      date: date ?? this.date,
      weekday: weekday ?? this.weekday,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      completed: completed ?? this.completed,
      chunkId: chunkId ?? this.chunkId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<String>(weekday.value);
    }
    if (startDate.present) {
      map['startDate'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['endDate'] = Variable<String>(endDate.value);
    }
    if (startTime.present) {
      map['startTime'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['endTime'] = Variable<String>(endTime.value);
    }
    if (completed.present) {
      map['completed'] = Variable<int>(completed.value);
    }
    if (chunkId.present) {
      map['chunkId'] = Variable<int>(chunkId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('weekday: $weekday, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('completed: $completed, ')
          ..write('chunkId: $chunkId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final Chunks chunks = Chunks(this);
  late final Activities activities = Activities(this);
  Selectable<Chunk> getAllChunks() {
    return customSelect(
      'SELECT * FROM chunks',
      variables: [],
      readsFrom: {chunks},
    ).asyncMap(chunks.mapFromRow);
  }

  Selectable<Chunk> getActiveChunks() {
    return customSelect(
      'SELECT * FROM chunks WHERE isActive = 1',
      variables: [],
      readsFrom: {chunks},
    ).asyncMap(chunks.mapFromRow);
  }

  Selectable<Chunk> getChunkInfoByChunkName(String var1) {
    return customSelect(
      'SELECT * FROM chunks WHERE name = ?1',
      variables: [Variable<String>(var1)],
      readsFrom: {chunks},
    ).asyncMap(chunks.mapFromRow);
  }

  Selectable<Activity> getActivitiesByChunkId(int var1, String var2) {
    return customSelect(
      'SELECT * FROM activities WHERE chunkId = ?1 AND((type = \'everyday\' AND date(?2) = date(date))OR(type = \'periodic\' AND(instr(weekday, \'[\' || CASE CAST(strftime(\'%w\', ?2, \'localtime\') AS INTEGER) WHEN 0 THEN \'Sunday\' WHEN 1 THEN \'Monday\' WHEN 2 THEN \'Tuesday\' WHEN 3 THEN \'Wednesday\' WHEN 4 THEN \'Thursday\' WHEN 5 THEN \'Friday\' WHEN 6 THEN \'Saturday\' END) > 0 OR instr(weekday, \', \' || CASE CAST(strftime(\'%w\', ?2, \'localtime\') AS INTEGER) WHEN 0 THEN \'Sunday\' WHEN 1 THEN \'Monday\' WHEN 2 THEN \'Tuesday\' WHEN 3 THEN \'Wednesday\' WHEN 4 THEN \'Thursday\' WHEN 5 THEN \'Friday\' WHEN 6 THEN \'Saturday\' END) > 0))OR(type = \'range\' AND date(?2) BETWEEN date(startDate) AND date(endDate)))',
      variables: [Variable<int>(var1), Variable<String>(var2)],
      readsFrom: {activities},
    ).asyncMap(activities.mapFromRow);
  }

  Future<int> deleteChunk(int? var1) {
    return customUpdate(
      'DELETE FROM chunks WHERE id = ?1',
      variables: [Variable<int>(var1)],
      updates: {chunks},
      updateKind: UpdateKind.delete,
    );
  }

  Future<int> deleteActivity(int var1) {
    return customUpdate(
      'DELETE FROM activities WHERE chunkId = ?1',
      variables: [Variable<int>(var1)],
      updates: {activities},
      updateKind: UpdateKind.delete,
    );
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [chunks, activities];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'chunks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('activities', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $ChunksCreateCompanionBuilder =
    ChunksCompanion Function({
      Value<int?> id,
      required String name,
      required String type,
      Value<int> isActive,
      Value<int?> startHour,
      Value<int> startMinute,
      Value<int?> endHour,
      Value<int> endMinute,
      Value<String?> date,
      Value<String?> weekday,
    });
typedef $ChunksUpdateCompanionBuilder =
    ChunksCompanion Function({
      Value<int?> id,
      Value<String> name,
      Value<String> type,
      Value<int> isActive,
      Value<int?> startHour,
      Value<int> startMinute,
      Value<int?> endHour,
      Value<int> endMinute,
      Value<String?> date,
      Value<String?> weekday,
    });

final class $ChunksReferences extends BaseReferences<_$AppDb, Chunks, Chunk> {
  $ChunksReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Activities, List<Activity>> _activitiesRefsTable(
    _$AppDb db,
  ) => MultiTypedResultKey.fromTable(
    db.activities,
    aliasName: $_aliasNameGenerator(db.chunks.id, db.activities.chunkId),
  );

  $ActivitiesProcessedTableManager get activitiesRefs {
    final manager = $ActivitiesTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.chunkId.id.sqlEquals($_itemColumn<int>('id')));

    final cache = $_typedResult.readTableOrNull(_activitiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $ChunksFilterComposer extends Composer<_$AppDb, Chunks> {
  $ChunksFilterComposer({
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

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startHour => $composableBuilder(
    column: $table.startHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endHour => $composableBuilder(
    column: $table.endHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> activitiesRefs(
    Expression<bool> Function($ActivitiesFilterComposer f) f,
  ) {
    final $ActivitiesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.chunkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ActivitiesFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $ChunksOrderingComposer extends Composer<_$AppDb, Chunks> {
  $ChunksOrderingComposer({
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

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startHour => $composableBuilder(
    column: $table.startHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endHour => $composableBuilder(
    column: $table.endHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );
}

class $ChunksAnnotationComposer extends Composer<_$AppDb, Chunks> {
  $ChunksAnnotationComposer({
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

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get startHour =>
      $composableBuilder(column: $table.startHour, builder: (column) => column);

  GeneratedColumn<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endHour =>
      $composableBuilder(column: $table.endHour, builder: (column) => column);

  GeneratedColumn<int> get endMinute =>
      $composableBuilder(column: $table.endMinute, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  Expression<T> activitiesRefs<T extends Object>(
    Expression<T> Function($ActivitiesAnnotationComposer a) f,
  ) {
    final $ActivitiesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.chunkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ActivitiesAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $ChunksTableManager
    extends
        RootTableManager<
          _$AppDb,
          Chunks,
          Chunk,
          $ChunksFilterComposer,
          $ChunksOrderingComposer,
          $ChunksAnnotationComposer,
          $ChunksCreateCompanionBuilder,
          $ChunksUpdateCompanionBuilder,
          (Chunk, $ChunksReferences),
          Chunk,
          PrefetchHooks Function({bool activitiesRefs})
        > {
  $ChunksTableManager(_$AppDb db, Chunks table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ChunksFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ChunksOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ChunksAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int?> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<int?> startHour = const Value.absent(),
                Value<int> startMinute = const Value.absent(),
                Value<int?> endHour = const Value.absent(),
                Value<int> endMinute = const Value.absent(),
                Value<String?> date = const Value.absent(),
                Value<String?> weekday = const Value.absent(),
              }) => ChunksCompanion(
                id: id,
                name: name,
                type: type,
                isActive: isActive,
                startHour: startHour,
                startMinute: startMinute,
                endHour: endHour,
                endMinute: endMinute,
                date: date,
                weekday: weekday,
              ),
          createCompanionCallback:
              ({
                Value<int?> id = const Value.absent(),
                required String name,
                required String type,
                Value<int> isActive = const Value.absent(),
                Value<int?> startHour = const Value.absent(),
                Value<int> startMinute = const Value.absent(),
                Value<int?> endHour = const Value.absent(),
                Value<int> endMinute = const Value.absent(),
                Value<String?> date = const Value.absent(),
                Value<String?> weekday = const Value.absent(),
              }) => ChunksCompanion.insert(
                id: id,
                name: name,
                type: type,
                isActive: isActive,
                startHour: startHour,
                startMinute: startMinute,
                endHour: endHour,
                endMinute: endMinute,
                date: date,
                weekday: weekday,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), $ChunksReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({activitiesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (activitiesRefs) db.activities],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (activitiesRefs)
                    await $_getPrefetchedData<Chunk, Chunks, Activity>(
                      currentTable: table,
                      referencedTable: $ChunksReferences._activitiesRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $ChunksReferences(db, table, p0).activitiesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.chunkId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $ChunksProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      Chunks,
      Chunk,
      $ChunksFilterComposer,
      $ChunksOrderingComposer,
      $ChunksAnnotationComposer,
      $ChunksCreateCompanionBuilder,
      $ChunksUpdateCompanionBuilder,
      (Chunk, $ChunksReferences),
      Chunk,
      PrefetchHooks Function({bool activitiesRefs})
    >;
typedef $ActivitiesCreateCompanionBuilder =
    ActivitiesCompanion Function({
      Value<int?> id,
      required String description,
      required String type,
      Value<String?> date,
      Value<String?> weekday,
      Value<String?> startDate,
      Value<String?> endDate,
      Value<String?> startTime,
      Value<String?> endTime,
      Value<int> completed,
      required int chunkId,
    });
typedef $ActivitiesUpdateCompanionBuilder =
    ActivitiesCompanion Function({
      Value<int?> id,
      Value<String> description,
      Value<String> type,
      Value<String?> date,
      Value<String?> weekday,
      Value<String?> startDate,
      Value<String?> endDate,
      Value<String?> startTime,
      Value<String?> endTime,
      Value<int> completed,
      Value<int> chunkId,
    });

final class $ActivitiesReferences
    extends BaseReferences<_$AppDb, Activities, Activity> {
  $ActivitiesReferences(super.$_db, super.$_table, super.$_typedResult);

  static Chunks _chunkIdTable(_$AppDb db) => db.chunks.createAlias(
    $_aliasNameGenerator(db.activities.chunkId, db.chunks.id),
  );

  $ChunksProcessedTableManager get chunkId {
    final $_column = $_itemColumn<int>('chunkId')!;

    final manager = $ChunksTableManager(
      $_db,
      $_db.chunks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chunkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $ActivitiesFilterComposer extends Composer<_$AppDb, Activities> {
  $ActivitiesFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  $ChunksFilterComposer get chunkId {
    final $ChunksFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chunkId,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ChunksFilterComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ActivitiesOrderingComposer extends Composer<_$AppDb, Activities> {
  $ActivitiesOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  $ChunksOrderingComposer get chunkId {
    final $ChunksOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chunkId,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ChunksOrderingComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ActivitiesAnnotationComposer extends Composer<_$AppDb, Activities> {
  $ActivitiesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  $ChunksAnnotationComposer get chunkId {
    final $ChunksAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chunkId,
      referencedTable: $db.chunks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ChunksAnnotationComposer(
            $db: $db,
            $table: $db.chunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ActivitiesTableManager
    extends
        RootTableManager<
          _$AppDb,
          Activities,
          Activity,
          $ActivitiesFilterComposer,
          $ActivitiesOrderingComposer,
          $ActivitiesAnnotationComposer,
          $ActivitiesCreateCompanionBuilder,
          $ActivitiesUpdateCompanionBuilder,
          (Activity, $ActivitiesReferences),
          Activity,
          PrefetchHooks Function({bool chunkId})
        > {
  $ActivitiesTableManager(_$AppDb db, Activities table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ActivitiesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ActivitiesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ActivitiesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int?> id = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> date = const Value.absent(),
                Value<String?> weekday = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<int> completed = const Value.absent(),
                Value<int> chunkId = const Value.absent(),
              }) => ActivitiesCompanion(
                id: id,
                description: description,
                type: type,
                date: date,
                weekday: weekday,
                startDate: startDate,
                endDate: endDate,
                startTime: startTime,
                endTime: endTime,
                completed: completed,
                chunkId: chunkId,
              ),
          createCompanionCallback:
              ({
                Value<int?> id = const Value.absent(),
                required String description,
                required String type,
                Value<String?> date = const Value.absent(),
                Value<String?> weekday = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<int> completed = const Value.absent(),
                required int chunkId,
              }) => ActivitiesCompanion.insert(
                id: id,
                description: description,
                type: type,
                date: date,
                weekday: weekday,
                startDate: startDate,
                endDate: endDate,
                startTime: startTime,
                endTime: endTime,
                completed: completed,
                chunkId: chunkId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $ActivitiesReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({chunkId = false}) {
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
                    if (chunkId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chunkId,
                                referencedTable: $ActivitiesReferences
                                    ._chunkIdTable(db),
                                referencedColumn: $ActivitiesReferences
                                    ._chunkIdTable(db)
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

typedef $ActivitiesProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      Activities,
      Activity,
      $ActivitiesFilterComposer,
      $ActivitiesOrderingComposer,
      $ActivitiesAnnotationComposer,
      $ActivitiesCreateCompanionBuilder,
      $ActivitiesUpdateCompanionBuilder,
      (Activity, $ActivitiesReferences),
      Activity,
      PrefetchHooks Function({bool chunkId})
    >;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $ChunksTableManager get chunks => $ChunksTableManager(_db, _db.chunks);
  $ActivitiesTableManager get activities =>
      $ActivitiesTableManager(_db, _db.activities);
}
