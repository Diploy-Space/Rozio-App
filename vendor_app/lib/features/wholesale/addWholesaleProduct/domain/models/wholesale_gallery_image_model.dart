import 'package:image_picker/image_picker.dart';

class WholesaleGalleryImage {
  final XFile? file;

  final String? storedKey;

  final String? storedUrl;

  final int index;

  final int? attributeId;
  final String? value;

  WholesaleGalleryImage({
    this.file,
    this.storedKey,
    this.storedUrl,
    required this.index,
    this.attributeId,
    this.value,
  });

  bool get isFromVariation => attributeId != null;

  bool get isStored => storedKey != null;
}
