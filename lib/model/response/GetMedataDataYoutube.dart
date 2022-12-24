import 'package:json_annotation/json_annotation.dart';

part 'GetMedataDataYoutube.g.dart';

@JsonSerializable()
class GetMedataDataYoutube {
  String title;
  String result;
  String quality;
  String size;
  String thumbb;

  GetMedataDataYoutube({
    required this.title,
    required this.result,
    required this.quality,
    required this.size,
    required this.thumbb,
  });

  Map<String, dynamic> toJson() => _$GetMedataDataYoutubeToJson(this);

  static GetMedataDataYoutube fromJson(Map<String, dynamic> json) =>
      _$GetMedataDataYoutubeFromJson(json);
}
