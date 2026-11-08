import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';

class WholesaleProductDetailModel {
  final int? id;
  final String? name;
  final String? slug;
  final String? code;
  final String? details;
  final List<WholesaleProductTranslation> translations;
  final int? categoryId;
  final int? subCategoryId;
  final int? subSubCategoryId;
  final int? brandId;
  final String? categoryName;
  final String? subCategoryName;
  final String? brandName;
  final String? unit;
  final double? unitPrice;
  final int? minimumOrderQty;
  final int? currentStock;
  final double? discount;
  final String? discountType;
  final bool multiplyQty;
  final double? shippingCost;
  final double? tempShippingCost;
  final bool isShippingCostUpdated;
  final int? status;
  final int? requestStatus;
  final String? deniedNote;
  final List<WholesaleProductColor> colors;
  final List<int> choiceAttributes;
  final List<WholesaleChoiceOption> choiceOptions;
  final List<WholesaleStock> stocks;
  final ImageFullUrl? thumbnailFullUrl;
  final List<ImageFullUrl> imagesFullUrl;
  final List<WholesaleAttributeImage> attributeImages;
  final String? videoProvider;
  final String? videoUrl;
  final String? videoFile;
  final String? videoFileFullUrl;
  final List<String> tags;
  final List<int> taxIds;
  final WholesaleDetail? wholesaleDetail;
  final List<WholesaleFaq> faqs;
  final WholesaleSeo? seo;

  WholesaleProductDetailModel({
    this.id,
    this.name,
    this.slug,
    this.code,
    this.details,
    this.translations = const [],
    this.categoryId,
    this.subCategoryId,
    this.subSubCategoryId,
    this.brandId,
    this.categoryName,
    this.subCategoryName,
    this.brandName,
    this.unit,
    this.unitPrice,
    this.minimumOrderQty,
    this.currentStock,
    this.discount,
    this.discountType,
    this.multiplyQty = false,
    this.shippingCost,
    this.tempShippingCost,
    this.isShippingCostUpdated = true,
    this.status,
    this.requestStatus,
    this.deniedNote,
    this.colors = const [],
    this.choiceAttributes = const [],
    this.choiceOptions = const [],
    this.stocks = const [],
    this.thumbnailFullUrl,
    this.imagesFullUrl = const [],
    this.attributeImages = const [],
    this.videoProvider,
    this.videoUrl,
    this.videoFile,
    this.videoFileFullUrl,
    this.tags = const [],
    this.taxIds = const [],
    this.wholesaleDetail,
    this.faqs = const [],
    this.seo,
  });

  factory WholesaleProductDetailModel.fromJson(Map<String, dynamic> json) {
    return WholesaleProductDetailModel(
      id: _toInt(json['id']),
      name: json['name'],
      slug: json['slug'],
      code: json['code'],
      details: json['details'],
      translations: _mapList(json['translations'], WholesaleProductTranslation.fromJson),
      categoryId: _toInt(json['category_id']),
      subCategoryId: _toInt(json['sub_category_id']),
      subSubCategoryId: _toInt(json['sub_sub_category_id']),
      brandId: _toInt(json['brand_id']),
      categoryName: json['category_name']?.toString(),
      subCategoryName: json['sub_category_name']?.toString(),
      brandName: json['brand_name']?.toString(),
      unit: json['unit'],
      unitPrice: _toDouble(json['unit_price']),
      minimumOrderQty: _toInt(json['minimum_order_qty']),
      currentStock: _toInt(json['current_stock']),
      discount: _toDouble(json['discount']),
      discountType: json['discount_type'],
      multiplyQty: _toBool(json['multiply_qty']),
      shippingCost: _toDouble(json['shipping_cost']),
      tempShippingCost: _toDouble(json['temp_shipping_cost']),
      isShippingCostUpdated: _toBool(json['is_shipping_cost_updated'], whenNull: true),
      status: _toInt(json['status']),
      requestStatus: _toInt(json['request_status']),
      deniedNote: json['denied_note']?.toString(),
      colors: _toColorList(json['colors']),
      choiceAttributes: _toIntList(json['choice_attributes']),
      choiceOptions: _mapList(json['choice_options'], WholesaleChoiceOption.fromJson),
      stocks: _mapList(json['stocks'], WholesaleStock.fromJson),
      thumbnailFullUrl: json['thumbnail_full_url'] is Map<String, dynamic> ? ImageFullUrl.fromJson(json['thumbnail_full_url']) : null,
      imagesFullUrl: _mapList(json['images_full_url'], ImageFullUrl.fromJson),
      attributeImages: _mapList(json['attribute_images'], WholesaleAttributeImage.fromJson),
      videoProvider: json['video_provider'],
      videoUrl: json['video_url'],
      videoFile: json['video_file'],
      videoFileFullUrl: json['video_file_full_url'],
      tags: _toStringList(json['tags']),
      taxIds: _toIntList(json['tax_ids']),
      wholesaleDetail: json['wholesale_detail'] is Map<String, dynamic> ? WholesaleDetail.fromJson(json['wholesale_detail']) : null,
      faqs: _mapList(json['faqs'], WholesaleFaq.fromJson),
      seo: json['seo'] is Map<String, dynamic> ? WholesaleSeo.fromJson(json['seo']) : null,
    );
  }

