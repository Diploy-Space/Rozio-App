class WholesaleMetaSeoInfo {
  String metaIndex;
  String metaNoFollow;
  String metaNoImageIndex;
  String metaNoArchive;
  String metaNoSnippet;
  String metaMaxSnippet;
  String? metaMaxSnippetValue;
  String metaMaxVideoPreview;
  String? metaMaxVideoPreviewValue;
  String metaMaxImagePreview;
  String metaMaxImagePreviewValue;

  WholesaleMetaSeoInfo({
    this.metaIndex = 'index',
    this.metaNoFollow = 'follow',
    this.metaNoImageIndex = '0',
    this.metaNoArchive = '0',
    this.metaNoSnippet = '0',
    this.metaMaxSnippet = '0',
    this.metaMaxSnippetValue,
    this.metaMaxVideoPreview = '0',
    this.metaMaxVideoPreviewValue,
    this.metaMaxImagePreview = '0',
    this.metaMaxImagePreviewValue = 'large',
  });
}
