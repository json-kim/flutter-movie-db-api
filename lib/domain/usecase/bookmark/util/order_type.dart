import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_type.freezed.dart';

@freezed
class OrderType with _$OrderType {
  const factory OrderType.date(bool asc) = Date;
  const factory OrderType.rating(bool asc) = Rating;
  const factory OrderType.title(bool asc) = Title;
}
