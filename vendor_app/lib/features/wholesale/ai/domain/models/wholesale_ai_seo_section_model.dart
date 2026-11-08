class WholesaleAiSeoSectionModel {
  final String? metaTitle;
  final String? metaDescription;

  final String? metaIndex;

  final bool? metaNoFollow;
  final bool? metaNoImageIndex;
  final bool? metaNoArchive;
  final bool? metaNoSnippet;

  final bool? metaMaxSnippet;
  final int? metaMaxSnippetValue;
  final bool? metaMaxVideoPreview;
  final int? metaMaxVideoPreviewValue;
  final bool? metaMaxImagePreview;
  final String? metaMaxImagePreviewValue;

  final int? remainingCount;

  WholesaleAiSeoSectionModel({
    this.metaTitle,
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
    this.metaMaxImagePreviewValue,
    this.remainingCount,
  });

  factory WholesaleAiSeoSectionModel.fromJson(Map<String, dynamic> json) {
    final dynamic content = json['content'];
    if (content is! Map<String, dynamic>) {
      return WholesaleAiSeoSectionModel();
    }

    final dynamic data = content['data'];
    if (data is! Map<String, dynamic>) {
      return WholesaleAiSeoSectionModel(
        remainingCount: int.tryParse(content['remaining_count']?.toString() ?? ''),
      );
    }

    return WholesaleAiSeoSectionModel(
      metaTitle: data['meta_title']?.toString(),
      metaDescription: data['meta_description']?.toString(),
      metaIndex: data['meta_index']?.toString(),
      metaNoFollow: _toBool(data['meta_no_follow']),
      metaNoImageIndex: _toBool(data['meta_no_image_index']),
      metaNoArchive: _toBool(data['meta_no_archive']),
      metaNoSnippet: _toBool(data['meta_no_snippet']),
      metaMaxSnippet: _toBool(data['meta_max_snippet']),
      metaMaxSnippetValue: int.tryParse(data['meta_max_snippet_value']?.toString() ?? ''),
      metaMaxVideoPreview: _toBool(data['meta_max_video_preview']),
      metaMaxVideoPreviewValue: int.tryParse(data['meta_max_video_preview_value']?.toString() ?? ''),
      metaMaxImagePreview: _toBool(data['meta_max_image_preview']),
      metaMaxImagePreviewValue: data['meta_max_image_preview_value']?.toString(),
      remainingCount: int.tryParse(content['remaining_count']?.toString() ?? ''),
    );
  }

  static bool? _toBool(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is bool) {
      return value;
    }
    return value.toString() == '1' || value.toString().toLowerCase() == 'true';
  }
}
