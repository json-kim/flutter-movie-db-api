import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_edit_state.freezed.dart';

@freezed
class ReviewEditState with _$ReviewEditState {
  const factory ReviewEditState({
    @Default('') String content,
    required DateTime date,
    @Default(1) double rating,
    @Default(true) bool isEditMode,
    @Default(false) bool isLoading,
  }) = _ReviewEditState;
}
