import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/add_wholesale_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_attribute_image_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_faq_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_meta_seo_info_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/repositories/add_wholesale_product_repository_interface.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class AddWholesaleProductRepository implements AddWholesaleProductRepositoryInterface {
  final DioClient? dioClient;
  AddWholesaleProductRepository({required this.dioClient});

  void _setRequestHeaders(String? token) {
    dioClient!.dio!.options.headers = {
      'Authorization': 'Bearer ${token ?? Provider.of<AuthController>(Get.context!, listen: false).getUserToken()}'
    };
  }

  @override
  Future<ApiResponse> addWholesaleProduct({
    required AddWholesaleProductModel addWholesaleProduct,
    required int categoryId,
    int? subCategoryId,
    int? subSubCategoryId,
    int? brandId,
    required String code,
    required String unit,
    int? reorderLevel,
    required double shippingCost,
    bool multiplyQty = false,
    String? tags,
    bool colorsActive = false,
    List<String?>? colors,
    List<int>? choiceAttributeIds,
    List<String?>? choiceAttributeNames,
    Map<int, List<String?>>? choiceOptions,
    Map<String, int>? variantQuantities,
    Map<String, String>? variantSkus,
    int? currentStock,
    required int minimumOrderQty,
    double? discount,
    required String discountType,
    List<int>? taxIds,
    bool variationBasedPrice = false,
    bool quantityBasedPrice = false,
    String? variationType,
    Map<String, String>? variationPrice,
    Map<String, String>? variationDiscount,
    List<String>? tierMinQty,
    List<String>? tierMaxQty,
    List<String>? tierUnitPrice,
    Map<String, Map<int, String>>? variationTierPrice,
    Map<String, Map<int, String>>? variationTierDiscount,
    XFile? thumbnail,
    List<XFile>? images,
    String? videoProvider,
    String? youtubeVideoUrl,
    XFile? customVideo,
    List<WholesaleAttributeImageModel>? attributeImages,
    List<WholesaleFaqModel>? faqList,
    String? metaTitle,
    String? metaDescription,
    XFile? metaImage,
    WholesaleMetaSeoInfo? metaSeoInfo,
    bool update = false,
    int? productId,
    List<String>? existingImages,
  }) async {
    _setRequestHeaders(Provider.of<AuthController>(Get.context!, listen: false).getUserToken());

    try {
      final Map<String, dynamic> fields = {};

      for (int i = 0; i < (addWholesaleProduct.languageList?.length ?? 0); i++) {
        fields['lang[$i]'] = addWholesaleProduct.languageList![i];
      }
      for (int i = 0; i < (addWholesaleProduct.titleList?.length ?? 0); i++) {
        fields['name[$i]'] = addWholesaleProduct.titleList![i];
      }
      for (int i = 0; i < (addWholesaleProduct.descriptionList?.length ?? 0); i++) {
        fields['description[$i]'] = addWholesaleProduct.descriptionList![i];
      }

      fields['category_id'] = categoryId;
      if (subCategoryId != null) fields['sub_category_id'] = subCategoryId;
      if (subSubCategoryId != null) fields['sub_sub_category_id'] = subSubCategoryId;
      if (brandId != null) fields['brand_id'] = brandId;

      fields['code'] = code;
      fields['unit'] = unit;
      if (reorderLevel != null) fields['reorder_level'] = reorderLevel;
      fields['shipping_cost'] = shippingCost;

      if (multiplyQty) fields['multiply_qty'] = 'on';

      if (tags != null && tags.isNotEmpty) fields['tags'] = tags;

      if (colorsActive && (colors?.isNotEmpty ?? false)) {
        fields['colors_active'] = 'on';
        for (int i = 0; i < colors!.length; i++) {
          fields['colors[$i]'] = colors[i];
        }
      }

      for (int i = 0; i < (choiceAttributeIds?.length ?? 0); i++) {
        fields['choice_attributes[$i]'] = choiceAttributeIds![i];
        fields['choice_no[$i]'] = choiceAttributeIds[i];
      }
      for (int i = 0; i < (choiceAttributeNames?.length ?? 0); i++) {
        fields['choice[$i]'] = choiceAttributeNames![i];
      }

      choiceOptions?.forEach((attributeId, options) {
        final String joined = options.whereType<String>().map((option) => option.trim()).where((option) => option.isNotEmpty).join(',');
        if (joined.isNotEmpty) {
          fields['choice_options_$attributeId[0]'] = joined;
        }
      });

      variantQuantities?.forEach((variant, qty) => fields['qty_$variant'] = qty);
      variantSkus?.forEach((variant, sku) => fields['sku_$variant'] = sku);

      if (currentStock != null) fields['current_stock'] = currentStock;
      fields['minimum_order_qty'] = minimumOrderQty;

      fields['discount'] = variationBasedPrice ? 0 : (discount ?? 0);
      fields['discount_type'] = variationBasedPrice ? 'flat' : discountType;

      for (int i = 0; i < (taxIds?.length ?? 0); i++) {
        fields['tax_ids[$i]'] = taxIds![i];
      }

      fields['variation_based_price'] = variationBasedPrice ? 1 : 0;
      fields['quantity_based_price'] = quantityBasedPrice ? 1 : 0;

      if (variationBasedPrice) {
        if (variationType != null && variationType.isNotEmpty) {
          fields['variation_type'] = variationType;
        }

        if (quantityBasedPrice) {
          _addTierRange(fields, tierMinQty, tierMaxQty);

          variationTierPrice?.forEach((value, tiers) {
            tiers.forEach((tierIndex, price) => fields['variation_tier_price[$value][$tierIndex]'] = price);
          });
          variationTierDiscount?.forEach((value, tiers) {
            tiers.forEach((tierIndex, discount) {
              if (discount.isNotEmpty) fields['variation_tier_discount[$value][$tierIndex]'] = discount;
            });
          });
        } else {
          variationPrice?.forEach((value, price) => fields['variation_price[$value]'] = price);
          variationDiscount?.forEach((value, discount) {
            if (discount.isNotEmpty) fields['variation_discount[$value]'] = discount;
          });
        }
      } else {
        _addTierRange(fields, tierMinQty, tierMaxQty);
        for (int i = 0; i < (tierUnitPrice?.length ?? 0); i++) {
          fields['tier_unit_price[$i]'] = tierUnitPrice![i];
        }
      }

      if (thumbnail != null) {
        fields['image'] = await _multipart(thumbnail);
      }
      for (int i = 0; i < (images?.length ?? 0); i++) {
        fields['images[$i]'] = await _multipart(images![i]);
      }

      for (int i = 0; i < (existingImages?.length ?? 0); i++) {
        fields['existing_images[$i]'] = existingImages![i];
      }

      fields['video_provider'] = videoProvider ?? 'youtube_link';
      if (videoProvider == 'custom_video') {
        if (customVideo != null) {
          fields['custom_video_url'] = await _multipart(customVideo);
        }
      } else if (youtubeVideoUrl != null && youtubeVideoUrl.isNotEmpty) {
        fields['youtube_video_url'] = youtubeVideoUrl;
      }

      for (int i = 0; i < (attributeImages?.length ?? 0); i++) {
        final WholesaleAttributeImageModel group = attributeImages![i];
        final String key = '$i-0';

        fields['attribute_images[$key][type]'] = group.type;

        if (group.attributeId != null) {
          fields['attribute_images[$key][attribute_id]'] = group.attributeId;
        }

        fields['attribute_images[$key][value]'] = group.value;

        for (int j = 0; j < group.existingImages.length; j++) {
          fields['attribute_images[$key][existing][$j]'] = group.existingImages[j];
        }
        for (int j = 0; j < group.images.length; j++) {
          final int position = group.existingImages.length + j;
          fields['attribute_images[$key][images][$position]'] = await _multipart(group.images[j]);
        }
        for (final int galleryIndex in group.galleryIndexes) {
          fields['attribute_images[$key][gallery][$galleryIndex]'] = '1';
        }
      }

      final List<String?> languageCodes = addWholesaleProduct.languageList ?? [];
      for (int i = 0; i < (faqList?.length ?? 0); i++) {
        final WholesaleFaqModel faq = faqList![i];
        for (int j = 0; j < languageCodes.length; j++) {
          fields['faq[$i][lang][$j]'] = languageCodes[j];
          fields['faq[$i][question][$j]'] = j < faq.questionList.length ? faq.questionList[j] : '';
          fields['faq[$i][answer][$j]'] = j < faq.answerList.length ? faq.answerList[j] : '';
        }
        fields['faq[$i][priority]'] = faq.priority;
        fields['faq[$i][status]'] = '1';
      }

      if (metaTitle != null && metaTitle.isNotEmpty) fields['meta_title'] = metaTitle;
      if (metaDescription != null && metaDescription.isNotEmpty) fields['meta_description'] = metaDescription;
      if (metaImage != null) fields['meta_image'] = await _multipart(metaImage);

      if (metaSeoInfo != null) {
        fields['meta_index'] = metaSeoInfo.metaIndex;

        if (metaSeoInfo.metaNoFollow == 'nofollow' || metaSeoInfo.metaNoFollow == '1') fields['meta_no_follow'] = '1';
        if (metaSeoInfo.metaNoArchive == '1') fields['meta_no_archive'] = '1';
        if (metaSeoInfo.metaNoImageIndex == '1') fields['meta_no_image_index'] = '1';
        if (metaSeoInfo.metaNoSnippet == '1') fields['meta_no_snippet'] = '1';

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
          fields['meta_max_image_preview_value'] = metaSeoInfo.metaMaxImagePreviewValue;
        }
      }

      final bool isUpdate = update || productId != null;
      final String url = isUpdate
          ? '${AppConstants.baseUrl}${AppConstants.wholesaleProducts}/$productId'
          : '${AppConstants.baseUrl}${AppConstants.wholesaleProducts}';

      if (kDebugMode) {
        debugPrint('===Add/Update Wholesale Product URL==> $url');
        debugPrint('---Fields--> ${fields.keys.where((k) => fields[k] is! MultipartFile).map((k) => '$k=${fields[k]}').join(', ')}');
        debugPrint('---Files--> ${fields.keys.where((k) => fields[k] is MultipartFile).join(', ')}');
      }

      final Response response = await dioClient!.postMultipart(url, data: fields);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  void _addTierRange(Map<String, dynamic> fields, List<String>? tierMinQty, List<String>? tierMaxQty) {
    for (int i = 0; i < (tierMinQty?.length ?? 0); i++) {
      fields['tier_min_qty[$i]'] = tierMinQty![i];
      fields['tier_max_qty[$i]'] = (tierMaxQty != null && i < tierMaxQty.length) ? tierMaxQty[i] : '';
    }
  }

  Future<MultipartFile> _multipart(XFile file) async {
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
  Future<ApiResponse> getProductDetail(int productId) async {
    try {
      _setRequestHeaders(null);
      final Response response = await dioClient!.get('${AppConstants.wholesaleProducts}/$productId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
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
