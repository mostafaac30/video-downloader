import 'package:json_annotation/json_annotation.dart';

part 'video.g.dart';

@JsonSerializable()
class OfflineVideo {
  String path;
  String thumbnailPath;
  OfflineVideo({
    required this.path,
    required this.thumbnailPath,
  });

  factory OfflineVideo.fromJson(Map<String, dynamic> json) =>
      _$OfflineVideoFromJson(json);
  Map<String, dynamic> toJson() => _$OfflineVideoToJson(this);
}
