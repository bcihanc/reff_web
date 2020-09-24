// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'Unions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$QuestionExistsStateTearOff {
  const _$QuestionExistsStateTearOff();

// ignore: unused_element
  _Exists exsist() {
    return const _Exists();
  }

// ignore: unused_element
  _NotExists notExsist() {
    return const _NotExists();
  }
}

/// @nodoc
// ignore: unused_element
const $QuestionExistsState = _$QuestionExistsStateTearOff();

/// @nodoc
mixin _$QuestionExistsState {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result exsist(),
    @required Result notExsist(),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result exsist(),
    Result notExsist(),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result exsist(_Exists value),
    @required Result notExsist(_NotExists value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result exsist(_Exists value),
    Result notExsist(_NotExists value),
    @required Result orElse(),
  });
}

/// @nodoc
abstract class $QuestionExistsStateCopyWith<$Res> {
  factory $QuestionExistsStateCopyWith(
          QuestionExistsState value, $Res Function(QuestionExistsState) then) =
      _$QuestionExistsStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$QuestionExistsStateCopyWithImpl<$Res>
    implements $QuestionExistsStateCopyWith<$Res> {
  _$QuestionExistsStateCopyWithImpl(this._value, this._then);

  final QuestionExistsState _value;
  // ignore: unused_field
  final $Res Function(QuestionExistsState) _then;
}

/// @nodoc
abstract class _$ExistsCopyWith<$Res> {
  factory _$ExistsCopyWith(_Exists value, $Res Function(_Exists) then) =
      __$ExistsCopyWithImpl<$Res>;
}

/// @nodoc
class __$ExistsCopyWithImpl<$Res>
    extends _$QuestionExistsStateCopyWithImpl<$Res>
    implements _$ExistsCopyWith<$Res> {
  __$ExistsCopyWithImpl(_Exists _value, $Res Function(_Exists) _then)
      : super(_value, (v) => _then(v as _Exists));

  @override
  _Exists get _value => super._value as _Exists;
}

/// @nodoc
class _$_Exists implements _Exists {
  const _$_Exists();

  @override
  String toString() {
    return 'QuestionExistsState.exsist()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Exists);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result exsist(),
    @required Result notExsist(),
  }) {
    assert(exsist != null);
    assert(notExsist != null);
    return exsist();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result exsist(),
    Result notExsist(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (exsist != null) {
      return exsist();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result exsist(_Exists value),
    @required Result notExsist(_NotExists value),
  }) {
    assert(exsist != null);
    assert(notExsist != null);
    return exsist(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result exsist(_Exists value),
    Result notExsist(_NotExists value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (exsist != null) {
      return exsist(this);
    }
    return orElse();
  }
}

abstract class _Exists implements QuestionExistsState {
  const factory _Exists() = _$_Exists;
}

/// @nodoc
abstract class _$NotExistsCopyWith<$Res> {
  factory _$NotExistsCopyWith(
          _NotExists value, $Res Function(_NotExists) then) =
      __$NotExistsCopyWithImpl<$Res>;
}

/// @nodoc
class __$NotExistsCopyWithImpl<$Res>
    extends _$QuestionExistsStateCopyWithImpl<$Res>
    implements _$NotExistsCopyWith<$Res> {
  __$NotExistsCopyWithImpl(_NotExists _value, $Res Function(_NotExists) _then)
      : super(_value, (v) => _then(v as _NotExists));

  @override
  _NotExists get _value => super._value as _NotExists;
}

/// @nodoc
class _$_NotExists implements _NotExists {
  const _$_NotExists();

  @override
  String toString() {
    return 'QuestionExistsState.notExsist()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _NotExists);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result exsist(),
    @required Result notExsist(),
  }) {
    assert(exsist != null);
    assert(notExsist != null);
    return notExsist();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result exsist(),
    Result notExsist(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (notExsist != null) {
      return notExsist();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result exsist(_Exists value),
    @required Result notExsist(_NotExists value),
  }) {
    assert(exsist != null);
    assert(notExsist != null);
    return notExsist(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result exsist(_Exists value),
    Result notExsist(_NotExists value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (notExsist != null) {
      return notExsist(this);
    }
    return orElse();
  }
}

abstract class _NotExists implements QuestionExistsState {
  const factory _NotExists() = _$_NotExists;
}