  bool get hasColors => colors.isNotEmpty;

  bool get hasVariation => hasColors || choiceOptions.isNotEmpty;

  List<String> get galleryKeysToKeep {
    final Set<String> projected = attributeImages
        .map((attributeImage) => attributeImage.imageFullUrl?.key).whereType<String>().toSet();

    return imagesFullUrl
        .map((image) => image.key).whereType<String>().where((key) => !projected.contains(key)).toList();
  }

  bool get hasVideoFile => videoProvider == 'custom_video' || videoProvider == 'self_hosted';

  String get postedVideoProvider => hasVideoFile ? 'custom_video' : 'youtube_link';

  String? get postedYoutubeUrl => hasVideoFile ? null : videoUrl;

  String get postedTags => tags.join(',');

  List<String> get colorCodes => colors.map((color) => color.code).whereType<String>().toList();
}

class WholesaleProductTranslation {
  final String? locale;
  final String? name;
  final String? details;

  WholesaleProductTranslation({this.locale, this.name, this.details});

  factory WholesaleProductTranslation.fromJson(Map<String, dynamic> json) {
    return WholesaleProductTranslation(
      locale: json['locale']?.toString() ?? json['lang']?.toString(),
      name: json['name']?.toString() ?? json['value']?.toString(),
      details: json['details']?.toString() ?? json['description']?.toString(),
    );
  }
}

class WholesaleProductColor {
  final String? code;
  final String? name;

  WholesaleProductColor({this.code, this.name});

  factory WholesaleProductColor.fromJson(Map<String, dynamic> json) {
    return WholesaleProductColor(code: json['code']?.toString(), name: json['name']?.toString());
  }

  String get displayName => (name?.isNotEmpty ?? false) ? name! : (code ?? '');
}

class WholesaleChoiceOption {
  final String? name;
  final String? title;
  final List<String> options;

  WholesaleChoiceOption({this.name, this.title, this.options = const []});

  factory WholesaleChoiceOption.fromJson(Map<String, dynamic> json) {
    return WholesaleChoiceOption(
      name: json['name'],
      title: json['title'],
      options: _toStringList(json['options']),
    );
  }

  int? get attributeId => int.tryParse((name ?? '').replaceFirst('choice_', ''));

  String get joinedOptions => options.map((option) => option.trim()).where((option) => option.isNotEmpty).join(',');
}

class WholesaleStock {
  final int? id;
  final String? variant;
  final String? sku;
  final double? price;
  final double? qty;

  WholesaleStock({this.id, this.variant, this.sku, this.price, this.qty});

  factory WholesaleStock.fromJson(Map<String, dynamic> json) {
    return WholesaleStock(
      id: _toInt(json['id']),
      variant: json['variant'],
      sku: json['sku'],
      price: _toDouble(json['price']),
      qty: _toDouble(json['qty']),
    );
  }

  String get fieldKey => (variant ?? '').replaceAll('.', '_');
}

class WholesaleAttributeImage {
  final int? id;
  final String? attributeType;
  final int? attributeId;
  final String? attributeValue;
  final ImageFullUrl? imageFullUrl;
  final bool markAsAdditionalImage;
  final int? position;

  WholesaleAttributeImage({
    this.id,
    this.attributeType,
    this.attributeId,
    this.attributeValue,
    this.imageFullUrl,
    this.markAsAdditionalImage = false,
    this.position,
  });

