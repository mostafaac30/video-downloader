import 'package:json_annotation/json_annotation.dart';

part 'audio_data.g.dart';

@JsonSerializable()
class AudioData {
  @JsonKey(name: 'audio')
  String audio;
  @JsonKey(name: 'size')
  String size;

  AudioData({
    required this.audio,
    required this.size,
  });

  factory AudioData.fromJson(Map<String, dynamic> json) =>
      _$AudioDataFromJson(json);
  Map<String, dynamic> toJson() => _$AudioDataToJson(this);
}
