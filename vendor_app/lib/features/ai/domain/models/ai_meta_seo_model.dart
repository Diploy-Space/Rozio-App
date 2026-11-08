import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';

class AiMetaSEOModel {
  String? message;
  Data? data;
  int? remainingCount;

  AiMetaSEOModel({this.message, this.data, this.remainingCount});

  AiMetaSEOModel.fromJson(dynamic json) {
    final Map content = ApiEnvelope.content(json);

    message = ApiEnvelope.message(json);
    remainingCount = ApiEnvelope.remainingCount(json);

    final dynamic payload = content['data'];
    data = payload is Map ? Data.fromJson(Map<String, dynamic>.from(payload)) : null;
  }
}

class Data {
  String? metaTitle;
  String? metaDescription;
  String? metaIndex;
  int? metaNoFollow;
  int? metaNoImageIndex;
  int? metaNoArchive;
  int? metaNoSnippet;
  int? metaMaxSnippet;
  int? metaMaxSnippetValue;
  int? metaMaxVideoPreview;
  int? metaMaxVideoPreviewValue;
  int? metaMaxImagePreview;
  String? metaMaxImagePreviewValue;

  Data(
      {this.metaTitle,
        this.metaDescription,
        this.metaIndex,
        this.metaNoFollow,
        this.metaNoImageIndex,
        this.metaNoArchive,
        this.metaNoSnippet,
        this.metaMaxSnippet,
        this.metaMaxSnippetValue,
        this.metaMaxVideoPreview,
        this.metaMaxVideoPreviewValue,
        this.metaMaxImagePreview,
        this.metaMaxImagePreviewValue});

  Data.fromJson(Map<String, dynamic> json) {
    metaTitle = json['meta_title']?.toString();
    metaDescription = json['meta_description']?.toString();
    metaIndex = json['meta_index']?.toString();
    metaNoFollow = int.tryParse(json['meta_no_follow']?.toString() ?? '');
    metaNoImageIndex = int.tryParse(json['meta_no_image_index']?.toString() ?? '');
    metaNoArchive = int.tryParse(json['meta_no_archive']?.toString() ?? '');
    metaNoSnippet = int.tryParse(json['meta_no_snippet']?.toString() ?? '');
    metaMaxSnippet = int.tryParse(json['meta_max_snippet']?.toString() ?? '');
    metaMaxSnippetValue = int.tryParse(json['meta_max_snippet_value']?.toString() ?? '');
    metaMaxVideoPreview = int.tryParse(json['meta_max_video_preview']?.toString() ?? '');
    metaMaxVideoPreviewValue = int.tryParse(json['meta_max_video_preview_value']?.toString() ?? '');
    metaMaxImagePreview = int.tryParse(json['meta_max_image_preview']?.toString() ?? '');
    metaMaxImagePreviewValue = json['meta_max_image_preview_value']?.toString();
  }
}
