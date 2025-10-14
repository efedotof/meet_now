import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_content_type.freezed.dart';
part 'message_content_type.g.dart';

@freezed
abstract class MessageContentType with _$MessageContentType {
  const factory MessageContentType({
    required String id,
    @JsonKey(name: 'type_name') required String typeName,
  }) = _MessageContentType;

  factory MessageContentType.fromJson(Map<String, dynamic> json) =>
      _$MessageContentTypeFromJson(json);
}

enum ContentType {
  text('text'),
  image('image'),
  video('video'),
  sticker('sticker'),
  file('file');

  final String value;
  const ContentType(this.value);

  factory ContentType.fromString(String value) {
    return ContentType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ContentType.text,
    );
  }

  @override
  String toString() => value;
}
