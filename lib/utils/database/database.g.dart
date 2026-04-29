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
    false,
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
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (frequency IN (\'onceoff\', \'daily\', \'weekly\', \'seasonal\'))',
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (category IN (\'admin\', \'exercise\', \'hobby\', \'learn\', \'research\', \'rest\', \'study\', \'sleep\', \'work\'))',
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _selectedDaysMeta = const VerificationMeta(
    'selectedDays',
  );
  late final GeneratedColumn<String> selectedDays = GeneratedColumn<String>(
    'selectedDays',
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
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
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
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    frequency,
    category,
    isActive,
    date,
    selectedDays,
    startDate,
    endDate,
    startHour,
    startMinute,
    endHour,
    endMinute,
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
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('isActive')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['isActive']!, _isActiveMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('selectedDays')) {
      context.handle(
        _selectedDaysMeta,
        selectedDays.isAcceptableOrUnknown(
          data['selectedDays']!,
          _selectedDaysMeta,
        ),
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
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}isActive'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      ),
      selectedDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selectedDays'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}startDate'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}endDate'],
      ),
      startHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}startHour'],
      ),
      startMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}startMinute'],
      ),
      endHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}endHour'],
      ),
      endMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}endMinute'],
      ),
    );
  }

  @override
  Chunks createAlias(String alias) {
    return Chunks(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'CHECK((frequency = \'onceoff\' AND date IS NOT NULL AND startHour IS NOT NULL AND endHour IS NOT NULL)OR(frequency = \'daily\' AND date IS NULL AND startHour IS NOT NULL AND endHour IS NOT NULL)OR(frequency = \'weekly\' AND startHour IS NOT NULL AND endHour IS NOT NULL AND selectedDays IS NOT NULL AND date IS NULL)OR(frequency = \'seasonal\' AND startHour IS NOT NULL AND endHour IS NOT NULL AND startDate IS NOT NULL AND endDate IS NOT NULL AND selectedDays IS NULL))',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class Chunk extends DataClass implements Insertable<Chunk> {
  final int id;
  final String name;
  final String frequency;
  final String category;
  final int isActive;
  final String? date;
  final String? selectedDays;
  final String? startDate;
  final String? endDate;
  final int? startHour;
  final int? startMinute;
  final int? endHour;
  final int? endMinute;
  const Chunk({
    required this.id,
    required this.name,
    required this.frequency,
    required this.category,
    required this.isActive,
    this.date,
    this.selectedDays,
    this.startDate,
    this.endDate,
    this.startHour,
    this.startMinute,
    this.endHour,
    this.endMinute,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['frequency'] = Variable<String>(frequency);
    map['category'] = Variable<String>(category);
    map['isActive'] = Variable<int>(isActive);
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<String>(date);
    }
    if (!nullToAbsent || selectedDays != null) {
      map['selectedDays'] = Variable<String>(selectedDays);
    }
    if (!nullToAbsent || startDate != null) {
      map['startDate'] = Variable<String>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['endDate'] = Variable<String>(endDate);
    }
    if (!nullToAbsent || startHour != null) {
      map['startHour'] = Variable<int>(startHour);
    }
    if (!nullToAbsent || startMinute != null) {
      map['startMinute'] = Variable<int>(startMinute);
    }
    if (!nullToAbsent || endHour != null) {
      map['endHour'] = Variable<int>(endHour);
    }
    if (!nullToAbsent || endMinute != null) {
      map['endMinute'] = Variable<int>(endMinute);
    }
    return map;
  }

  ChunksCompanion toCompanion(bool nullToAbsent) {
    return ChunksCompanion(
      id: Value(id),
      name: Value(name),
      frequency: Value(frequency),
      category: Value(category),
      isActive: Value(isActive),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      selectedDays: selectedDays == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedDays),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      startHour: startHour == null && nullToAbsent
          ? const Value.absent()
          : Value(startHour),
      startMinute: startMinute == null && nullToAbsent
          ? const Value.absent()
          : Value(startMinute),
      endHour: endHour == null && nullToAbsent
          ? const Value.absent()
          : Value(endHour),
      endMinute: endMinute == null && nullToAbsent
          ? const Value.absent()
          : Value(endMinute),
    );
  }

  factory Chunk.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chunk(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      frequency: serializer.fromJson<String>(json['frequency']),
      category: serializer.fromJson<String>(json['category']),
      isActive: serializer.fromJson<int>(json['isActive']),
      date: serializer.fromJson<String?>(json['date']),
      selectedDays: serializer.fromJson<String?>(json['selectedDays']),
      startDate: serializer.fromJson<String?>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      startHour: serializer.fromJson<int?>(json['startHour']),
      startMinute: serializer.fromJson<int?>(json['startMinute']),
      endHour: serializer.fromJson<int?>(json['endHour']),
      endMinute: serializer.fromJson<int?>(json['endMinute']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'frequency': serializer.toJson<String>(frequency),
      'category': serializer.toJson<String>(category),
      'isActive': serializer.toJson<int>(isActive),
      'date': serializer.toJson<String?>(date),
      'selectedDays': serializer.toJson<String?>(selectedDays),
      'startDate': serializer.toJson<String?>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'startHour': serializer.toJson<int?>(startHour),
      'startMinute': serializer.toJson<int?>(startMinute),
      'endHour': serializer.toJson<int?>(endHour),
      'endMinute': serializer.toJson<int?>(endMinute),
    };
  }

  Chunk copyWith({
    int? id,
    String? name,
    String? frequency,
    String? category,
    int? isActive,
    Value<String?> date = const Value.absent(),
    Value<String?> selectedDays = const Value.absent(),
    Value<String?> startDate = const Value.absent(),
    Value<String?> endDate = const Value.absent(),
    Value<int?> startHour = const Value.absent(),
    Value<int?> startMinute = const Value.absent(),
    Value<int?> endHour = const Value.absent(),
    Value<int?> endMinute = const Value.absent(),
  }) => Chunk(
    id: id ?? this.id,
    name: name ?? this.name,
    frequency: frequency ?? this.frequency,
    category: category ?? this.category,
    isActive: isActive ?? this.isActive,
    date: date.present ? date.value : this.date,
    selectedDays: selectedDays.present ? selectedDays.value : this.selectedDays,
    startDate: startDate.present ? startDate.value : this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    startHour: startHour.present ? startHour.value : this.startHour,
    startMinute: startMinute.present ? startMinute.value : this.startMinute,
    endHour: endHour.present ? endHour.value : this.endHour,
    endMinute: endMinute.present ? endMinute.value : this.endMinute,
  );
  Chunk copyWithCompanion(ChunksCompanion data) {
    return Chunk(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      category: data.category.present ? data.category.value : this.category,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      date: data.date.present ? data.date.value : this.date,
      selectedDays: data.selectedDays.present
          ? data.selectedDays.value
          : this.selectedDays,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      startHour: data.startHour.present ? data.startHour.value : this.startHour,
      startMinute: data.startMinute.present
          ? data.startMinute.value
          : this.startMinute,
      endHour: data.endHour.present ? data.endHour.value : this.endHour,
      endMinute: data.endMinute.present ? data.endMinute.value : this.endMinute,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chunk(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('frequency: $frequency, ')
          ..write('category: $category, ')
          ..write('isActive: $isActive, ')
          ..write('date: $date, ')
          ..write('selectedDays: $selectedDays, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('startHour: $startHour, ')
          ..write('startMinute: $startMinute, ')
          ..write('endHour: $endHour, ')
          ..write('endMinute: $endMinute')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    frequency,
    category,
    isActive,
    date,
    selectedDays,
    startDate,
    endDate,
    startHour,
    startMinute,
    endHour,
    endMinute,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chunk &&
          other.id == this.id &&
          other.name == this.name &&
          other.frequency == this.frequency &&
          other.category == this.category &&
          other.isActive == this.isActive &&
          other.date == this.date &&
          other.selectedDays == this.selectedDays &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.startHour == this.startHour &&
          other.startMinute == this.startMinute &&
          other.endHour == this.endHour &&
          other.endMinute == this.endMinute);
}

class ChunksCompanion extends UpdateCompanion<Chunk> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> frequency;
  final Value<String> category;
  final Value<int> isActive;
  final Value<String?> date;
  final Value<String?> selectedDays;
  final Value<String?> startDate;
  final Value<String?> endDate;
  final Value<int?> startHour;
  final Value<int?> startMinute;
  final Value<int?> endHour;
  final Value<int?> endMinute;
  const ChunksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.frequency = const Value.absent(),
    this.category = const Value.absent(),
    this.isActive = const Value.absent(),
    this.date = const Value.absent(),
    this.selectedDays = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.startHour = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endHour = const Value.absent(),
    this.endMinute = const Value.absent(),
  });
  ChunksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String frequency,
    required String category,
    this.isActive = const Value.absent(),
    this.date = const Value.absent(),
    this.selectedDays = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.startHour = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endHour = const Value.absent(),
    this.endMinute = const Value.absent(),
  }) : name = Value(name),
       frequency = Value(frequency),
       category = Value(category);
  static Insertable<Chunk> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? frequency,
    Expression<String>? category,
    Expression<int>? isActive,
    Expression<String>? date,
    Expression<String>? selectedDays,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<int>? startHour,
    Expression<int>? startMinute,
    Expression<int>? endHour,
    Expression<int>? endMinute,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (frequency != null) 'frequency': frequency,
      if (category != null) 'category': category,
      if (isActive != null) 'isActive': isActive,
      if (date != null) 'date': date,
      if (selectedDays != null) 'selectedDays': selectedDays,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      if (startHour != null) 'startHour': startHour,
      if (startMinute != null) 'startMinute': startMinute,
      if (endHour != null) 'endHour': endHour,
      if (endMinute != null) 'endMinute': endMinute,
    });
  }

  ChunksCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? frequency,
    Value<String>? category,
    Value<int>? isActive,
    Value<String?>? date,
    Value<String?>? selectedDays,
    Value<String?>? startDate,
    Value<String?>? endDate,
    Value<int?>? startHour,
    Value<int?>? startMinute,
    Value<int?>? endHour,
    Value<int?>? endMinute,
  }) {
    return ChunksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      date: date ?? this.date,
      selectedDays: selectedDays ?? this.selectedDays,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
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
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isActive.present) {
      map['isActive'] = Variable<int>(isActive.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (selectedDays.present) {
      map['selectedDays'] = Variable<String>(selectedDays.value);
    }
    if (startDate.present) {
      map['startDate'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['endDate'] = Variable<String>(endDate.value);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChunksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('frequency: $frequency, ')
          ..write('category: $category, ')
          ..write('isActive: $isActive, ')
          ..write('date: $date, ')
          ..write('selectedDays: $selectedDays, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('startHour: $startHour, ')
          ..write('startMinute: $startMinute, ')
          ..write('endHour: $endHour, ')
          ..write('endMinute: $endMinute')
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
    false,
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
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (frequency IN (\'onceoff\', \'daily\', \'weekly\', \'seasonal\'))',
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
  static const VerificationMeta _selectedDaysMeta = const VerificationMeta(
    'selectedDays',
  );
  late final GeneratedColumn<String> selectedDays = GeneratedColumn<String>(
    'selectedDays',
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
    frequency,
    date,
    selectedDays,
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
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('selectedDays')) {
      context.handle(
        _selectedDaysMeta,
        selectedDays.isAcceptableOrUnknown(
          data['selectedDays']!,
          _selectedDaysMeta,
        ),
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
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      ),
      selectedDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selectedDays'],
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
    'CHECK((frequency = \'onceoff\' AND date IS NOT NULL AND selectedDays IS NULL AND startDate IS NULL AND endDate IS NULL)OR(frequency = \'daily\' AND date IS NULL AND selectedDays IS NULL AND startDate IS NULL AND endDate IS NULL)OR(frequency = \'weekly\' AND date IS NULL AND selectedDays IS NOT NULL AND startDate IS NULL AND endDate IS NULL)OR(frequency = \'seasonal\' AND date IS NULL AND selectedDays IS NULL AND startDate IS NOT NULL AND endDate IS NOT NULL AND startDate <= endDate))',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class Activity extends DataClass implements Insertable<Activity> {
  final int id;
  final String description;
  final String frequency;
  final String? date;
  final String? selectedDays;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final int completed;
  final int chunkId;
  const Activity({
    required this.id,
    required this.description,
    required this.frequency,
    this.date,
    this.selectedDays,
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
    map['id'] = Variable<int>(id);
    map['description'] = Variable<String>(description);
    map['frequency'] = Variable<String>(frequency);
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<String>(date);
    }
    if (!nullToAbsent || selectedDays != null) {
      map['selectedDays'] = Variable<String>(selectedDays);
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
      id: Value(id),
      description: Value(description),
      frequency: Value(frequency),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      selectedDays: selectedDays == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedDays),
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
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
      frequency: serializer.fromJson<String>(json['frequency']),
      date: serializer.fromJson<String?>(json['date']),
      selectedDays: serializer.fromJson<String?>(json['selectedDays']),
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
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
      'frequency': serializer.toJson<String>(frequency),
      'date': serializer.toJson<String?>(date),
      'selectedDays': serializer.toJson<String?>(selectedDays),
      'startDate': serializer.toJson<String?>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'startTime': serializer.toJson<String?>(startTime),
      'endTime': serializer.toJson<String?>(endTime),
      'completed': serializer.toJson<int>(completed),
      'chunkId': serializer.toJson<int>(chunkId),
    };
  }

  Activity copyWith({
    int? id,
    String? description,
    String? frequency,
    Value<String?> date = const Value.absent(),
    Value<String?> selectedDays = const Value.absent(),
    Value<String?> startDate = const Value.absent(),
    Value<String?> endDate = const Value.absent(),
    Value<String?> startTime = const Value.absent(),
    Value<String?> endTime = const Value.absent(),
    int? completed,
    int? chunkId,
  }) => Activity(
    id: id ?? this.id,
    description: description ?? this.description,
    frequency: frequency ?? this.frequency,
    date: date.present ? date.value : this.date,
    selectedDays: selectedDays.present ? selectedDays.value : this.selectedDays,
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
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      date: data.date.present ? data.date.value : this.date,
      selectedDays: data.selectedDays.present
          ? data.selectedDays.value
          : this.selectedDays,
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
          ..write('frequency: $frequency, ')
          ..write('date: $date, ')
          ..write('selectedDays: $selectedDays, ')
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
    frequency,
    date,
    selectedDays,
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
          other.frequency == this.frequency &&
          other.date == this.date &&
          other.selectedDays == this.selectedDays &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.completed == this.completed &&
          other.chunkId == this.chunkId);
}

class ActivitiesCompanion extends UpdateCompanion<Activity> {
  final Value<int> id;
  final Value<String> description;
  final Value<String> frequency;
  final Value<String?> date;
  final Value<String?> selectedDays;
  final Value<String?> startDate;
  final Value<String?> endDate;
  final Value<String?> startTime;
  final Value<String?> endTime;
  final Value<int> completed;
  final Value<int> chunkId;
  const ActivitiesCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.frequency = const Value.absent(),
    this.date = const Value.absent(),
    this.selectedDays = const Value.absent(),
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
    required String frequency,
    this.date = const Value.absent(),
    this.selectedDays = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.completed = const Value.absent(),
    required int chunkId,
  }) : description = Value(description),
       frequency = Value(frequency),
       chunkId = Value(chunkId);
  static Insertable<Activity> custom({
    Expression<int>? id,
    Expression<String>? description,
    Expression<String>? frequency,
    Expression<String>? date,
    Expression<String>? selectedDays,
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
      if (frequency != null) 'frequency': frequency,
      if (date != null) 'date': date,
      if (selectedDays != null) 'selectedDays': selectedDays,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
      if (completed != null) 'completed': completed,
      if (chunkId != null) 'chunkId': chunkId,
    });
  }

  ActivitiesCompanion copyWith({
    Value<int>? id,
    Value<String>? description,
    Value<String>? frequency,
    Value<String?>? date,
    Value<String?>? selectedDays,
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
      frequency: frequency ?? this.frequency,
      date: date ?? this.date,
      selectedDays: selectedDays ?? this.selectedDays,
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
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (selectedDays.present) {
      map['selectedDays'] = Variable<String>(selectedDays.value);
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
          ..write('frequency: $frequency, ')
          ..write('date: $date, ')
          ..write('selectedDays: $selectedDays, ')
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

  Selectable<Chunk> getTodaysChunks(String var1) {
    return customSelect(
      'SELECT * FROM chunks WHERE(frequency = \'daily\' OR(frequency = \'onceoff\' AND date = date(?1))OR(frequency = \'seasonal\' AND date(?1) BETWEEN startDate AND endDate)OR(frequency = \'weekly\' AND selectedDays LIKE \'%\' || CASE CAST(strftime(\'%w\', ?1) AS INTEGER) WHEN 0 THEN \'Sunday\' WHEN 1 THEN \'Monday\' WHEN 2 THEN \'Tuesday\' WHEN 3 THEN \'Wednesday\' WHEN 4 THEN \'Thursday\' WHEN 5 THEN \'Friday\' ELSE \'Saturday\' END || \'%\'))',
      variables: [Variable<String>(var1)],
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
      'SELECT * FROM activities WHERE chunkId = ?1 AND(frequency = \'daily\' OR(frequency = \'onceoff\' AND date = date(?2))OR(frequency = \'seasonal\' AND date(?2) BETWEEN date(startDate) AND date(endDate))OR(frequency = \'weekly\' AND selectedDays LIKE \'%\' || CASE CAST(strftime(\'%w\', ?2) AS INTEGER) WHEN 0 THEN \'Sunday\' WHEN 1 THEN \'Monday\' WHEN 2 THEN \'Tuesday\' WHEN 3 THEN \'Wednesday\' WHEN 4 THEN \'Thursday\' WHEN 5 THEN \'Friday\' ELSE \'Saturday\' END || \'%\'))',
      variables: [Variable<int>(var1), Variable<String>(var2)],
      readsFrom: {activities},
    ).asyncMap(activities.mapFromRow);
  }

  Future<int> deleteChunk(int var1) {
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
      Value<int> id,
      required String name,
      required String frequency,
      required String category,
      Value<int> isActive,
      Value<String?> date,
      Value<String?> selectedDays,
      Value<String?> startDate,
      Value<String?> endDate,
      Value<int?> startHour,
      Value<int?> startMinute,
      Value<int?> endHour,
      Value<int?> endMinute,
    });
typedef $ChunksUpdateCompanionBuilder =
    ChunksCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> frequency,
      Value<String> category,
      Value<int> isActive,
      Value<String?> date,
      Value<String?> selectedDays,
      Value<String?> startDate,
      Value<String?> endDate,
      Value<int?> startHour,
      Value<int?> startMinute,
      Value<int?> endHour,
      Value<int?> endMinute,
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
    ).filter((f) => f.chunkId.id.sqlEquals($_itemColumn<int>('id')!));

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

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedDays => $composableBuilder(
    column: $table.selectedDays,
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

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedDays => $composableBuilder(
    column: $table.selectedDays,
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

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get selectedDays => $composableBuilder(
    column: $table.selectedDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

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
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<String?> date = const Value.absent(),
                Value<String?> selectedDays = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<int?> startHour = const Value.absent(),
                Value<int?> startMinute = const Value.absent(),
                Value<int?> endHour = const Value.absent(),
                Value<int?> endMinute = const Value.absent(),
              }) => ChunksCompanion(
                id: id,
                name: name,
                frequency: frequency,
                category: category,
                isActive: isActive,
                date: date,
                selectedDays: selectedDays,
                startDate: startDate,
                endDate: endDate,
                startHour: startHour,
                startMinute: startMinute,
                endHour: endHour,
                endMinute: endMinute,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String frequency,
                required String category,
                Value<int> isActive = const Value.absent(),
                Value<String?> date = const Value.absent(),
                Value<String?> selectedDays = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<int?> startHour = const Value.absent(),
                Value<int?> startMinute = const Value.absent(),
                Value<int?> endHour = const Value.absent(),
                Value<int?> endMinute = const Value.absent(),
              }) => ChunksCompanion.insert(
                id: id,
                name: name,
                frequency: frequency,
                category: category,
                isActive: isActive,
                date: date,
                selectedDays: selectedDays,
                startDate: startDate,
                endDate: endDate,
                startHour: startHour,
                startMinute: startMinute,
                endHour: endHour,
                endMinute: endMinute,
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
      Value<int> id,
      required String description,
      required String frequency,
      Value<String?> date,
      Value<String?> selectedDays,
      Value<String?> startDate,
      Value<String?> endDate,
      Value<String?> startTime,
      Value<String?> endTime,
      Value<int> completed,
      required int chunkId,
    });
typedef $ActivitiesUpdateCompanionBuilder =
    ActivitiesCompanion Function({
      Value<int> id,
      Value<String> description,
      Value<String> frequency,
      Value<String?> date,
      Value<String?> selectedDays,
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

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedDays => $composableBuilder(
    column: $table.selectedDays,
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

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedDays => $composableBuilder(
    column: $table.selectedDays,
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

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get selectedDays => $composableBuilder(
    column: $table.selectedDays,
    builder: (column) => column,
  );

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
                Value<int> id = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<String?> date = const Value.absent(),
                Value<String?> selectedDays = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<int> completed = const Value.absent(),
                Value<int> chunkId = const Value.absent(),
              }) => ActivitiesCompanion(
                id: id,
                description: description,
                frequency: frequency,
                date: date,
                selectedDays: selectedDays,
                startDate: startDate,
                endDate: endDate,
                startTime: startTime,
                endTime: endTime,
                completed: completed,
                chunkId: chunkId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String description,
                required String frequency,
                Value<String?> date = const Value.absent(),
                Value<String?> selectedDays = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<int> completed = const Value.absent(),
                required int chunkId,
              }) => ActivitiesCompanion.insert(
                id: id,
                description: description,
                frequency: frequency,
                date: date,
                selectedDays: selectedDays,
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
