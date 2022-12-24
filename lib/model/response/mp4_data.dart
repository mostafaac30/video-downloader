import 'package:json_annotation/json_annotation.dart';

part 'mp4_data.g.dart';

@JsonSerializable()
class Mp4Data {
  @JsonKey(name: 'download')
  String download;
  @JsonKey(name: 'size')
  String size;
  @JsonKey(name: 'type_download')
  String type_download;

  Mp4Data({
    required this.download,
    required this.size,
    required this.type_download,
  });

  factory Mp4Data.fromJson(Map<String, dynamic> json) =>
      _$Mp4DataFromJson(json);
  Map<String, dynamic> toJson() => _$Mp4DataToJson(this);
}
