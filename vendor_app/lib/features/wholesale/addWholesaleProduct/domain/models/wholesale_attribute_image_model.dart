import 'package:image_picker/image_picker.dart';

class WholesaleAttributeImageModel {
  final String type;
  final int? attributeId;
  final String value;

  final List<String> existingImages;

  final List<XFile> images;

  final List<int> galleryIndexes;

  WholesaleAttributeImageModel({
    required this.type,
    this.attributeId,
    required this.value,
    this.existingImages = const [],
    required this.images,
    required this.galleryIndexes,
  });
}