  factory WholesaleAttributeImage.fromJson(Map<String, dynamic> json) {
    return WholesaleAttributeImage(
      id: _toInt(json['id']),
      attributeType: json['attribute_type'],
      attributeId: _toInt(json['attribute_id']),
      attributeValue: json['attribute_value'],
      imageFullUrl: json['image_full_url'] is Map<String, dynamic> ? ImageFullUrl.fromJson(json['image_full_url']) : null,
      markAsAdditionalImage: _toBool(json['mark_as_additional_image']),
      position: _toInt(json['position']),
    );
  }

  bool get isColor => attributeType == 'color';
}

class WholesaleDetail {
  final int? reorderLevel;
  final bool variationBasedPrice;
  final bool quantityBasedPrice;
  final String? variationType;
  final List<WholesalePriceRow> priceRows;

  WholesaleDetail({
    this.reorderLevel,
    this.variationBasedPrice = false,
    this.quantityBasedPrice = false,
    this.variationType,
    this.priceRows = const [],
  });

  factory WholesaleDetail.fromJson(Map<String, dynamic> json) {
    final dynamic priceSetup = json['price_setup'];

    return WholesaleDetail(
      reorderLevel: _toInt(json['reorder_level']),
      variationBasedPrice: _toBool(json['variation_based_price']),
      quantityBasedPrice: _toBool(json['quantity_based_price']),
      variationType: json['variation_type']?.toString(),
      priceRows: priceSetup is Map<String, dynamic> ? _mapList(priceSetup['rows'], WholesalePriceRow.fromJson) : const [],
    );
  }

  int? get variationTypeAttributeId => variationType == 'color' ? 0 : int.tryParse(variationType ?? '');

  List<double> get allUnitPrices => [
        for (final WholesalePriceRow row in priceRows) ...[
          if (row.unitPrice != null) row.unitPrice!,
          for (final WholesalePriceTier tier in row.tiers)
            if (tier.unitPrice != null) tier.unitPrice!,
        ],
      ];

  List<WholesalePriceTier> get tierLadder => priceRows.isEmpty ? const [] : priceRows.first.tiers;
}

class WholesalePriceRow {
  final String? variationValue;
  final double? unitPrice;
  final double? discount;
  final List<WholesalePriceTier> tiers;

  WholesalePriceRow({this.variationValue, this.unitPrice, this.discount, this.tiers = const []});

  factory WholesalePriceRow.fromJson(Map<String, dynamic> json) {
    return WholesalePriceRow(
      variationValue: json['variation_value']?.toString(),
      unitPrice: _toDouble(json['unit_price']),
      discount: _toDouble(json['discount']),
      tiers: _mapList(json['tiers'], WholesalePriceTier.fromJson),
    );
  }
}

class WholesalePriceTier {
  final int? minQty;
  final int? maxQty;
  final double? unitPrice;
  final double? discount;

  WholesalePriceTier({this.minQty, this.maxQty, this.unitPrice, this.discount});

  factory WholesalePriceTier.fromJson(Map<String, dynamic> json) {
    return WholesalePriceTier(
      minQty: _toInt(json['min_qty']),
      maxQty: _toInt(json['max_qty']),
      unitPrice: _toDouble(json['unit_price']),
      discount: _toDouble(json['discount']),
    );
  }

  bool get isOpenEnded => maxQty == null;
}

class WholesaleFaq {
  final int? id;
  final String? question;
  final String? answer;
  final int? priority;
  final bool status;
  final List<WholesaleFaqTranslation> translations;

  WholesaleFaq({this.id, this.question, this.answer, this.priority, this.status = false, this.translations = const []});

  factory WholesaleFaq.fromJson(Map<String, dynamic> json) {
    return WholesaleFaq(
      id: _toInt(json['id']),
      question: json['question'],
      answer: json['answer'],
      priority: _toInt(json['priority']),
      status: _toBool(json['status']),
      translations: _mapList(json['translations'], WholesaleFaqTranslation.fromJson),
    );
  }

  WholesaleFaqTranslation? translationFor(String? locale) {
    for (final WholesaleFaqTranslation translation in translations) {
      if (translation.locale == locale) return translation;
    }
    return null;
  }
}

class WholesaleFaqTranslation {
  final String? locale;
  final String? question;
  final String? answer;

