import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration.freezed.dart';

@freezed
abstract class Registration with _$Registration {
  factory Registration({
    required String username,
    required String email,
    required String firstname,
    required String subname,
    required String description,
    required String city,
    required int age,
    required List<String> purposes,
    required List<String> interests,
    required bool isSearchable,
    required String password,
    required String floor,
  }) = _Registration;
}
