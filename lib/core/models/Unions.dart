import 'package:freezed_annotation/freezed_annotation.dart';

part 'Unions.freezed.dart';

@freezed
abstract class QuestionExistsState with _$QuestionExistsState {
  const factory QuestionExistsState.exsist() = _Exists;
  const factory QuestionExistsState.notExsist() = _NotExists;
}
