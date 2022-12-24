import 'package:json_annotation/json_annotation.dart';

import 'GetMedataDataYoutube.dart';
import 'audio_data.dart';
import 'mp4_data.dart';

part 'GetDataYoutubeByDataType.g.dart';

@JsonSerializable()
class GetDataYoutubeByDataType {
  @JsonKey(name: 'creator')
  String creator;
  @JsonKey(name: 'pilihan_type')
  String pilihan_type;
  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'thumbnail')
  String thumbnail;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'mp4')
  Mp4Data mp4Data;
  @JsonKey(name: 'audio')
  AudioData audioData;


  GetDataYoutubeByDataType({
    required this.creator,
    required this.pilihan_type,
    required this.id,
    required this.thumbnail,
    required this.title,
    required this.mp4Data,

    required this.audioData,

  });

  Map<String, dynamic> toJson() => _$GetDataYoutubeByDataTypeToJson(this);

  static GetDataYoutubeByDataType fromJson(Map<String, dynamic> json) =>
      _$GetDataYoutubeByDataTypeFromJson(json);
}
