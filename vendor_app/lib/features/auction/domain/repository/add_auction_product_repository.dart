import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/auction/domain/models/add_auction_product_model.dart';
import 'package:sixvalley_vendor_app/features/auction/domain/repository/add_auction_product_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';


class AddAuctionProductRepository implements AddAuctionProductRepositoryInterface {
  final DioClient? dioClient;
  AddAuctionProductRepository({required this.dioClient});

  @override
  Future<ApiResponse> addAuctionProductV6({
    required AddAuctionProductModel addAuctionProduct,
    required int categoryId,
    int? brandId,
    required String productType,
    required String itemCondition,
    required double startingPrice,
    required double minimumIncrementAmount,
    required double maximumDecrementAmount,
    required String startTime,
    required String endTime,
    required double shippingFee,
    String? returnPolicy,
    required XFile thumbnail,
    required List<XFile> images,
    String? videoType,
    String? youtubeVideo,
    XFile? customerVideo,
    List<int>? taxIds,
    String? metaTitle,
    String? metaDescription,
    String? metaIndex,
    String? metaNoFollow,
    String? metaNoImageIndex,
    String? metaNoArchive,
    String? metaNoSnippet,
    String? metaMaxSnippet,
    String? metaMaxSnippetValue,
    String? metaMaxVideoPreview,
    String? metaMaxVideoPreviewValue,
    String? metaMaxImagePreview,
    String? metaMaxImagePreviewValue,
    XFile? metaImageFile,
    String? tags,
  }) async {
    _setV6Headers();

    try {
      final Map<String, dynamic> fields = {};

      _addIndexedFields(fields, 'lang', addAuctionProduct.languageList);
      _addIndexedFields(fields, 'name', addAuctionProduct.titleList);
      _addIndexedFields(fields, 'description', addAuctionProduct.descriptionList);
      fields['category_id'] = categoryId;
      if (brandId != null) fields['brand_id'] = brandId;
      fields['product_type'] = productType;
      fields['item_condition'] = _itemCondition(itemCondition);
      fields['starting_price'] = startingPrice;
      fields['minimum_increment_amount'] = minimumIncrementAmount;
      fields['maximum_decrement_amount'] = maximumDecrementAmount;
      fields['auction_start_time'] = startTime;
      fields['auction_end_time'] = endTime;
      fields['shipping_fee'] = shippingFee;
      _addIfNotEmpty(fields, 'return_policy', returnPolicy);
      _addIfNotEmpty(fields, 'tags', tags);
      _addIndexedFields(fields, 'tax_ids', taxIds);
      _addVideoFields(fields, videoType: videoType, youtubeVideo: youtubeVideo, customerVideo: customerVideo);
      _addSeoFields(
        fields,
        metaTitle: metaTitle,
        metaDescription: metaDescription,
        metaIndex: metaIndex,
        metaNoFollow: metaNoFollow,
        metaNoImageIndex: metaNoImageIndex,
        metaNoArchive: metaNoArchive,
        metaNoSnippet: metaNoSnippet,
        metaMaxSnippet: metaMaxSnippet,
        metaMaxSnippetValue: metaMaxSnippetValue,
        metaMaxVideoPreview: metaMaxVideoPreview,
        metaMaxVideoPreviewValue: metaMaxVideoPreviewValue,
        metaMaxImagePreview: metaMaxImagePreview,
        metaMaxImagePreviewValue: metaMaxImagePreviewValue,
      );
      await _addMediaFiles(fields, thumbnail: thumbnail, images: images, videoType: videoType, customerVideo: customerVideo, metaImageFile: metaImageFile);

      final String url = '${AppConstants.baseUrl}${AppConstants.addAuctionProductUri}';
      _logV6Request('Add Auction', url, fields);

      Response response = await dioClient!.postMultipart(url, data: fields);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateAuctionProductV6({
    required int auctionId,
    required AddAuctionProductModel addAuctionProduct,
    required int categoryId,
    int? brandId,
    required String productType,
    required String itemCondition,
    required double startingPrice,
    required double minimumIncrementAmount,
    required double maximumDecrementAmount,
    required String startTime,
    required String endTime,
    required double shippingFee,
    String? returnPolicy,
    XFile? thumbnail,
    List<XFile>? images,
    List<String>? existingImages,
    String? videoType,
    String? youtubeVideo,
    XFile? customerVideo,
    List<int>? taxIds,
    String? metaTitle,
    String? metaDescription,
    String? metaIndex,
    String? metaNoFollow,
    String? metaNoImageIndex,
    String? metaNoArchive,
    String? metaNoSnippet,
    String? metaMaxSnippet,
    String? metaMaxSnippetValue,
    String? metaMaxVideoPreview,
    String? metaMaxVideoPreviewValue,
    String? metaMaxImagePreview,
    String? metaMaxImagePreviewValue,
    XFile? metaImageFile,
    String? tags,
  }) async {
    _setV6Headers();

    try {
      final Map<String, dynamic> fields = {};

      _addIndexedFields(fields, 'lang', addAuctionProduct.languageList);
      _addIndexedFields(fields, 'name', addAuctionProduct.titleList);
      _addIndexedFields(fields, 'description', addAuctionProduct.descriptionList);
      fields['category_id'] = categoryId;
      if (brandId != null) fields['brand_id'] = brandId;
      fields['product_type'] = productType;
      fields['item_condition'] = _itemCondition(itemCondition);
      fields['starting_price'] = startingPrice;
      fields['minimum_increment_amount'] = minimumIncrementAmount;
      fields['maximum_decrement_amount'] = maximumDecrementAmount;
      fields['auction_start_time'] = startTime;
      fields['auction_end_time'] = endTime;
      fields['shipping_fee'] = shippingFee;
      _addIfNotEmpty(fields, 'return_policy', returnPolicy);
      _addIfNotEmpty(fields, 'tags', tags);
      _addIndexedFields(fields, 'tax_ids', taxIds);
      _addIndexedFields(fields, 'existing_images', existingImages);
      _addVideoFields(fields, videoType: videoType, youtubeVideo: youtubeVideo, customerVideo: customerVideo);
      _addSeoFields(
        fields,
        metaTitle: metaTitle,
        metaDescription: metaDescription,
        metaIndex: metaIndex,
        metaNoFollow: metaNoFollow,
        metaNoImageIndex: metaNoImageIndex,
        metaNoArchive: metaNoArchive,
        metaNoSnippet: metaNoSnippet,
        metaMaxSnippet: metaMaxSnippet,
        metaMaxSnippetValue: metaMaxSnippetValue,
        metaMaxVideoPreview: metaMaxVideoPreview,
        metaMaxVideoPreviewValue: metaMaxVideoPreviewValue,
        metaMaxImagePreview: metaMaxImagePreview,
        metaMaxImagePreviewValue: metaMaxImagePreviewValue,
      );
      await _addMediaFiles(fields, thumbnail: thumbnail, images: images, videoType: videoType, customerVideo: customerVideo, metaImageFile: metaImageFile);

      final String url = '${AppConstants.baseUrl}${AppConstants.addAuctionProductUri}/$auctionId';
      _logV6Request('Update Auction', url, fields);

      Response response = await dioClient!.postMultipart(url, data: fields);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> relaunchAuctionProductV6({
    required int auctionId,
    required AddAuctionProductModel addAuctionProduct,
    required int categoryId,
    int? brandId,
    required String productType,
    required String itemCondition,
    required double startingPrice,
    required double minimumIncrementAmount,
    required double maximumDecrementAmount,
    required String startTime,
    required String endTime,
    required double shippingFee,
    String? returnPolicy,
    XFile? thumbnail,
    List<XFile>? images,
    List<String>? retainedImages,
    String? videoType,
    String? youtubeVideo,
    XFile? customerVideo,
    List<int>? taxIds,
    String? metaTitle,
    String? metaDescription,
    XFile? metaImageFile,
    String? currentCurrencyCode,
    String? tags,
  }) async {
    _setV6Headers();

    try {
      final Map<String, dynamic> fields = {};

      fields['id'] = auctionId;
      fields['lang'] = addAuctionProduct.languageList?.firstOrNull ?? 'en';
      fields['name'] = addAuctionProduct.titleList?.firstOrNull ?? '';
      _addIfNotEmpty(fields, 'description', addAuctionProduct.descriptionList?.firstOrNull);
      fields['category_id'] = categoryId;
      if (brandId != null) fields['brand_id'] = brandId;
      fields['product_type'] = productType;
      fields['item_condition'] = _itemCondition(itemCondition);
      fields['entry_fee'] = 0;
      fields['starting_price'] = startingPrice;
      fields['minimum_increment_amount'] = minimumIncrementAmount;
      fields['maximum_decrement_amount'] = maximumDecrementAmount;
      fields['start_time'] = startTime;
      fields['end_time'] = endTime;
      fields['status'] = 1;
      fields['shipping_fee'] = shippingFee;
      _addIfNotEmpty(fields, 'return_policy', returnPolicy);
      _addIfNotEmpty(fields, 'tags', tags);
      if (taxIds != null && taxIds.isNotEmpty) fields['tax_ids'] = jsonEncode(taxIds);
      _addIndexedFields(fields, 'retained_images', retainedImages);
      _addVideoFields(fields, videoType: videoType, youtubeVideo: youtubeVideo, customerVideo: customerVideo);
      _addIfNotEmpty(fields, 'meta_title', metaTitle);
      _addIfNotEmpty(fields, 'meta_description', metaDescription);
      _addIfNotEmpty(fields, 'current_currency_code', currentCurrencyCode);
      await _addMediaFiles(fields, thumbnail: thumbnail, images: images, videoType: videoType, customerVideo: customerVideo, metaImageFile: metaImageFile);

      final String url = '${AppConstants.baseUrl}${AppConstants.addAuctionProductUri}/$auctionId/relaunch';
      _logV6Request('Relaunch Auction', url, fields);

      Response response = await dioClient!.postMultipart(url, data: fields);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  String _itemCondition(String itemCondition) {
    const Map<String, String> itemConditions = {'new': 'New', 'like_new': 'Like_New', 'excellent': 'Excellent', 'good': 'Good', 'fair': 'Fair'};
    return itemConditions[itemCondition.trim().toLowerCase().replaceAll(' ', '_')] ?? itemCondition.trim();
  }

  void _addVideoFields(Map<String, dynamic> fields, {String? videoType, String? youtubeVideo, XFile? customerVideo}) {
    if (videoType == 'youtube_link' && (youtubeVideo?.trim().isNotEmpty ?? false)) {
      fields['video_provider'] = videoType;
      fields['youtube_video_url'] = youtubeVideo!.trim();
    } else if (videoType == 'custom_video' && customerVideo != null) {
      fields['video_provider'] = videoType;
    }
  }

  void _addSeoFields(
    Map<String, dynamic> fields, {
    String? metaTitle,
    String? metaDescription,
    String? metaIndex,
    String? metaNoFollow,
    String? metaNoImageIndex,
    String? metaNoArchive,
    String? metaNoSnippet,
    String? metaMaxSnippet,
    String? metaMaxSnippetValue,
    String? metaMaxVideoPreview,
    String? metaMaxVideoPreviewValue,
    String? metaMaxImagePreview,
    String? metaMaxImagePreviewValue,
  }) {
    _addIfNotEmpty(fields, 'meta_title', metaTitle);
    _addIfNotEmpty(fields, 'meta_description', metaDescription);
    if (metaIndex == 'index' || metaIndex == 'noindex') fields['meta_index'] = metaIndex;
    _addFlag(fields, 'meta_no_follow', metaNoFollow);
    _addFlag(fields, 'meta_no_image_index', metaNoImageIndex);
    _addFlag(fields, 'meta_no_archive', metaNoArchive);
    _addFlag(fields, 'meta_no_snippet', metaNoSnippet);
    _addFlag(fields, 'meta_max_snippet', metaMaxSnippet);
    _addNumber(fields, 'meta_max_snippet_value', metaMaxSnippetValue);
    _addFlag(fields, 'meta_max_video_preview', metaMaxVideoPreview);
    _addNumber(fields, 'meta_max_video_preview_value', metaMaxVideoPreviewValue);
    _addFlag(fields, 'meta_max_image_preview', metaMaxImagePreview);
    final String? imagePreviewSize = _imagePreviewSize(metaMaxImagePreviewValue);
    if (imagePreviewSize != null) fields['meta_max_image_preview_value'] = imagePreviewSize;
  }

  Future<void> _addMediaFiles(
    Map<String, dynamic> fields, {
    XFile? thumbnail,
    List<XFile>? images,
    String? videoType,
    XFile? customerVideo,
    XFile? metaImageFile,
  }) async {
    if (thumbnail != null) fields['thumbnail'] = await _toMultipartFile(thumbnail);
    for (int i = 0; i < (images?.length ?? 0); i++) {
      fields['images[$i]'] = await _toMultipartFile(images![i]);
    }
    if (videoType == 'custom_video' && customerVideo != null) {
      fields['custom_video_url'] = await _toMultipartFile(customerVideo);
    }
    if (metaImageFile != null) fields['meta_image'] = await _toMultipartFile(metaImageFile);
  }

  void _logV6Request(String label, String url, Map<String, dynamic> fields) {
    if (!kDebugMode) return;
    debugPrint('===$label V6 URL==> $url');
    debugPrint('---Fields--> ${fields.keys.where((k) => fields[k] is! MultipartFile).map((k) => '$k=${fields[k]}').join(', ')}');
    debugPrint('---Files--> ${fields.keys.where((k) => fields[k] is MultipartFile).join(', ')}');
  }

  void _setV6Headers() {
    final String languageCode = Provider.of<LocalizationController>(Get.context!, listen: false).locale.languageCode;
    dioClient!.dio!.options.headers = {
      'Authorization': 'Bearer ${Provider.of<AuthController>(Get.context!, listen: false).getUserToken()}',
      'Accept': 'application/json',
      AppConstants.langKey: (languageCode.isEmpty || languageCode == 'US') ? 'en' : languageCode,
    };
  }

  void _addIndexedFields(Map<String, dynamic> fields, String key, List<dynamic>? values) {
    for (int i = 0; i < (values?.length ?? 0); i++) {
      fields['$key[$i]'] = values![i] ?? '';
    }
  }

  void _addIfNotEmpty(Map<String, dynamic> fields, String key, String? value) {
    if (value != null && value.trim().isNotEmpty) fields[key] = value.trim();
  }

  void _addFlag(Map<String, dynamic> fields, String key, String? value) {
    final String normalized = value?.trim().toLowerCase() ?? '';
    if (normalized.isNotEmpty && normalized != '0' && normalized != 'false') fields[key] = '1';
  }

  void _addNumber(Map<String, dynamic> fields, String key, String? value) {
    if (double.tryParse(value?.trim() ?? '') != null) fields[key] = value!.trim();
  }

  String? _imagePreviewSize(String? value) {
    switch (value?.trim().toLowerCase()) {
      case '2':
      case 'large':
        return 'large';
      case '1':
      case 'medium':
        return 'medium';
      case '0':
      case 'small':
        return 'small';
      default:
        return null;
    }
  }

  Future<MultipartFile> _toMultipartFile(XFile file) async {
    return MultipartFile.fromBytes(await file.readAsBytes(), filename: basename(file.path));
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    throw UnimplementedError();
  }
}
