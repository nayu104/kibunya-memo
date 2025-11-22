// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Memo _$MemoFromJson(Map<String, dynamic> json) {
  return _Memo.fromJson(json);
}

/// @nodoc
mixin _$Memo {
  String get id => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  Mood get mood => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Memo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Memo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemoCopyWith<Memo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemoCopyWith<$Res> {
  factory $MemoCopyWith(Memo value, $Res Function(Memo) then) =
      _$MemoCopyWithImpl<$Res, Memo>;
  @useResult
  $Res call({
    String id,
    String body,
    Mood mood,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$MemoCopyWithImpl<$Res, $Val extends Memo>
    implements $MemoCopyWith<$Res> {
  _$MemoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Memo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? body = null,
    Object? mood = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            mood: null == mood
                ? _value.mood
                : mood // ignore: cast_nullable_to_non_nullable
                      as Mood,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MemoImplCopyWith<$Res> implements $MemoCopyWith<$Res> {
  factory _$$MemoImplCopyWith(
    _$MemoImpl value,
    $Res Function(_$MemoImpl) then,
  ) = __$$MemoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String body,
    Mood mood,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$MemoImplCopyWithImpl<$Res>
    extends _$MemoCopyWithImpl<$Res, _$MemoImpl>
    implements _$$MemoImplCopyWith<$Res> {
  __$$MemoImplCopyWithImpl(_$MemoImpl _value, $Res Function(_$MemoImpl) _then)
    : super(_value, _then);

  /// Create a copy of Memo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? body = null,
    Object? mood = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$MemoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        mood: null == mood
            ? _value.mood
            : mood // ignore: cast_nullable_to_non_nullable
                  as Mood,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemoImpl extends _Memo {
  const _$MemoImpl({
    required this.id,
    this.body = '',
    this.mood = Mood.calm,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();

  factory _$MemoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String body;
  @override
  @JsonKey()
  final Mood mood;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Memo(id: $id, body: $body, mood: $mood, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.mood, mood) || other.mood == mood) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, body, mood, createdAt, updatedAt);

  /// Create a copy of Memo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemoImplCopyWith<_$MemoImpl> get copyWith =>
      __$$MemoImplCopyWithImpl<_$MemoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemoImplToJson(this);
  }
}

abstract class _Memo extends Memo {
  const factory _Memo({
    required final String id,
    final String body,
    final Mood mood,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$MemoImpl;
  const _Memo._() : super._();

  factory _Memo.fromJson(Map<String, dynamic> json) = _$MemoImpl.fromJson;

  @override
  String get id;
  @override
  String get body;
  @override
  Mood get mood;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Memo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemoImplCopyWith<_$MemoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
