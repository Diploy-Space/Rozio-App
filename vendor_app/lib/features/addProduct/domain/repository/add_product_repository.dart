import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/add_product_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/image_model.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/repository/add_product_repository_interface.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';


class AddProductRepository implements AddProductRepositoryInterface{
  final DioClient? dioClient;
  AddProductRepository({required this.dioClient});

  @override
  Future<ApiResponse> getAttributeList(String languageCode) async {
    try {
      final response = await dioClient!.get(AppConstants.attributeUri,
        queryParameters: {'limit': 200, 'offset': 1},
        options: Options(headers: {AppConstants.langKey: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  @override
  Future<ApiResponse> getEditProduct(int? id) async {
    try {
      final response = await dioClient!.get('${AppConstants.editProductUri}/$id/edit');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getCategoryList(String languageCode) async {
    try {
      final response = await dioClient!.get(AppConstants.categoryUri,
        options: Options(headers: {AppConstants.langKey: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getSubCategoryList() async {
    try {
      final response = await dioClient!.get(AppConstants.categoryUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getSubSubCategoryList() async {
    try {
      final response = await dioClient!.get(AppConstants.categoryUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }

  }

  @override
  Future<ApiResponse> addImage(BuildContext context, ImageModel imageForUpload, bool colorActivate) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.uploadProductImageUri}',
    ));
    if (kDebugMode) {
      print('==image is exist or not=${imageForUpload.image!.path}');
    }
    request.headers.addAll(<String, String>{'Authorization': 'Bearer ${Provider.of<AuthController>(context,listen: false).getUserToken()}'});
    if(Platform.isAndroid || Platform.isIOS && imageForUpload.image != null) {
      File file = File(imageForUpload.image!.path);
      request.files.add(http.MultipartFile('image', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'type': imageForUpload.type!,
      'color': imageForUpload.color!,
      'colors_active' : colorActivate.toString()
    });
    request.fields.addAll(fields);
    if (kDebugMode) {
      print('=====> ${request.url.path}\n${request.fields}');
    }


    http.StreamedResponse response =
    await request.send();
    var res = await http.Response.fromStream(response);
    if (kDebugMode) {
      print('=====Response body is here==>${res.body}');
    }

    try {
      return ApiResponse.withSuccess(Response(statusCode: response.statusCode,
          requestOptions: RequestOptions(path: ''), statusMessage: response.reasonPhrase,
          data: res.body));
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



 

  @override
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
  }) async {
    _setV6Headers();

    try {
      final Map<String, dynamic> fields = await _buildV6Fields(
        product: product,
        addProduct: addProduct,
        attributes: attributes,
        isActiveColor: isActiveColor,
        tags: tags,
        thumbnail: thumbnail,
        metaImage: metaImage,
        galleryImages: galleryImages,
        digitalFileReady: digitalFileReady,
        digitalVariationModel: digitalVariationModel,
        isDigitalVariationActive: isDigitalVariationActive,
        addColorImages: (fields) async {
          for (final ColorImage colorImage in colorImageObject) {
            final String? color = colorImage.color;
            final String? imageName = colorImage.imageName?.key;
            if (color == null || color.isEmpty || imageName == null || imageName.isEmpty || imageName == 'null') continue;
            fields['color_image_${color.replaceAll('#', '')}'] = imageName;
          }
        },
      );

      final String url = '${AppConstants.baseUrl}${AppConstants.addProductUri}';
      _logV6Request('Add Product V6', url, fields);

      final Response response = await dioClient!.postMultipart(url, data: fields);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
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
  }) async {
    _setV6Headers();

    try {
      final Map<String, dynamic> fields = await _buildV6Fields(
        product: product,
        addProduct: addProduct,
        attributes: attributes,
        isActiveColor: isActiveColor,
        tags: tags,
        thumbnail: thumbnail,
        metaImage: metaImage,
        galleryImages: galleryImages,
        digitalFileReady: digitalFileReady,
        digitalVariationModel: digitalVariationModel,
        isDigitalVariationActive: isDigitalVariationActive,
        addColorImages: (fields) async {
          for (final MapEntry<String, XFile> entry in colorImageFiles.entries) {
            fields['color_image_${entry.key.replaceAll('#', '')}'] = await _multipartFromXFile(entry.value);
          }
        },
      );

      fields['_method'] = 'PUT';
      _addIndexedFields(fields, 'removed_images', removedImages);

      final String url = '${AppConstants.baseUrl}${AppConstants.addProductUri}/$productId';
      _logV6Request('Update Product V6', url, fields);

      final Response response = await dioClient!.postMultipart(url, data: fields);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  void _setV6Headers() {
    final String languageCode = Provider.of<LocalizationController>(Get.context!, listen: false).locale.languageCode;
    dioClient!.dio!.options.headers = {
      'Authorization': 'Bearer ${Provider.of<AuthController>(Get.context!, listen: false).getUserToken()}',
      'Accept': 'application/json',
      AppConstants.langKey: (languageCode.isEmpty || languageCode == 'US') ? 'en' : languageCode,
    };
  }

  void _logV6Request(String label, String url, Map<String, dynamic> fields) {
    if (kDebugMode) {
      debugPrint('===$label URL==> $url');
      debugPrint('---Fields--> ${fields.keys.where((k) => fields[k] is! MultipartFile).map((k) => '$k=${fields[k]}').join(', ')}');
      debugPrint('---Files--> ${fields.keys.where((k) => fields[k] is MultipartFile).join(', ')}');
    }
  }

  Future<Map<String, dynamic>> _buildV6Fields({
    required Product product,
    required AddProductModel addProduct,
    required Map<String, dynamic> attributes,
    required bool isActiveColor,
    required List<String?> tags,
    required Future<void> Function(Map<String, dynamic> fields) addColorImages,
    XFile? thumbnail,
    XFile? metaImage,
    List<XFile> galleryImages = const [],
    File? digitalFileReady,
    DigitalVariationModel? digitalVariationModel,
    bool isDigitalVariationActive = false,
  }) async {
    final bool isPhysical = product.productType != 'digital';
    final Map<String, dynamic> fields = {};

    _addIndexedFields(fields, 'lang', addProduct.languageList);
    _addIndexedFields(fields, 'name', addProduct.titleList);
    _addIndexedFields(fields, 'description', addProduct.descriptionList);
    fields['code'] = product.code;
    fields['product_type'] = product.productType;
    if (addProduct.videoUrl?.isNotEmpty ?? false) fields['video_url'] = addProduct.videoUrl;

    final String tagString = tags.whereType<String>().map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).join(',');
    if (tagString.isNotEmpty) fields['tags'] = tagString;

    final List<CategoryIds> categoryIds = product.categoryIds ?? [];
    if (categoryIds.isNotEmpty) fields['category_id'] = categoryIds[0].id;
    if (categoryIds.length > 1) fields['sub_category_id'] = categoryIds[1].id;
    if (categoryIds.length > 2) fields['sub_sub_category_id'] = categoryIds[2].id;

    fields['unit_price'] = product.unitPrice;
    fields['discount'] = product.discount ?? 0;
    if (product.discountType != null) fields['discount_type'] = product.discountType;
    _addIndexedFields(fields, 'tax_ids', product.taxIds);
    if (product.taxModel != null) fields['tax_model'] = product.taxModel;
    fields['minimum_order_qty'] = product.minimumOrderQty;

    if (isPhysical) {
      if (product.brandId != null) fields['brand_id'] = product.brandId;
      fields['unit'] = product.unit;
      fields['shipping_cost'] = product.shippingCost;
      if (product.multiplyWithQuantity == 1) fields['multiply_qty'] = 'on';

      if (attributes.isEmpty) fields['current_stock'] = product.currentStock;

      if (isActiveColor && (addProduct.colorCodeList?.isNotEmpty ?? false)) {
        fields['colors_active'] = 'on';
        _addIndexedFields(fields, 'colors', addProduct.colorCodeList);
        await addColorImages(fields);
      }

      _addVariationFieldsV6(fields, attributes);
    } else {
      await _addDigitalFieldsV6(fields, product, digitalFileReady, digitalVariationModel, isDigitalVariationActive);
    }

    if (thumbnail != null) fields['image'] = await _multipartFromXFile(thumbnail);
    for (int i = 0; i < galleryImages.length; i++) {
      fields['images[$i]'] = await _multipartFromXFile(galleryImages[i]);
    }

    if (product.metaTitle?.isNotEmpty ?? false) fields['meta_title'] = product.metaTitle;
    if (product.metaDescription?.isNotEmpty ?? false) fields['meta_description'] = product.metaDescription;
    if (metaImage != null) fields['meta_image'] = await _multipartFromXFile(metaImage);
    if (product.metaSeoInfo != null) _addMetaSeoFieldsV6(fields, product.metaSeoInfo!);

    return fields;
  }

  void _addIndexedFields(Map<String, dynamic> fields, String key, List<dynamic>? values) {
    for (int i = 0; i < (values?.length ?? 0); i++) {
      fields['$key[$i]'] = values![i] ?? '';
    }
  }

  void _addVariationFieldsV6(Map<String, dynamic> fields, Map<String, dynamic> attributes) {
    attributes.forEach((key, value) {
      if (key == 'choice_attributes' || key == 'choice_no' || key == 'choice') {
        final dynamic decoded = value is String ? jsonDecode(value) : value;
        if (decoded is List) _addIndexedFields(fields, key, decoded);
      } else if (key.startsWith('choice_options_')) {
        if (key == 'choice_options_0' || value is! List) return;

        final String joined = value.whereType<String>().map((option) => option.trim()).where((option) => option.isNotEmpty).join(',');
        if (joined.isNotEmpty) fields['$key[0]'] = joined;
      } else {
        fields[key] = value;
      }
    });
  }

  Future<void> _addDigitalFieldsV6(Map<String, dynamic> fields, Product product, File? digitalFileReady, DigitalVariationModel? digitalVariationModel, bool isDigitalVariationActive) async {
    fields['digital_product_type'] = product.digitalProductType;
    _addIndexedFields(fields, 'authors', digitalVariationModel?.authors);
    _addIndexedFields(fields, 'publishing_house', digitalVariationModel?.publishingHouse);

    if (isDigitalVariationActive && digitalVariationModel != null) {
      final List<String> variationTypes = digitalVariationModel.variationType ?? [];
      _addIndexedFields(fields, 'extensions_type', variationTypes);

      for (int i = 0; i < variationTypes.length; i++) {
        final List<String> options = i < (digitalVariationModel.variationKeys?.length ?? 0) ? digitalVariationModel.variationKeys![i] : [];
        final String joined = options.map((option) => option.trim()).where((option) => option.isNotEmpty).join(',');
        if (joined.isNotEmpty) fields['extensions_options_${variationTypes[i]}[0]'] = joined;
      }

      digitalVariationModel.digitalVariantKeyMap?.forEach((key, value) => fields['digital_product_variant_key[$key]'] = value);
      digitalVariationModel.digitalVariantSku?.forEach((key, value) => fields['digital_product_sku[$key]'] = value);
      digitalVariationModel.digitalVariantPrice?.forEach((key, value) => fields['digital_product_price[$key]'] = value);

      for (final MapEntry<String, dynamic> entry in (digitalVariationModel.digitalVariantFiles ?? <String, dynamic>{}).entries) {
        if (entry.value is XFile) {
          fields['digital_files[${entry.key}]'] = await _multipartFromXFile(entry.value);
        }
      }
    } else if (product.digitalProductType == 'ready_product' && digitalFileReady != null) {
      fields['digital_file_ready'] = await MultipartFile.fromFile(digitalFileReady.path, filename: basename(digitalFileReady.path));
    }

    if (digitalVariationModel?.digitalProductPreview != null) {
      fields['preview_file'] = await _multipartFromXFile(digitalVariationModel!.digitalProductPreview!);
    }
  }

  void _addMetaSeoFieldsV6(Map<String, dynamic> fields, MetaSeoInfo metaSeoInfo) {
    fields['meta_index'] = metaSeoInfo.metaIndex == 'noindex' ? 'noindex' : 'index';

    if (metaSeoInfo.metaNoFollow == 'nofollow' || metaSeoInfo.metaNoFollow == '1') fields['meta_no_follow'] = 'nofollow';
    if (metaSeoInfo.metaNoImageIndex == 'noimageindex' || metaSeoInfo.metaNoImageIndex == '1') fields['meta_no_image_index'] = 'noimageindex';
    if (metaSeoInfo.metaNoArchive == 'noarchive' || metaSeoInfo.metaNoArchive == '1') fields['meta_no_archive'] = 'noarchive';
    if (metaSeoInfo.metaNoSnippet == 'nosnippet' || metaSeoInfo.metaNoSnippet == '1') fields['meta_no_snippet'] = '1';

    if (metaSeoInfo.metaMaxSnippet == '1') {
      fields['meta_max_snippet'] = '1';
      fields['meta_max_snippet_value'] = metaSeoInfo.metaMaxSnippetValue ?? '-1';
    }
    if (metaSeoInfo.metaMaxVideoPreview == '1') {
      fields['meta_max_video_preview'] = '1';
      fields['meta_max_video_preview_value'] = metaSeoInfo.metaMaxVideoPreviewValue ?? '-1';
    }
    if (metaSeoInfo.metaMaxImagePreview == '1') {
      fields['meta_max_image_preview'] = '1';
      fields['meta_max_image_preview_value'] = metaSeoInfo.metaMaxImagePreviewValue ?? 'large';
    }
  }

  Future<MultipartFile> _multipartFromXFile(XFile file) async {
    return MultipartFile.fromBytes(await file.readAsBytes(), filename: basename(file.path));
  }


  Future<List<MultipartWithKey>> processItems(DigitalVariationModel? digitalVariationModel) async {
    List<MultipartWithKey> multipartBody = [];

    if(digitalVariationModel?.digitalVariantFiles != null) {
      await Future.forEach(digitalVariationModel!.digitalVariantFiles!.keys, (key) async {
        if(digitalVariationModel.digitalVariantFiles![key] != null) {
          MultipartFile multiPartFile = MultipartFile.fromBytes(
            await digitalVariationModel.digitalVariantFiles![key].readAsBytes(),
            filename: basename(digitalVariationModel.digitalVariantFiles![key].name),
          );
          multipartBody.add(MultipartWithKey(key: 'digital_files_$key', multipartFile: multiPartFile));
        }
      });
    }

     if(digitalVariationModel?.digitalProductPreview != null) {
       MultipartFile multiPartFile = MultipartFile.fromBytes(
         await digitalVariationModel!.digitalProductPreview!.readAsBytes(),
         filename: basename(digitalVariationModel.digitalProductPreview!.name),
       );
       multipartBody.add(MultipartWithKey(key: 'preview_file', multipartFile: multiPartFile));
     }

    return multipartBody;
  }


  @override
  Future<ApiResponse> uploadDigitalProduct(File? filePath, String token) async {
    try {
      final List<MultipartWithKey> files = [];

      if(filePath != null) {
        files.add(MultipartWithKey(
          key: 'digital_file_ready',
          multipartFile: await MultipartFile.fromFile(filePath.path, filename: basename(filePath.path)),
        ));
      }

      final response = await dioClient!.postMultipart(
        AppConstants.digitalProductUpload,
        data: {},
        files: files,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> updateProductQuantity(int? productId,int currentStock, List <Variation> variation) async {
    try {
      final response = await dioClient!.put('${AppConstants.updateProductQuantity}/$productId/quantity',
          data: {
            "current_stock": currentStock,
            "variation" : variation,
          }
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }






  @override
  Future<ApiResponse> deleteProductImage(String id, String name, String? color ) async {
    try {
      final response = await dioClient!.delete("${AppConstants.deleteProductImage}/$id/images", data: {'name': name, 'color': color});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> deleteProductPreview(int? id) async {
    try {
      final response = await dioClient!.delete("${AppConstants.deleteProductPreview}/$id/preview-file");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> getProductImage(String id ) async {
    try {
      final response = await dioClient!.get("${AppConstants.getProductImage}/$id/images");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> deleteDigitalVariationFile(int? productId, String variantKey) async {
    try {
      final response = await dioClient!.delete('${AppConstants.deleteDigitalProductVariationFile}/$productId/digital-file',
          data: {"variant_key": variantKey}
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> getDigitalAuthor() async {
    try {
      final response = await dioClient!.get(AppConstants.digitalAuthorList);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getPublishingHouse() async {
    try {
      final response = await dioClient!.get(AppConstants.digitalPublishingHouse);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  @override
  Future<ApiResponse> getTaxVatSetup({String businessModule = 'retail'}) async {
    try {
      final response = await dioClient!.get(AppConstants.getTaxVatList, queryParameters: {'business_module': businessModule});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getTaxVatRateList({String businessModule = 'retail'}) async {
    try {
      final response = await dioClient!.get(AppConstants.sellerVatTaxListUri, queryParameters: {'business_module': businessModule});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }
}