
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/add_product_model.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/image_model.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class AddProductRepositoryInterface implements RepositoryInterface{
  Future<ApiResponse> getAttributeList(String languageCode);

  Future<ApiResponse> getEditProduct(int? id);
  Future<ApiResponse> getCategoryList(String languageCode);
  Future<ApiResponse> getSubCategoryList();
  Future<ApiResponse> getSubSubCategoryList();
  Future<ApiResponse> addImage(BuildContext context, ImageModel imageForUpload, bool colorActivate);
   Future<ApiResponse> addProductV6({
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
  Future<ApiResponse> updateProductV6({
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
  Future<ApiResponse> uploadDigitalProduct(File? filePath, String token);
  Future<ApiResponse> updateProductQuantity(int? productId,int currentStock, List <Variation> variation);
  Future<ApiResponse> deleteProductImage(String id, String name, String? color );
  Future<ApiResponse> getProductImage(String id );
  Future<ApiResponse> deleteDigitalVariationFile(int? productId, String variantKey);
  Future<ApiResponse> deleteProductPreview(int? productId);
  Future<ApiResponse> getDigitalAuthor();
  Future<ApiResponse> getPublishingHouse();
  Future<ApiResponse> getTaxVatSetup({String businessModule = 'retail'});
  Future<ApiResponse> getTaxVatRateList({String businessModule = 'retail'});

}