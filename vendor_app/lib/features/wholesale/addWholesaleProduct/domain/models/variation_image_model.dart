import 'package:image_picker/image_picker.dart';

class VariationImageModel {
  final XFile? file;

  final String? storedKey;

  final String? storedUrl;

  bool includeInAdditionalImages;

  VariationImageModel({
    this.file,
    this.storedKey,
    this.storedUrl,
    this.includeInAdditionalImages = false,
  });

  bool get isStored => storedKey != null;
}
