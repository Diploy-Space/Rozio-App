import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/add_product_model.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/image_model.dart';

abstract class AddProductServiceInterface {
  Future<dynamic> getAttributeList(String languageCode);
  Future<dynamic> getEditProduct(int? id);
  Future<dynamic> getCategoryList(String languageCode);
  Future<dynamic> getSubCategoryList();
  Future<dynamic> getSubSubCategoryList();
  Future<dynamic> addImage(BuildContext context, ImageModel imageForUpload, bool colorActivate);
   Future<dynamic> addProductV6({
    required Product product,
    required AddProductModel addProduct,
    required Map<String, dynamic> attributes,
    required bool isActiveColor,
    required List<ColorImage> colorImageObject,
    required List<String?> tags,
    XFile? thumbnail,
    XFile? metaImage,
    List<XFile> galleryImages = const [],
    File? digitalFileReady,
    DigitalVariationModel? digitalVariationModel,
    bool isDigitalVariationActive = false,
  });
  Future<dynamic> updateProductV6({
    required int productId,
    required Product product,
    required AddProductModel addProduct,
    required Map<String, dynamic> attributes,
    required bool isActiveColor,
    required List<String?> tags,
    XFile? thumbnail,
    XFile? metaImage,
    List<XFile> galleryImages = const [],
    Map<String, XFile> colorImageFiles = const {},
    List<String> removedImages = const [],
    File? digitalFileReady,
    DigitalVariationModel? digitalVariationModel,
    bool isDigitalVariationActive = false,
  });
  Future<dynamic> uploadDigitalProduct(File? filePath, String token);
  Future<dynamic> updateProductQuantity(int? productId,int currentStock, List <Variation> variation);
  Future<dynamic> deleteProductImage(String id, String name, String? color );
  Future<dynamic> getProductImage(String id );
  Future<dynamic> deleteDigitalVariationFile(int? productId, String variantKey);
  Future<dynamic> deleteProductPreview(int? id);
  Future<dynamic> getDigitalAuthor();
  Future<dynamic> getPublishingHouse();
  Future<dynamic> getTaxVatSetup({String businessModule = 'retail'});
  Future<dynamic> getTaxVatRateList({String businessModule = 'retail'});
}