  WholesaleFaqTranslation({this.locale, this.question, this.answer});

  factory WholesaleFaqTranslation.fromJson(Map<String, dynamic> json) {
    return WholesaleFaqTranslation(
      locale: json['locale']?.toString() ?? json['lang']?.toString(),
      question: json['question']?.toString(),
      answer: json['answer']?.toString(),
    );
  }
}

class WholesaleSeo {
  final String? title;
  final String? description;
  final ImageFullUrl? imageFullUrl;

  final String? index;
  final String? noFollow;
  final String? noArchive;
  final String? noImageIndex;
  final String? noSnippet;
  final String? maxSnippet;
  final int? maxSnippetValue;
  final String? maxVideoPreview;
  final int? maxVideoPreviewValue;
  final String? maxImagePreview;
  final String? maxImagePreviewValue;

  WholesaleSeo({
    this.title,
    this.description,
    this.imageFullUrl,
    this.index,
    this.noFollow,
    this.noArchive,
    this.noImageIndex,
    this.noSnippet,
    this.maxSnippet,
    this.maxSnippetValue,
    this.maxVideoPreview,
    this.maxVideoPreviewValue,
    this.maxImagePreview,
    this.maxImagePreviewValue,
  });

  factory WholesaleSeo.fromJson(Map<String, dynamic> json) {
    return WholesaleSeo(
      title: json['title'],
      description: json['description'],
      imageFullUrl: json['image_full_url'] is Map<String, dynamic> ? ImageFullUrl.fromJson(json['image_full_url']) : null,
      index: json['index']?.toString(),
      noFollow: json['no_follow']?.toString(),
      noArchive: json['no_archive']?.toString(),
      noImageIndex: json['no_image_index']?.toString(),
      noSnippet: json['no_snippet']?.toString(),
      maxSnippet: json['max_snippet']?.toString(),
      maxSnippetValue: _toInt(json['max_snippet_value']),
      maxVideoPreview: json['max_video_preview']?.toString(),
      maxVideoPreviewValue: _toInt(json['max_video_preview_value']),
      maxImagePreview: json['max_image_preview']?.toString(),
      maxImagePreviewValue: json['max_image_preview_value']?.toString(),
    );
  }

  bool get isIndexable => (index ?? '').isEmpty;
  bool get isNoFollow => _isFlagOn(noFollow);
  bool get isNoArchive => _isFlagOn(noArchive);
  bool get isNoImageIndex => _isFlagOn(noImageIndex);
  bool get isNoSnippet => _isFlagOn(noSnippet);
  bool get isMaxSnippet => _isFlagOn(maxSnippet);
  bool get isMaxVideoPreview => _isFlagOn(maxVideoPreview);
  bool get isMaxImagePreview => _isFlagOn(maxImagePreview);

  static bool _isFlagOn(String? value) {
    final String flag = (value ?? '').trim();
    return flag.isNotEmpty && flag != '0';
  }
}

int? _toInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  return int.tryParse(value.toString());
}

double? _toDouble(dynamic value) {
  if (value == null) {
    return null;
  }
  return double.tryParse(value.toString());
}

bool _toBool(dynamic value, {bool whenNull = false}) {
  if (value == null) {
    return whenNull;
  }
  if (value is bool) {
    return value;
  }
  final String text = value.toString().toLowerCase();
  return text == '1' || text == 'true' || text == 'on' || text == 'yes';
}

List<String> _toStringList(dynamic value) {
  if (value is! List) {
    return const [];
  }
  return value.map((item) => item?.toString()).whereType<String>().toList();
}

List<WholesaleProductColor> _toColorList(dynamic value) {
  if (value is! List) {
    return const [];
  }

  return value
      .map((item) {
        if (item is Map<String, dynamic>) {
          return WholesaleProductColor.fromJson(item);
        }
        return item == null ? null : WholesaleProductColor(code: item.toString());
      })
      .whereType<WholesaleProductColor>().toList();
}

List<int> _toIntList(dynamic value) {
  if (value is! List) {
    return const [];
  }
  return value.map(_toInt).whereType<int>().toList();
}

List<T> _mapList<T>(dynamic value, T Function(Map<String, dynamic>) fromJson) {
  if (value is! List) {
    return const [];
  }
  return value.whereType<Map<String, dynamic>>().map(fromJson).toList();
}
