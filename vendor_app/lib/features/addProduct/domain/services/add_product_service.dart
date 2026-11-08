
 import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/add_product_model.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/image_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/repository/add_product_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/services/add_product_service_interface.dart';

class AddProductService implements AddProductServiceInterface{
 final AddProductRepositoryInterface shopRepoInterface;
 AddProductService({required this.shopRepoInterface});

  @override
  Future addImage(BuildContext context, ImageModel imageForUpload, bool colorActivate) {
    return shopRepoInterface.addImage(context, imageForUpload, colorActivate);
  }

  @override
  Future addProductV6({
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
  }) async {
    return await shopRepoInterface.addProductV6(
      product: product,
      addProduct: addProduct,
      attributes: attributes,
      isActiveColor: isActiveColor,
      colorImageObject: colorImageObject,
      tags: tags,
      thumbnail: thumbnail,
      metaImage: metaImage,
      galleryImages: galleryImages,
      digitalFileReady: digitalFileReady,
      digitalVariationModel: digitalVariationModel,
      isDigitalVariationActive: isDigitalVariationActive,
    );
  }

  @override
  Future updateProductV6({
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
  }) async {
    return await shopRepoInterface.updateProductV6(
      productId: productId,
      product: product,
      addProduct: addProduct,
      attributes: attributes,
      isActiveColor: isActiveColor,
      tags: tags,
      thumbnail: thumbnail,
      metaImage: metaImage,
      galleryImages: galleryImages,
      colorImageFiles: colorImageFiles,
      removedImages: removedImages,
      digitalFileReady: digitalFileReady,
      digitalVariationModel: digitalVariationModel,
      isDigitalVariationActive: isDigitalVariationActive,
    );
  }

  @override
  Future getAttributeList(String languageCode) {
    return shopRepoInterface.getAttributeList(languageCode);
  }


  @override
  Future getCategoryList(String languageCode) {
    return shopRepoInterface.getCategoryList(languageCode);
  }

  @override
  Future getEditProduct(int? id) {
   return shopRepoInterface.getEditProduct(id);
  }

  @override
  Future getSubCategoryList() {
   return shopRepoInterface.getSubCategoryList();
  }

  @override
  Future getSubSubCategoryList() {
    return shopRepoInterface.getSubSubCategoryList();
  }

  @override
  Future updateProductQuantity(int? productId, int currentStock, List<Variation> variation) {
    return shopRepoInterface.updateProductQuantity(productId, currentStock, variation);
  }



  @override
  Future uploadDigitalProduct(File? filePath, String token) {
   return shopRepoInterface.uploadDigitalProduct(filePath, token);
  }

  @override
  Future deleteProductImage(String id, String name, String? color) {
    return shopRepoInterface.deleteProductImage(id, name, color);
  }

  @override
  Future getProductImage(String id) {
    return shopRepoInterface.getProductImage(id);
  }

  @override
  Future deleteDigitalVariationFile(int? productId, String variantKey) {
   return shopRepoInterface.deleteDigitalVariationFile(productId, variantKey);
  }

 @override
 Future deleteProductPreview(int? id) {
  return shopRepoInterface.deleteProductPreview(id);
 }


 @override
 Future getDigitalAuthor() {
  return shopRepoInterface.getDigitalAuthor();
 }

 @override
 Future getPublishingHouse() {
  return shopRepoInterface.getPublishingHouse();
 }

 @override
 Future getTaxVatSetup({String businessModule = 'retail'}) {
  return shopRepoInterface.getTaxVatSetup(businessModule: businessModule);
 }

 @override
 Future getTaxVatRateList({String businessModule = 'retail'}) {
  return shopRepoInterface.getTaxVatRateList(businessModule: businessModule);
 }

}