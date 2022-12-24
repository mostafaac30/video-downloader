// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetDataYoutubeByDataType.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDataYoutubeByDataType _$GetDataYoutubeByDataTypeFromJson(
        Map<String, dynamic> json) =>
    GetDataYoutubeByDataType(
      creator: json['creator'] as String,
      pilihan_type: json['pilihan_type'] as String,
      id: json['id'] as String,
      thumbnail: json['thumbnail'] as String,
      title: json['title'] as String,
      mp4Data: Mp4Data.fromJson(json['mp4'] as Map<String, dynamic>),
      audioData: AudioData.fromJson(json['audio'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetDataYoutubeByDataTypeToJson(
        GetDataYoutubeByDataType instance) =>
    <String, dynamic>{
      'creator': instance.creator,
      'pilihan_type': instance.pilihan_type,
      'id': instance.id,
      'thumbnail': instance.thumbnail,
      'title': instance.title,
      'mp4': instance.mp4Data,
      'audio': instance.audioData,
    };
