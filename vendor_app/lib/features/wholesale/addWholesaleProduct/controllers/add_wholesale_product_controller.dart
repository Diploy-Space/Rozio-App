import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/add_product_image_controller.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/variation_controller.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/attribute_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/variant_type_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/brand/controllers/wholesale_brand_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatTax/controllers/wholesale_vat_tax_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/category/controllers/wholesale_category_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_general_setup_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_pricing_setup_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/add_wholesale_product_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_attribute_image_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_faq_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_faq_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_seo_section_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_gallery_image_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_meta_seo_info_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/quantity_price_tier_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/variation_image_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_product_detail_model.dart';
import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/services/add_wholesale_product_service_interface.dart';
import 'package:sixvalley_vendor_app/features/chat/domain/models/media_file_model.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/domain/models/config_model.dart';
import 'package:sixvalley_vendor_app/helper/product_helper.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

enum VideoUploadType { link, file }

class AddWholesaleProductController with ChangeNotifier {
  final AddWholesaleProductServiceInterface addWholesaleProductServiceInterface;
  AddWholesaleProductController({required this.addWholesaleProductServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<TextEditingController> _titleControllerList = [];
  List<TextEditingController> _descriptionControllerList = [];

  List<TextEditingController> get titleControllerList => _titleControllerList;
  List<TextEditingController> get descriptionControllerList => _descriptionControllerList;

  final TextEditingController productCode = TextEditingController();
  final TextEditingController shippingCostController = TextEditingController();
  final TextEditingController reOrderLevelController = TextEditingController();
  final TextEditingController totalQuantityController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController minimumOrderQuantityController = TextEditingController();

  XFile? _thumbnailImage;
  XFile? get thumbnailImage => _thumbnailImage;
  void setThumbnailImage(XFile? image) {
    final bool isMetaImageLinked = !_isFullyHydrated && (_metaImage == null || _metaImage == _thumbnailImage);
    _thumbnailImage = image;
    if (isMetaImageLinked) {
      _metaImage = image;
    }
    notifyListeners();
  }

  String? _existingThumbnailUrl;
  String? get existingThumbnailUrl => _existingThumbnailUrl;

  bool _isFullyHydrated = false;
  bool get isFullyHydrated => _isFullyHydrated;

  final List<XFile> _additionalImages = [];
  List<XFile> get additionalImages => _additionalImages;
  void addAdditionalImages(List<XFile> images) {
    _additionalImages.addAll(images);
    notifyListeners();
  }

  final List<ImageFullUrl> _existingGalleryImages = [];

  List<String> get existingGalleryKeys =>
      _existingGalleryImages.map((image) => image.key).whereType<String>().toList();

  List<WholesaleGalleryImage> get galleryImages {
    final List<WholesaleGalleryImage> images = [];

    for (int i = 0; i < _existingGalleryImages.length; i++) {
      images.add(WholesaleGalleryImage(
        storedKey: _existingGalleryImages[i].key,
        storedUrl: _existingGalleryImages[i].path,
        index: i,
      ));
    }

    for (int i = 0; i < _additionalImages.length; i++) {
      images.add(WholesaleGalleryImage(file: _additionalImages[i], index: i));
    }

    _variationImages.forEach((key, variationImages) {
      final int separator = key.indexOf('::');
      final int? attributeId = int.tryParse(key.substring(0, separator));
      final String value = key.substring(separator + 2);

      for (int i = 0; i < variationImages.length; i++) {
        if (variationImages[i].includeInAdditionalImages) {
          images.add(WholesaleGalleryImage(
            file: variationImages[i].file,
            index: i,
            attributeId: attributeId,
            value: value,
          ));
        }
      }
    });

    return images;
  }

  void removeGalleryImage(WholesaleGalleryImage image) {
    if (image.isFromVariation) {
      variationImagesFor(image.attributeId!, image.value!)[image.index].includeInAdditionalImages = false;
    } else if (image.isStored) {
      _existingGalleryImages.removeAt(image.index);
    } else {
      _additionalImages.removeAt(image.index);
    }
    notifyListeners();
  }

  int? _selectedImageAttributeId;
  int? get selectedImageAttributeId => _selectedImageAttributeId;
  void setSelectedImageAttributeId(int? attrId) {
    _selectedImageAttributeId = attrId;
    notifyListeners();
  }

  final Map<String, List<VariationImageModel>> _variationImages = {};

  List<VariationImageModel> variationImagesFor(int attributeId, String value) {
    return _variationImages.putIfAbsent('$attributeId::$value', () => []);
  }

  void addVariationImages(int attributeId, String value, List<XFile> files) {
    variationImagesFor(attributeId, value).addAll(files.map((XFile file) => VariationImageModel(file: file)));
    notifyListeners();
  }

  void removeVariationImage(int attributeId, String value, int index) {
    variationImagesFor(attributeId, value).removeAt(index);
    notifyListeners();
  }

  void toggleVariationImageIncludedInAdditionalImages(int attributeId, String value, int index) {
    final VariationImageModel image = variationImagesFor(attributeId, value)[index];
    image.includeInAdditionalImages = !image.includeInAdditionalImages;
    notifyListeners();
  }

  final TextEditingController videoLinkController = TextEditingController();

  VideoUploadType _videoUploadType = VideoUploadType.link;
  VideoUploadType get videoUploadType => _videoUploadType;
  void setVideoUploadType(VideoUploadType type) {
    _videoUploadType = type;
    notifyListeners();
  }

  MediaFileModel? _pickedVideoFile;
  MediaFileModel? get pickedVideoFile => _pickedVideoFile;

  bool _isPickingVideo = false;
  bool get isPickingVideo => _isPickingVideo;

  String? _existingVideoUrl;
  String? get existingVideoUrl => _existingVideoUrl;

  String? _existingVideoThumbnailPath;
  String? get existingVideoThumbnailPath => _existingVideoThumbnailPath;

  void removeVideoFile() {
    _pickedVideoFile = null;
    _existingVideoUrl = null;
    _existingVideoThumbnailPath = null;
    notifyListeners();
  }

  Future<void> _loadExistingVideoThumbnail(String videoUrl) async {
    try {
      final String? thumbnailPath = await _generateVideoThumbnail(videoUrl);
      if (_existingVideoUrl == videoUrl) {
        _existingVideoThumbnailPath = thumbnailPath;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> pickVideoFile(BuildContext context) async {
    _isPickingVideo = true;
    notifyListeners();

    final PlatformFile? result = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: AppConstants.videoExtensions,
    );

    if (result == null) {
      _isPickingVideo = false;
      notifyListeners();
      return;
    }

    final PlatformFile file = result;
    final String extension = file.extension?.toLowerCase() ?? '';
    if (!AppConstants.videoExtensions.contains(extension)) {
      if (context.mounted) {
        showCustomSnackBarWidget(getTranslated('invalid_file_type', context), context, sanckBarType: SnackBarType.error);
      }
      _isPickingVideo = false;
      notifyListeners();
      return;
    }

    final double fileSizeMB = (await file.length()) / (1024 * 1024);
    final double maxSizeMB = (context.mounted ? Provider.of<SplashController>(context, listen: false).configModel?.systemGeneralFileUploadMaxSize : null)?.toDouble() ?? AppConstants.maxSizeOfASingleFile;
    if (fileSizeMB > maxSizeMB) {
      if (context.mounted) {
        showCustomSnackBarWidget('${getTranslated('maximum_file_size', context)} ${maxSizeMB}MB', context, sanckBarType: SnackBarType.warning);
      }
      _isPickingVideo = false;
      notifyListeners();
      return;
    }

    final String? thumbnailPath = await _generateVideoThumbnail(file.path ?? '');
    _pickedVideoFile = MediaFileModel(file: file.xFile, thumbnailPath: thumbnailPath, isVideo: true);
    _existingVideoUrl = null;
    _existingVideoThumbnailPath = null;
    _isPickingVideo = false;
    notifyListeners();
  }

  Future<String?> _generateVideoThumbnail(String filePath) async {
    final Directory directory = await getTemporaryDirectory();
    final XFile thumbnail = await VideoThumbnail.thumbnailFile(
      video: filePath,
      thumbnailPath: directory.path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 100,
      maxWidth: 200,
      quality: 1,
    );
    return thumbnail.path;
  }

  String? _unitValue;
  String? get unitValue => _unitValue;
  void setValueForUnit(String? value) {
    _unitValue = value;
    notifyListeners();
  }

  bool _isMultiply = false;
  bool get isMultiply => _isMultiply;
  void toggleMultiply() {
    _isMultiply = !_isMultiply;
    notifyListeners();
  }

  List<String> _tagList = [];
  List<String> get tagList => _tagList;
  int _tagListVersion = 0;
  int get tagListVersion => _tagListVersion;
  void setTagList(List<String> tags) {
    _tagList = tags;
    notifyListeners();
  }

  bool _isAttributeActive = false;
  bool get isAttributeActive => _isAttributeActive;
  void setIsAttributeActive(bool isActive) {
    _isAttributeActive = isActive;
    notifyListeners();
  }

  bool _isDiscountAmount = true;
  bool get isDiscountAmount => _isDiscountAmount;
  void setIsDiscountAmount(bool isAmount) {
    _isDiscountAmount = isAmount;
    notifyListeners();
  }

  bool _isVariationBasePricing = true;
  bool get isVariationBasePricing => _isVariationBasePricing;
  void setIsVariationBasePricing(bool isSelected) {
    _isVariationBasePricing = isSelected;
    notifyListeners();
  }

  bool _isQuantityBasePricing = false;
  bool get isQuantityBasePricing => _isQuantityBasePricing;
  void setIsQuantityBasePricing(bool isSelected) {
    _isQuantityBasePricing = isSelected;
    notifyListeners();
  }

  int? _selectedVariationTypeAttrId;
  int? get selectedVariationTypeAttrId => _selectedVariationTypeAttrId;
  void setSelectedVariationTypeAttrId(int? attrId) {
    _selectedVariationTypeAttrId = attrId;
    notifyListeners();
  }

  final Map<String, TextEditingController> _variationPriceControllers = {};
  final Map<String, TextEditingController> _variationDiscountControllers = {};

  TextEditingController variationPriceController(String variant) {
    return _variationPriceControllers.putIfAbsent(variant, () => TextEditingController());
  }

  TextEditingController variationDiscountController(String variant) {
    return _variationDiscountControllers.putIfAbsent(variant, () => TextEditingController());
  }

  final Map<String, TextEditingController> _variationTierPriceControllers = {};
  final Map<String, TextEditingController> _variationTierDiscountControllers = {};

  TextEditingController variationTierPriceController(String variant, int tierIndex) {
    return _variationTierPriceControllers.putIfAbsent('$variant::$tierIndex', () => TextEditingController());
  }

  TextEditingController variationTierDiscountController(String variant, int tierIndex) {
    return _variationTierDiscountControllers.putIfAbsent('$variant::$tierIndex', () => TextEditingController());
  }

  final Map<String, TextEditingController> _variantSkuControllers = {};

  TextEditingController variantSkuController(String variantType) {
    return _variantSkuControllers.putIfAbsent(
      variantType,
      () => TextEditingController(text: generateVariantSku(variantType)),
    );
  }

  static String generateVariantSku(String variantType) => 'SKU-$variantType';

  final List<QuantityPriceTierModel> _quantityPriceTiers = [QuantityPriceTierModel()];
  List<QuantityPriceTierModel> get quantityPriceTiers => _quantityPriceTiers;

  void addQuantityPriceTier() {
    final int? previousMaxQty = int.tryParse(_quantityPriceTiers.last.maxQtyController.text.trim());
    final tier = QuantityPriceTierModel();
    if (previousMaxQty != null) {
      tier.minQtyController.text = (previousMaxQty + 1).toString();
    }
    _quantityPriceTiers.add(tier);
    notifyListeners();
  }

  void refreshQuantityPriceTiers() {
    notifyListeners();
  }

  void removeQuantityPriceTier(int index) {
    if (_quantityPriceTiers.length <= 1) {
      return;
    }
    _quantityPriceTiers.removeAt(index).dispose();
    _disposeTierControllers(_variationTierPriceControllers, index);
    _disposeTierControllers(_variationTierDiscountControllers, index);

    notifyListeners();
  }

  void _disposeTierControllers(Map<String, TextEditingController> controllers, int tierIndex) {
    final List<String> staleKeys = controllers.keys.where((key) => key.endsWith('::$tierIndex')).toList();
    for (final String key in staleKeys) {
      controllers.remove(key)?.dispose();
    }
  }

  @override
  void dispose() {
    productCode.dispose();
    shippingCostController.dispose();
    reOrderLevelController.dispose();
    totalQuantityController.dispose();
    discountController.dispose();
    minimumOrderQuantityController.dispose();
    videoLinkController.dispose();
    for (TextEditingController controller in _variationPriceControllers.values) {
      controller.dispose();
    }
    for (TextEditingController controller in _variationDiscountControllers.values) {
      controller.dispose();
    }
    for (TextEditingController controller in _variationTierPriceControllers.values) {
      controller.dispose();
    }
    for (TextEditingController controller in _variationTierDiscountControllers.values) {
      controller.dispose();
    }
    for (TextEditingController controller in _variantSkuControllers.values) {
      controller.dispose();
    }
    for (QuantityPriceTierModel tier in _quantityPriceTiers) {
      tier.dispose();
    }
    for (TextEditingController controller in _faqQuestionControllerList) {
      controller.dispose();
    }
    for (TextEditingController controller in _faqAnswerControllerList) {
      controller.dispose();
    }
    for (TextEditingController controller in _metaTitleControllerList) {
      controller.dispose();
    }
    for (TextEditingController controller in _metaDescriptionControllerList) {
      controller.dispose();
    }
    maxSnippetValueController.dispose();
    maxVideoPreviewValueController.dispose();
    super.dispose();
  }

  void resetForm(BuildContext context) {
    for (final TextEditingController controller in _titleControllerList) {
      controller.clear();
    }
    for (final TextEditingController controller in _descriptionControllerList) {
      controller.clear();
    }
    for (final TextEditingController controller in _faqQuestionControllerList) {
      controller.clear();
    }
    for (final TextEditingController controller in _faqAnswerControllerList) {
      controller.clear();
    }
    for (final TextEditingController controller in _metaTitleControllerList) {
      controller.clear();
    }
    for (final TextEditingController controller in _metaDescriptionControllerList) {
      controller.clear();
    }

    productCode.clear();
    shippingCostController.clear();
    reOrderLevelController.clear();
    totalQuantityController.clear();
    discountController.clear();
    minimumOrderQuantityController.clear();
    videoLinkController.clear();
    maxSnippetValueController.clear();
    maxVideoPreviewValueController.clear();

    _disposeControllerMap(_variationPriceControllers);
    _disposeControllerMap(_variationDiscountControllers);
    _disposeControllerMap(_variationTierPriceControllers);
    _disposeControllerMap(_variationTierDiscountControllers);
    _disposeControllerMap(_variantSkuControllers);

    for (final QuantityPriceTierModel tier in _quantityPriceTiers) {
      tier.dispose();
    }
    _quantityPriceTiers
      ..clear()
      ..add(QuantityPriceTierModel());

    _thumbnailImage = null;
    _existingThumbnailUrl = null;
    _isFullyHydrated = false;
    _existingGalleryImages.clear();
    _additionalImages.clear();
    _variationImages.clear();
    _selectedImageAttributeId = null;
    _pickedVideoFile = null;
    _existingVideoUrl = null;
    _existingVideoThumbnailPath = null;
    _videoUploadType = VideoUploadType.link;
    _metaImage = null;

    _unitValue = null;
    _isMultiply = false;
    _tagList = [];
    _tagListVersion++;
    _isAttributeActive = false;
    _isDiscountAmount = true;
    _isVariationBasePricing = true;
    _isQuantityBasePricing = false;
    _selectedVariationTypeAttrId = null;

    _faqList.clear();
    _faqPriority = null;
    _editingFaqIndex = null;

    _metaSeoInfo
      ..metaIndex = 'index'
      ..metaNoFollow = 'follow'
      ..metaNoImageIndex = '0'
      ..metaNoArchive = '0'
      ..metaNoSnippet = '0'
      ..metaMaxSnippet = '0'
      ..metaMaxSnippetValue = null
      ..metaMaxVideoPreview = '0'
      ..metaMaxVideoPreviewValue = null
      ..metaMaxImagePreview = '0'
      ..metaMaxImagePreviewValue = 'large';

    Provider.of<WholesaleCategoryController>(context, listen: false).resetSelection(notify: false);
    Provider.of<WholesaleBrandController>(context, listen: false).reset(notify: false);
    Provider.of<WholesaleVatTaxController>(context, listen: false).clearSelection(notify: false);
    Provider.of<AddProductImageController>(context, listen: false).removeProductImage();

    final VariationController variationController = Provider.of<VariationController>(context, listen: false);
    variationController.setAttributeList(
      (variationController.attributeList ?? <AttributeModel>[]).where((attribute) => attribute.attribute.id != 0).map((attribute) => attribute.attribute).toList(),
    );

    variationController.initColorCode();

    notifyListeners();
  }

  bool _isDetailLoading = false;
  bool get isDetailLoading => _isDetailLoading;

  Future<bool> loadProductForEdit(BuildContext context, int productId) async {
    _isDetailLoading = true;
    notifyListeners();

    final ApiResponse apiResponse = await addWholesaleProductServiceInterface.getProductDetail(productId);

    bool isLoaded = false;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final dynamic data = apiResponse.response!.data is Map<String, dynamic> ? apiResponse.response!.data['data'] : null;

      if (data is Map<String, dynamic> && context.mounted) {
        await hydrateFromDetail(context, WholesaleProductDetailModel.fromJson(data));
        isLoaded = true;
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isDetailLoading = false;
    notifyListeners();

    return isLoaded;
  }

  Future<void> applyAiGeneralSetup(BuildContext context, WholesaleAiGeneralSetupModel setup) async {

    final SplashController splashController = Provider.of<SplashController>(context, listen: false);
    final WholesaleBrandController brandController = Provider.of<WholesaleBrandController>(context, listen: false);
    final WholesaleCategoryController categoryController = Provider.of<WholesaleCategoryController>(context, listen: false);

    final List<String> units = splashController.configModel?.unit ?? [];
    if (setup.unitName != null && units.contains(setup.unitName)) {
      _unitValue = setup.unitName;
    }

    if (setup.sku != null && setup.sku!.trim().isNotEmpty) {
      productCode.text = setup.sku!.trim();
    }

    if (setup.reorderLevel != null) {
      reOrderLevelController.text = setup.reorderLevel!.toString();
    }
    if (setup.shippingCost != null) {
      shippingCostController.text = _numberText(setup.shippingCost);
    }

    if (setup.brandId != null) {
      brandController.setSelectedBrandId(setup.brandId);
    }

    notifyListeners();

    await categoryController.getCategoryList();

    if (setup.categoryId != null) {
      await categoryController.onSelectCategory(setup.categoryId);

      if (setup.subCategoryId != null) {
        await categoryController.onSelectSubCategory(setup.subCategoryId);

        if (setup.subSubCategoryId != null) {
          categoryController.onSelectSubSubCategory(setup.subSubCategoryId);
        }
      }
    }
  }

  Future<void> applyAiPricingSetup(BuildContext context, WholesaleAiPricingSetupModel pricing) async {
    final WholesaleVatTaxController vatTaxController = Provider.of<WholesaleVatTaxController>(context, listen: false);

    if (pricing.priceSetup != null) {
      _isQuantityBasePricing = pricing.isQuantityBased;
      _isVariationBasePricing = pricing.isVariationBased;
    }

    if (pricing.minimumOrderQty != null) {
      minimumOrderQuantityController.text = pricing.minimumOrderQty!.toString();
    }

    if (!_isVariationBasePricing) {
      if (pricing.discount != null) {
        discountController.text = _numberText(pricing.discount);
      }
      if (pricing.discountType != null) {
        _isDiscountAmount = pricing.discountType != 'percent';
      }
    }

    if (pricing.tiers.isNotEmpty) {
      for (final QuantityPriceTierModel tier in _quantityPriceTiers) {
        tier.dispose();
      }
      _quantityPriceTiers.clear();

      for (final WholesaleAiPriceTier tier in pricing.tiers) {
        final QuantityPriceTierModel model = QuantityPriceTierModel();
        model.minQtyController.text = tier.minQty?.toString() ?? '';
        model.maxQtyController.text = tier.maxQty?.toString() ?? '';

        if (!_isVariationBasePricing) {
          model.unitPriceController.text = _numberText(tier.unitPrice);
        }

        _quantityPriceTiers.add(model);
      }
    }

    notifyListeners();

    await vatTaxController.getVatTaxSetup();
    vatTaxController.selectTaxesByIds(pricing.taxIds);
  }

  Future<void> hydrateFromDetail(BuildContext context, WholesaleProductDetailModel detail) async {
    final SplashController splashController = Provider.of<SplashController>(context, listen: false);
    final List<Language> languageList = splashController.configModel?.languageList ?? [];

    initTitleAndDescriptionControllers(languageList);
    initMetaSeoControllers(languageList);

    if (_titleControllerList.isNotEmpty) {
      _titleControllerList[0].text = detail.name ?? '';
    }
    if (_descriptionControllerList.isNotEmpty) {
      _descriptionControllerList[0].text = ProductHelper.htmlToPlainText(detail.details ?? '');
    }

    for (final WholesaleProductTranslation translation in detail.translations) {
      final int index = languageList.indexWhere((language) => language.code == translation.locale);

      if (index > 0 && index < _titleControllerList.length) {
        _titleControllerList[index].text = translation.name ?? '';
        _descriptionControllerList[index].text = ProductHelper.htmlToPlainText(translation.details ?? '');
      }
    }

    productCode.text = detail.code ?? '';

    final List<String> units = splashController.configModel?.unit ?? [];
    _unitValue = units.contains(detail.unit) ? detail.unit : null;

    _tagList = List<String>.from(detail.tags);
    _tagListVersion++;
    _isMultiply = detail.multiplyQty;

    minimumOrderQuantityController.text = detail.minimumOrderQty?.toString() ?? '';
    totalQuantityController.text = detail.currentStock?.toString() ?? '';
    reOrderLevelController.text = detail.wholesaleDetail?.reorderLevel?.toString() ?? '';

    shippingCostController.text = _numberText(detail.shippingCost);

    discountController.text = _numberText(detail.discount);
    _isDiscountAmount = detail.discountType != 'percent';

    _hydrateVariation(context, detail);
    _hydratePricing(detail);
    _hydrateMedia(detail);
    _hydrateFaq(detail, languageList);
    _hydrateSeo(detail);

    notifyListeners();

    if (!context.mounted) {
      return;
    }

    final WholesaleVatTaxController vatTaxController = Provider.of<WholesaleVatTaxController>(context, listen: false);
    final WholesaleBrandController brandController = Provider.of<WholesaleBrandController>(context, listen: false);
    final WholesaleCategoryController categoryController = Provider.of<WholesaleCategoryController>(context, listen: false);

    brandController.setSelectedBrandId(detail.brandId);

    await vatTaxController.getVatTaxSetup();
    vatTaxController.selectTaxesByIds(detail.taxIds);

    await categoryController.getCategoryList();

    if (detail.categoryId != null) {
      await categoryController.onSelectCategory(detail.categoryId);

      if (detail.subCategoryId != null) {
        await categoryController.onSelectSubCategory(detail.subCategoryId);

        if (detail.subSubCategoryId != null) {
          categoryController.onSelectSubSubCategory(detail.subSubCategoryId);
        }
      }
    }

    _isFullyHydrated = true;
    notifyListeners();
  }

  void _hydrateVariation(BuildContext context, WholesaleProductDetailModel detail) {
    final VariationController variationController = Provider.of<VariationController>(context, listen: false);
    final List<AttributeModel> attributes = variationController.attributeList ?? <AttributeModel>[];

    if (attributes.isEmpty) {
      return;
    }

    if (detail.hasColors) {
      attributes[0].active = true;
      attributes[0].variants.clear();
      variationController.initColorCode();

      for (final WholesaleProductColor color in detail.colors) {
        variationController.addVariant(context, 0, color.displayName, null, false);
        variationController.addColorCode(color.code);
      }
    }

    for (final WholesaleChoiceOption option in detail.choiceOptions) {
      final int index = attributes.indexWhere((attribute) => attribute.attribute.id == option.attributeId);
      if (index == -1) {
        continue;
      }

      attributes[index].active = true;
      attributes[index].variants.clear();

      for (final String value in option.options) {
        final String trimmed = value.trim();
        if (trimmed.isNotEmpty) {
          variationController.addVariant(context, index, trimmed, null, false);
        }
      }
    }

    _isAttributeActive = detail.hasVariation;
    variationController.generateVariantTypes(context, null);

    final Map<String, WholesaleStock> stockByKey = {
      for (final WholesaleStock stock in detail.stocks) stock.fieldKey: stock,
    };

    for (final VariantTypeModel variant in variationController.variantTypeList) {
      final String key = wholesaleVariantKey(variant.variantType, colorsActive: detail.hasColors);
      final WholesaleStock? stock = stockByKey[key];

      variant.qtyController.text = (stock?.qty ?? 0).toInt().toString();
      variantSkuController(variant.variantType).text = stock?.sku ?? generateVariantSku(variant.variantType);
    }

    variationController.calculateVariationQuantity();
  }

  Map<String, String> _colorNamesByCode() {
    final Map<String, String> names = {};
    for (final ColorList color in Provider.of<SplashController>(Get.context!, listen: false).colorList ?? <ColorList>[]) {
      if (color.code != null && color.name != null) {
        names[color.code!.toLowerCase()] = color.name!;
      }
    }
    return names;
  }

  void _hydratePricing(WholesaleProductDetailModel detail) {
    final WholesaleDetail? wholesaleDetail = detail.wholesaleDetail;
    if (wholesaleDetail == null) {
      return;
    }

    _isVariationBasePricing = wholesaleDetail.variationBasedPrice;
    _isQuantityBasePricing = wholesaleDetail.quantityBasedPrice;
    _selectedVariationTypeAttrId = wholesaleDetail.variationTypeAttributeId;

    final List<WholesalePriceRow> rows = wholesaleDetail.priceRows;

    if (_isQuantityBasePricing && wholesaleDetail.tierLadder.isNotEmpty) {
      for (final QuantityPriceTierModel tier in _quantityPriceTiers) {
        tier.dispose();
      }
      _quantityPriceTiers.clear();

      for (final WholesalePriceTier tier in wholesaleDetail.tierLadder) {
        final QuantityPriceTierModel model = QuantityPriceTierModel();
        model.minQtyController.text = tier.minQty?.toString() ?? '';
        model.maxQtyController.text = tier.maxQty?.toString() ?? '';

        if (!_isVariationBasePricing) {
          model.unitPriceController.text = _numberText(tier.unitPrice);
        }

        _quantityPriceTiers.add(model);
      }
    }

    for (final WholesalePriceRow row in rows) {
      final String? value = row.variationValue;
      if (value == null) {
        continue;
      }

      if (_isVariationBasePricing && !_isQuantityBasePricing) {
        variationPriceController(value).text = _numberText(row.unitPrice);
        variationDiscountController(value).text = _numberText(row.discount);
      } else if (_isVariationBasePricing && _isQuantityBasePricing) {
        for (int tierIndex = 0; tierIndex < row.tiers.length; tierIndex++) {
          variationTierPriceController(value, tierIndex).text = _numberText(row.tiers[tierIndex].unitPrice);
          variationTierDiscountController(value, tierIndex).text = _numberText(row.tiers[tierIndex].discount);
        }
      }
    }
  }

  void _hydrateMedia(WholesaleProductDetailModel detail) {
    _existingThumbnailUrl = detail.thumbnailFullUrl?.path;

    final Set<String> keysToKeep = detail.galleryKeysToKeep.toSet();
    _existingGalleryImages
      ..clear()
      ..addAll(detail.imagesFullUrl.where((image) => keysToKeep.contains(image.key)));

    if (detail.hasVideoFile) {
      _videoUploadType = VideoUploadType.file;
      videoLinkController.clear();
      _existingVideoUrl = (detail.videoFileFullUrl?.isNotEmpty ?? false) ? detail.videoFileFullUrl : null;
      _existingVideoThumbnailPath = null;
      if (_existingVideoUrl != null) {
        _loadExistingVideoThumbnail(_existingVideoUrl!);
      }
    } else {
      _videoUploadType = VideoUploadType.link;
      videoLinkController.text = detail.videoUrl ?? '';
    }

    final Map<String, String> colorNames = _colorNamesByCode();
    final List<WholesaleAttributeImage> ordered = [...detail.attributeImages]
      ..sort((a, b) => (a.position ?? 0).compareTo(b.position ?? 0));

    for (final WholesaleAttributeImage image in ordered) {
      final String? storedKey = image.imageFullUrl?.key;
      final String? value = image.attributeValue;
      if (storedKey == null || value == null) {
        continue;
      }

      final String key = image.isColor
          ? '0::${colorNames[value.toLowerCase()] ?? value}' : '${image.attributeId}::$value';

      _variationImages.putIfAbsent(key, () => []).add(VariationImageModel(
            storedKey: storedKey,
            storedUrl: image.imageFullUrl?.path,
            includeInAdditionalImages: image.markAsAdditionalImage,
          ));
    }
  }

  void _hydrateFaq(WholesaleProductDetailModel detail, List<Language> languageList) {
    _faqList.clear();

    final int slots = languageList.isNotEmpty ? languageList.length : 1;
    for (final WholesaleFaq faq in detail.faqs) {
      String textFor(int index, {required bool isQuestion}) {
        final WholesaleFaqTranslation? translation = index < languageList.length ? faq.translationFor(languageList[index].code) : null;
        final String? translated = isQuestion ? translation?.question : translation?.answer;
        if (translated != null && translated.isNotEmpty) return translated;
        return index == 0 ? ((isQuestion ? faq.question : faq.answer) ?? '') : '';
      }

      _faqList.add(WholesaleFaqModel(
        questionList: List<String>.generate(slots, (index) => textFor(index, isQuestion: true)),
        answerList: List<String>.generate(slots, (index) => textFor(index, isQuestion: false)),
        priority: faq.priority ?? 1,
      ));
    }
  }

  void _hydrateSeo(WholesaleProductDetailModel detail) {
    final WholesaleSeo? seo = detail.seo;

    if (_metaTitleControllerList.isNotEmpty) {
      _metaTitleControllerList[0].text = seo?.title ?? '';
    }
    if (_metaDescriptionControllerList.isNotEmpty) {
      _metaDescriptionControllerList[0].text = seo?.description ?? '';
    }

    _metaSeoInfo
      ..metaIndex = (seo?.isIndexable ?? true) ? 'index' : 'noindex'
      ..metaNoFollow = (seo?.isNoFollow ?? false) ? 'nofollow' : 'follow'
      ..metaNoArchive = (seo?.isNoArchive ?? false) ? '1' : '0'
      ..metaNoImageIndex = (seo?.isNoImageIndex ?? false) ? '1' : '0'
      ..metaNoSnippet = (seo?.isNoSnippet ?? false) ? '1' : '0'
      ..metaMaxSnippet = (seo?.isMaxSnippet ?? false) ? '1' : '0'
      ..metaMaxSnippetValue = seo?.maxSnippetValue?.toString()
      ..metaMaxVideoPreview = (seo?.isMaxVideoPreview ?? false) ? '1' : '0'
      ..metaMaxVideoPreviewValue = seo?.maxVideoPreviewValue?.toString()
      ..metaMaxImagePreview = (seo?.isMaxImagePreview ?? false) ? '1' : '0'

      ..metaMaxImagePreviewValue = imagePreviewTypeList.contains(seo?.maxImagePreviewValue)
          ? seo!.maxImagePreviewValue! : 'large';

    maxSnippetValueController.text = seo?.maxSnippetValue?.toString() ?? '';
    maxVideoPreviewValueController.text = seo?.maxVideoPreviewValue?.toString() ?? '';
  }

  String _numberText(num? value) {
    if (value == null) {
      return '';
    }
    return value == value.roundToDouble() ? value.toInt().toString() : value.toString();
  }

  void _disposeControllerMap(Map<String, TextEditingController> controllers) {
    for (final TextEditingController controller in controllers.values) {
      controller.dispose();
    }
    controllers.clear();
  }

  void initTitleAndDescriptionControllers(List<Language> languageList) {
    if (_titleControllerList.length == languageList.length) {
      return;
    }

    _titleControllerList = [];
    _descriptionControllerList = [];
    for (int i = 0; i < languageList.length; i++) {
      _titleControllerList.add(TextEditingController());
      _descriptionControllerList.add(TextEditingController());
    }
  }

  void setTitle(int index, String title) {
    _titleControllerList[index].text = title;
    notifyListeners();
  }

  void setDescription(int index, String description) {
    _descriptionControllerList[index].text = description;
    notifyListeners();
  }

  bool validateGeneralInfo(BuildContext context) {
    if (titleControllerList.isEmpty || titleControllerList[0].text.trim().isEmpty) {
      showCustomSnackBarWidget(getTranslated('product_name_required', context), context, sanckBarType: SnackBarType.warning);
      return false;
    }

    for (final TextEditingController titleController in titleControllerList) {
      final String name = titleController.text.trim();
      if (name.isEmpty) {
        continue;
      }
      if (name.length < 3) {
        showCustomSnackBarWidget(getTranslated('product_name_min_length', context), context, sanckBarType: SnackBarType.warning);
        return false;
      }
      if (name.length > 255) {
        showCustomSnackBarWidget(getTranslated('product_name_max_length', context), context, sanckBarType: SnackBarType.warning);
        return false;
      }
      if (RegExp(r'^\d+$').hasMatch(name)) {
        showCustomSnackBarWidget(getTranslated('product_name_cannot_be_only_numbers', context), context, sanckBarType: SnackBarType.warning);
        return false;
      }
    }

    if (descriptionControllerList.isEmpty || descriptionControllerList[0].text.trim().isEmpty) {
      showCustomSnackBarWidget(getTranslated('product_description_required', context), context, sanckBarType: SnackBarType.warning);
      return false;
    }

    return true;
  }

  AddWholesaleProductModel getGeneralInfoData(List<Language> languageList) {
    return AddWholesaleProductModel(
      titleList: _titleControllerList.map((controller) => controller.text.trim()).toList(),
      descriptionList: _descriptionControllerList.map((controller) => controller.text.trim()).toList(),
      languageList: languageList.map((language) => language.code).toList(),
    );
  }

  List<TextEditingController> _faqQuestionControllerList = [];
  List<TextEditingController> _faqAnswerControllerList = [];
  List<TextEditingController> get faqQuestionControllerList => _faqQuestionControllerList;
  List<TextEditingController> get faqAnswerControllerList => _faqAnswerControllerList;

  void initFaqControllers(List<Language> languageList) {
    if (_faqQuestionControllerList.length == languageList.length) {
      return;
    }

    _faqQuestionControllerList = [];
    _faqAnswerControllerList = [];
    for (int i = 0; i < languageList.length; i++) {
      _faqQuestionControllerList.add(TextEditingController());
      _faqAnswerControllerList.add(TextEditingController());
    }
  }

  int? _faqPriority;
  int? get faqPriority => _faqPriority;
  void setFaqPriority(int? priority) {
    _faqPriority = priority;
    notifyListeners();
  }

  List<int> get faqPriorityList => List.generate(10, (index) => index + 1);

  final List<WholesaleFaqModel> _faqList = [];
  List<WholesaleFaqModel> get faqList => _faqList;

  int? _editingFaqIndex;
  int? get editingFaqIndex => _editingFaqIndex;

  bool validateFaqForm(BuildContext context, {String? firstLanguageName}) {
    final String languageSuffix = (firstLanguageName?.isNotEmpty ?? false) ? ' ($firstLanguageName)' : '';

    if (_faqQuestionControllerList.isEmpty || _faqQuestionControllerList[0].text.trim().isEmpty) {
      showCustomSnackBarWidget('${getTranslated('question_is_required', context)}$languageSuffix', context, sanckBarType: SnackBarType.warning);
      return false;
    }

    if (_faqAnswerControllerList.isEmpty || _faqAnswerControllerList[0].text.trim().isEmpty) {
      showCustomSnackBarWidget('${getTranslated('answer_is_required', context)}$languageSuffix', context, sanckBarType: SnackBarType.warning);
      return false;
    }

    if (_faqPriority == null) {
      showCustomSnackBarWidget(getTranslated('please_select_priority', context), context, sanckBarType: SnackBarType.warning);
      return false;
    }

    return true;
  }

  bool saveFaq(BuildContext context, {String? firstLanguageName}) {
    if (!validateFaqForm(context, firstLanguageName: firstLanguageName)) {
      return false;
    }

    final WholesaleFaqModel faq = WholesaleFaqModel(
      questionList: _faqQuestionControllerList.map((controller) => controller.text.trim()).toList(),
      answerList: _faqAnswerControllerList.map((controller) => controller.text.trim()).toList(),
      priority: _faqPriority!,
    );

    if (_editingFaqIndex != null) {
      _faqList[_editingFaqIndex!] = faq;
    } else {
      _faqList.add(faq);
    }

    resetFaqForm();
    return true;
  }

  void resetFaqForm() {
    for (TextEditingController controller in _faqQuestionControllerList) {
      controller.clear();
    }
    for (TextEditingController controller in _faqAnswerControllerList) {
      controller.clear();
    }
    _faqPriority = null;
    _editingFaqIndex = null;
    notifyListeners();
  }

  void editFaq(int index) {
    final WholesaleFaqModel faq = _faqList[index];
    for (int i = 0; i < _faqQuestionControllerList.length; i++) {
      _faqQuestionControllerList[i].text = i < faq.questionList.length ? faq.questionList[i] : '';
      _faqAnswerControllerList[i].text = i < faq.answerList.length ? faq.answerList[i] : '';
    }
    _faqPriority = faq.priority;
    _editingFaqIndex = index;
    notifyListeners();
  }

  void removeFaq(int index) {
    _faqList.removeAt(index);
    if (_editingFaqIndex == index) {
      resetFaqForm();
    } else {
      notifyListeners();
    }
  }

  bool fillFaqFormFromAi(int languageIndex, WholesaleAiFaqModel generated) {
    if (generated.faqs.isEmpty || languageIndex >= _faqQuestionControllerList.length) {
      return false;
    }

    final WholesaleAiFaq faq = generated.faqs.first;
    _faqQuestionControllerList[languageIndex].text = faq.question;
    _faqAnswerControllerList[languageIndex].text = faq.answer;
    if (faq.priority != null && faqPriorityList.contains(faq.priority)) {
      _faqPriority = faq.priority;
    }

    notifyListeners();
    return true;
  }

  void applyAiSeoSection(WholesaleAiSeoSectionModel seo, {required int languageIndex}) {
    if (languageIndex < _metaTitleControllerList.length && (seo.metaTitle?.isNotEmpty ?? false)) {
      _metaTitleControllerList[languageIndex].text = seo.metaTitle!;
    }
    if (languageIndex < _metaDescriptionControllerList.length && (seo.metaDescription?.isNotEmpty ?? false)) {
      _metaDescriptionControllerList[languageIndex].text = seo.metaDescription!;
    }

    if (seo.metaIndex == 'index' || seo.metaIndex == 'noindex') {
      _metaSeoInfo.metaIndex = seo.metaIndex!;
    }
    if (seo.metaNoFollow != null) {
      _metaSeoInfo.metaNoFollow = seo.metaNoFollow! ? 'nofollow' : 'follow';
    }
    if (seo.metaNoImageIndex != null) {
      _metaSeoInfo.metaNoImageIndex = seo.metaNoImageIndex! ? '1' : '0';
    }
    if (seo.metaNoArchive != null) {
      _metaSeoInfo.metaNoArchive = seo.metaNoArchive! ? '1' : '0';
    }
    if (seo.metaNoSnippet != null) {
      _metaSeoInfo.metaNoSnippet = seo.metaNoSnippet! ? '1' : '0';
    }

    if (seo.metaMaxSnippet != null) {
      _metaSeoInfo.metaMaxSnippet = seo.metaMaxSnippet! ? '1' : '0';
    }
    if (seo.metaMaxSnippetValue != null) {
      _applyAiMaxValue(seo.metaMaxSnippetValue!, maxSnippetValueController, (String? value) => _metaSeoInfo.metaMaxSnippetValue = value);
    }

    if (seo.metaMaxVideoPreview != null) {
      _metaSeoInfo.metaMaxVideoPreview = seo.metaMaxVideoPreview! ? '1' : '0';
    }
    if (seo.metaMaxVideoPreviewValue != null) {
      _applyAiMaxValue(seo.metaMaxVideoPreviewValue!, maxVideoPreviewValueController, (String? value) => _metaSeoInfo.metaMaxVideoPreviewValue = value);
    }

    if (seo.metaMaxImagePreview != null) {
      _metaSeoInfo.metaMaxImagePreview = seo.metaMaxImagePreview! ? '1' : '0';
    }

    if (imagePreviewTypeList.contains(seo.metaMaxImagePreviewValue)) {
      _metaSeoInfo.metaMaxImagePreviewValue = seo.metaMaxImagePreviewValue!;
    }

    notifyListeners();
  }

  void _applyAiMaxValue(int value, TextEditingController textController, void Function(String? value) setValue) {
    final String? text = value < 0 ? null : value.toString();
    textController.text = text ?? '';
    setValue(text);
  }

  List<TextEditingController> _metaTitleControllerList = [];
  List<TextEditingController> _metaDescriptionControllerList = [];
  List<TextEditingController> get metaTitleControllerList => _metaTitleControllerList;
  List<TextEditingController> get metaDescriptionControllerList => _metaDescriptionControllerList;

  void initMetaSeoControllers(List<Language> languageList) {
    if (_metaTitleControllerList.length == languageList.length) {
      return;
    }

    _metaTitleControllerList = [];
    _metaDescriptionControllerList = [];
    for (int i = 0; i < languageList.length; i++) {
      _metaTitleControllerList.add(TextEditingController());
      _metaDescriptionControllerList.add(TextEditingController());
    }
  }

  XFile? _metaImage;
  XFile? get metaImage => _metaImage;
  void setMetaImage(XFile? image) {
    _metaImage = image;
    notifyListeners();
  }

  final WholesaleMetaSeoInfo _metaSeoInfo = WholesaleMetaSeoInfo();
  WholesaleMetaSeoInfo get metaSeoInfo => _metaSeoInfo;

  final TextEditingController maxSnippetValueController = TextEditingController();
  final TextEditingController maxVideoPreviewValueController = TextEditingController();

  List<String> get imagePreviewTypeList => ['large', 'medium', 'small'];

  void setMetaIndexOption(String value) {
    if (value == 'index') {
      _metaSeoInfo.metaIndex = 'index';
      _metaSeoInfo.metaNoFollow = 'follow';
      _metaSeoInfo.metaNoImageIndex = '0';
      _metaSeoInfo.metaNoArchive = '0';
      _metaSeoInfo.metaNoSnippet = '0';
    } else {
      _metaSeoInfo.metaIndex = 'noindex';
      _metaSeoInfo.metaNoFollow = 'nofollow';
      _metaSeoInfo.metaNoImageIndex = '1';
      _metaSeoInfo.metaNoArchive = '1';
      _metaSeoInfo.metaNoSnippet = '1';
    }
    notifyListeners();
  }

  void setMetaNoFollow(bool value) {
    _metaSeoInfo.metaNoFollow = value ? 'nofollow' : '0';
    notifyListeners();
  }

  void setMetaNoArchive(bool value) {
    _metaSeoInfo.metaNoArchive = value ? '1' : '0';
    notifyListeners();
  }

  void setMetaNoImageIndex(bool value) {
    _metaSeoInfo.metaNoImageIndex = value ? '1' : '0';
    notifyListeners();
  }

  void setMetaNoSnippet(bool value) {
    _metaSeoInfo.metaNoSnippet = value ? '1' : '0';
    notifyListeners();
  }

  void toggleMetaMaxSnippet(bool isActive) {
    _metaSeoInfo.metaMaxSnippet = isActive ? '1' : '0';
    notifyListeners();
  }

  void setMetaMaxSnippetValue(String value) {
    _metaSeoInfo.metaMaxSnippetValue = value;
  }

  void toggleMetaMaxVideoPreview(bool isActive) {
    _metaSeoInfo.metaMaxVideoPreview = isActive ? '1' : '0';
    notifyListeners();
  }

  void setMetaMaxVideoPreviewValue(String value) {
    _metaSeoInfo.metaMaxVideoPreviewValue = value;
  }

  void toggleMetaMaxImagePreview(bool isActive) {
    _metaSeoInfo.metaMaxImagePreview = isActive ? '1' : '0';
    notifyListeners();
  }

  void setMetaMaxImagePreviewValue(String value) {
    _metaSeoInfo.metaMaxImagePreviewValue = value;
    notifyListeners();
  }

  bool validateGeneralSetup(BuildContext context) {
    if (!validateGeneralInfo(context)) {
      return false;
    }

    final WholesaleCategoryController categoryController = Provider.of<WholesaleCategoryController>(context, listen: false);
    if (categoryController.selectedCategoryId == null) {
      showCustomSnackBarWidget(getTranslated('select_a_category', context), context, sanckBarType: SnackBarType.warning);
      return false;
    }

    if (productCode.text.trim().isEmpty) {
      showCustomSnackBarWidget(getTranslated('product_code_is_required', context), context, sanckBarType: SnackBarType.warning);
      return false;
    }

    if (!RegExp(r'^[a-zA-Z0-9]{6,20}$').hasMatch(productCode.text.trim())) {
      showCustomSnackBarWidget(getTranslated('product_code_must_be_alphanumeric_6_to_20', context), context, sanckBarType: SnackBarType.warning);
      return false;
    }

    if (_unitValue == null || _unitValue!.isEmpty || _unitValue == 'select_unit') {
      showCustomSnackBarWidget(getTranslated('select_a_unit', context), context, sanckBarType: SnackBarType.warning);
      return false;
    }

    if (shippingCostController.text.trim().isEmpty) {
      showCustomSnackBarWidget(getTranslated('enter_shipping_cost', context), context, sanckBarType: SnackBarType.warning);
      return false;
    }

    return true;
  }

  bool validateStockAndPrice(BuildContext context) {
    if (minimumOrderQuantityController.text.trim().isEmpty) {
      showCustomSnackBarWidget(getTranslated('enter_minimum_order_quantity', context), context, sanckBarType: SnackBarType.warning);
      return false;
    }

    if (!_isVariationBasePricing && !_isQuantityBasePricing) {
      showCustomSnackBarWidget(getTranslated('select_at_least_one_pricing_method', context), context, sanckBarType: SnackBarType.warning);
      return false;
    }

    final int minimumOrderQty = int.tryParse(minimumOrderQuantityController.text.trim()) ?? 0;
    if (minimumOrderQty < 1) {
      showCustomSnackBarWidget(getTranslated('enter_minimum_order_quantity', context), context, sanckBarType: SnackBarType.warning);
      return false;
    }

    final VariationController variationController = Provider.of<VariationController>(context, listen: false);
    final List<String> variants = _selectedVariants(variationController);

    if (!_isVariationBasePricing && !_isDiscountAmount) {
      final double discount = double.tryParse(discountController.text.trim()) ?? 0;
      if (discount >= 100) {
        showCustomSnackBarWidget(getTranslated('discount_must_be_below_100', context), context, sanckBarType: SnackBarType.warning);
        return false;
      }
    }

    if (_isQuantityBasePricing && !_validateQuantityTiers(context, minimumOrderQty)) {
      return false;
    }

    if (_isVariationBasePricing) {

      if (!_hasVariationAxis(variationController)) {
        showCustomSnackBarWidget(getTranslated('turn_on_variation_before_variation_pricing', context), context, sanckBarType: SnackBarType.warning);
        return false;
      }

      if (!_isVariationTypeSelectable(variationController) || variants.isEmpty) {
        showCustomSnackBarWidget(getTranslated('select_variation_type', context), context, sanckBarType: SnackBarType.warning);
        return false;
      }

      for (final String variant in variants) {
        if (_isQuantityBasePricing) {
          for (int tierIndex = 0; tierIndex < _quantityPriceTiers.length; tierIndex++) {
            if (!_isAboveZero(variationTierPriceController(variant, tierIndex).text)) {
              showCustomSnackBarWidget(getTranslated('enter_price_for_every_variant', context), context, sanckBarType: SnackBarType.warning);
              return false;
            }
            if (!_isDiscountBelow100(variationTierDiscountController(variant, tierIndex).text)) {
              showCustomSnackBarWidget(getTranslated('discount_must_be_below_100', context), context, sanckBarType: SnackBarType.warning);
              return false;
            }
          }
        } else {
          if (!_isAboveZero(variationPriceController(variant).text)) {
            showCustomSnackBarWidget(getTranslated('enter_price_for_every_variant', context), context, sanckBarType: SnackBarType.warning);
            return false;
          }
          if (!_isDiscountBelow100(variationDiscountController(variant).text)) {
            showCustomSnackBarWidget(getTranslated('discount_must_be_below_100', context), context, sanckBarType: SnackBarType.warning);
            return false;
          }
        }
      }
    }

    if (_isAttributeActive && variationController.variantTypeList.isNotEmpty) {
      for (final VariantTypeModel variant in variationController.variantTypeList) {
        if ((int.tryParse(variant.qtyController.text.trim()) ?? -1) < 0) {
          showCustomSnackBarWidget(getTranslated('enter_quantity_for_every_variant', context), context, sanckBarType: SnackBarType.warning);
          return false;
        }
        if (variantSkuController(variant.variantType).text.trim().isEmpty) {
          showCustomSnackBarWidget(getTranslated('enter_sku_for_every_variant', context), context, sanckBarType: SnackBarType.warning);
          return false;
        }
      }
    } else if (totalQuantityController.text.trim().isEmpty) {
      showCustomSnackBarWidget(getTranslated('enter_total_quantity', context), context, sanckBarType: SnackBarType.warning);
      return false;
    }

    return true;
  }

  bool _validateQuantityTiers(BuildContext context, int minimumOrderQty) {
    if (_quantityPriceTiers.isEmpty) {
      showCustomSnackBarWidget(getTranslated('add_at_least_one_quantity_tier', context), context, sanckBarType: SnackBarType.warning);
      return false;
    }

    int? previousMax;

    for (int i = 0; i < _quantityPriceTiers.length; i++) {
      final QuantityPriceTierModel tier = _quantityPriceTiers[i];
      final bool isLast = i == _quantityPriceTiers.length - 1;

      final int? min = int.tryParse(tier.minQtyController.text.trim());
      final int? max = int.tryParse(tier.maxQtyController.text.trim());

      if (min == null) {
        showCustomSnackBarWidget(getTranslated('enter_tier_quantity_range', context), context, sanckBarType: SnackBarType.warning);
        return false;
      }

      if (i == 0 && min < minimumOrderQty) {
        showCustomSnackBarWidget(getTranslated('first_tier_must_start_at_minimum_order_qty', context), context, sanckBarType: SnackBarType.warning);
        return false;
      }

      if (max == null && !isLast) {
        showCustomSnackBarWidget(getTranslated('every_tier_except_last_needs_maximum_qty', context), context, sanckBarType: SnackBarType.warning);
        return false;
      }

      if (max != null && max < min) {
        showCustomSnackBarWidget(getTranslated('tier_maximum_cannot_be_less_than_minimum', context), context, sanckBarType: SnackBarType.warning);
        return false;
      }

      if (previousMax != null && min != previousMax + 1) {
        showCustomSnackBarWidget(getTranslated('quantity_tiers_must_be_contiguous', context), context, sanckBarType: SnackBarType.warning);
        return false;
      }

      if (!_isVariationBasePricing && !_isAboveZero(tier.unitPriceController.text)) {
        showCustomSnackBarWidget(getTranslated('enter_unit_price_for_every_tier', context), context, sanckBarType: SnackBarType.warning);
        return false;
      }

      previousMax = max;
    }

    return true;
  }

  bool _hasVariationAxis(VariationController variationController) {
    return variationTypeAttributes(variationController).isNotEmpty;
  }

  bool _isAboveZero(String value) => (double.tryParse(value.trim()) ?? 0) > 0;

  bool _isDiscountBelow100(String value) {
    if (value.trim().isEmpty) {
      return true;
    }
    final double discount = double.tryParse(value.trim()) ?? 0;
    return discount >= 0 && discount < 100;
  }

  bool validateImageAndMedia(BuildContext context) {
    final bool hasStoredThumbnail = _existingThumbnailUrl?.isNotEmpty ?? false;

    if (_thumbnailImage == null && !hasStoredThumbnail) {
      showCustomSnackBarWidget(getTranslated('upload_thumbnail_image', context), context, sanckBarType: SnackBarType.warning);
      return false;
    }

    if (galleryImages.isEmpty) {
      showCustomSnackBarWidget(getTranslated('upload_product_image', context), context, sanckBarType: SnackBarType.warning);
      return false;
    }

    if (_videoUploadType == VideoUploadType.link) {
      final String videoLink = videoLinkController.text.trim();
      if (videoLink.isNotEmpty && !videoLink.contains('youtube.com/embed/')) {
        showCustomSnackBarWidget(getTranslated('provide_embedded_link', context), context, sanckBarType: SnackBarType.warning);
        return false;
      }
    }

    return true;
  }

  static String wholesaleVariantKey(String variantType, {required bool colorsActive}) {
    final List<String> segments = variantType.split('-');
    final List<String> normalized = [];

    for (int i = 0; i < segments.length; i++) {
      final bool isColorSegment = colorsActive && i == 0;
      normalized.add(isColorSegment ? segments[i].trim() : segments[i].replaceAll(' ', ''));
    }

    return normalized.join('-').replaceAll('.', '_');
  }

  Map<String, String> _colorCodesByName(VariationController variationController) {
    final Map<String, String> codes = {};
    final List<String?> names = variationController.attributeList?.first.variants ?? <String?>[];
    final List<String?> colorCodes = variationController.colorCodeList;

    for (int i = 0; i < names.length && i < colorCodes.length; i++) {
      final String? name = names[i];
      final String? code = colorCodes[i];
      if (name != null && code != null) {
        codes[name] = code;
      }
    }

    return codes;
  }

  List<String> _selectedVariants(VariationController variationController) {
    for (final AttributeModel attribute in variationController.attributeList ?? <AttributeModel>[]) {
      if (attribute.attribute.id == _selectedVariationTypeAttrId) {
        return attribute.variants.whereType<String>().toList();
      }
    }
    return [];
  }

  Future<ApiResponse?> addWholesaleProduct(
    BuildContext context, {
    required List<Language> languageList,
    bool update = false,
    int? productId,
    List<String>? existingImages,
  }) async {
    _isLoading = true;
    notifyListeners();

    final WholesaleCategoryController categoryController = Provider.of<WholesaleCategoryController>(context, listen: false);
    final WholesaleBrandController brandController = Provider.of<WholesaleBrandController>(context, listen: false);
    final VariationController variationController = Provider.of<VariationController>(context, listen: false);
    final WholesaleVatTaxController vatTaxController = Provider.of<WholesaleVatTaxController>(context, listen: false);

    final AddWholesaleProductModel addWholesaleProduct = AddWholesaleProductModel(
      titleList: _titleControllerList.map((controller) => controller.text.trim()).toList(),
      descriptionList: _descriptionControllerList.map((controller) => controller.text.trim()).toList(),
      languageList: languageList.map((language) => language.code).toList(),
    );

    final int categoryId = categoryController.selectedCategoryId ?? 0;
    final int? subCategoryId = categoryController.selectedSubCategoryId;
    final int? subSubCategoryId = categoryController.selectedSubSubCategoryId;

    final int? brandId = brandController.selectedBrandId;

    final List<int> choiceAttributeIds = [];
    final List<String?> choiceAttributeNames = [];
    final Map<int, List<String?>> choiceOptions = {};
    bool colorsActive = false;

    for (final AttributeModel attribute in variationController.attributeList ?? <AttributeModel>[]) {
      if (!attribute.active) {
        continue;
      }
      if (attribute.attribute.id == 0) {
        colorsActive = true;
      } else {
        choiceAttributeIds.add(attribute.attribute.id!);
        choiceAttributeNames.add(attribute.attribute.name);
        choiceOptions[attribute.attribute.id!] = attribute.variants;
      }
    }

    final bool hasVariantStock = _isAttributeActive && variationController.variantTypeList.isNotEmpty;

    final Map<String, int> variantQuantities = {};
    final Map<String, String> variantSkus = {};
    if (hasVariantStock) {
      for (final VariantTypeModel variant in variationController.variantTypeList) {
        final String key = wholesaleVariantKey(variant.variantType, colorsActive: colorsActive);
        variantQuantities[key] = int.tryParse(variant.qtyController.text.trim()) ?? 0;
        variantSkus[key] = variantSkuController(variant.variantType).text.trim();
      }
    }

    final List<String> variants = _selectedVariants(variationController);

    final Map<String, String> variationPrice = {};
    final Map<String, String> variationDiscount = {};
    if (_isVariationBasePricing && !_isQuantityBasePricing) {
      for (final String variant in variants) {
        variationPrice[variant] = variationPriceController(variant).text.trim();
        variationDiscount[variant] = variationDiscountController(variant).text.trim();
      }
    }

    final List<String> tierMinQty = [];
    final List<String> tierMaxQty = [];
    final List<String> tierUnitPrice = [];
    if (_isQuantityBasePricing) {
      for (final QuantityPriceTierModel tier in _quantityPriceTiers) {
        tierMinQty.add(tier.minQtyController.text.trim());
        tierMaxQty.add(tier.maxQtyController.text.trim());
        if (!_isVariationBasePricing) {
          tierUnitPrice.add(tier.unitPriceController.text.trim());
        }
      }
    }

    final Map<String, Map<int, String>> variationTierPrice = {};
    final Map<String, Map<int, String>> variationTierDiscount = {};
    if (_isVariationBasePricing && _isQuantityBasePricing) {
      for (final String variant in variants) {
        variationTierPrice[variant] = {};
        variationTierDiscount[variant] = {};
        for (int tierIndex = 0; tierIndex < _quantityPriceTiers.length; tierIndex++) {
          variationTierPrice[variant]![tierIndex] = variationTierPriceController(variant, tierIndex).text.trim();
          variationTierDiscount[variant]![tierIndex] = variationTierDiscountController(variant, tierIndex).text.trim();
        }
      }
    }

    final List<int> taxIds = vatTaxController.selectedTaxIds;

    final bool hasVideoFile = _pickedVideoFile != null || _existingVideoUrl != null;
    final String videoProvider = _videoUploadType == VideoUploadType.file && hasVideoFile ? 'custom_video' : 'youtube_link';

    ApiResponse? response;

    try {
      response = await addWholesaleProductServiceInterface.addWholesaleProduct(
        addWholesaleProduct: addWholesaleProduct,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        subSubCategoryId: subSubCategoryId,
        brandId: brandId,
        code: productCode.text.trim(),
        unit: _unitValue ?? '',
        reorderLevel: int.tryParse(reOrderLevelController.text.trim()),
        shippingCost: double.tryParse(shippingCostController.text.trim()) ?? 0,
        multiplyQty: _isMultiply,
        tags: _tagList.isEmpty ? null : _tagList.join(','),
        colorsActive: colorsActive,
        colors: variationController.colorCodeList,
        choiceAttributeIds: choiceAttributeIds,
        choiceAttributeNames: choiceAttributeNames,
        choiceOptions: choiceOptions,
        variantQuantities: variantQuantities,
        variantSkus: variantSkus,
        currentStock: hasVariantStock ? null : int.tryParse(totalQuantityController.text.trim()),
        minimumOrderQty: int.tryParse(minimumOrderQuantityController.text.trim()) ?? 1,
        discount: double.tryParse(discountController.text.trim()),
        discountType: _isDiscountAmount ? 'flat' : 'percent',
        taxIds: taxIds,
        variationBasedPrice: _isVariationBasePricing,
        quantityBasedPrice: _isQuantityBasePricing,
        variationType: _variationTypeValue(variationController),
        variationPrice: variationPrice,
        variationDiscount: variationDiscount,
        tierMinQty: tierMinQty,
        tierMaxQty: tierMaxQty,
        tierUnitPrice: tierUnitPrice,
        variationTierPrice: variationTierPrice,
        variationTierDiscount: variationTierDiscount,
        thumbnail: _thumbnailImage,
        images: _additionalImages,
        videoProvider: videoProvider,
        youtubeVideoUrl: _videoUploadType == VideoUploadType.link ? videoLinkController.text.trim() : null,
        customVideo: _videoUploadType == VideoUploadType.file ? _pickedVideoFile?.file : null,
        attributeImages: buildAttributeImages(variationController),
        faqList: _faqList,
        metaTitle: _metaTitleControllerList.isNotEmpty ? _metaTitleControllerList[0].text.trim() : null,
        metaDescription: _metaDescriptionControllerList.isNotEmpty ? _metaDescriptionControllerList[0].text.trim() : null,
        metaImage: _metaImage,
        metaSeoInfo: _metaSeoInfo,
        update: update,
        productId: productId,
        existingImages: existingImages,
      );

      if (response.response != null && (response.response!.statusCode == 200 || response.response!.statusCode == 201)) {
        showCustomSnackBarWidget(
          getTranslated(update || productId != null ? 'product_updated_successfully' : 'product_added_successfully', Get.context!),
          Get.context!,
          isError: false,
        );

        if (context.mounted) {
          resetForm(context);
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      showCustomSnackBarWidget(getTranslated('product_add_failed', Get.context!), Get.context!, sanckBarType: SnackBarType.error);
    }

    _isLoading = false;
    notifyListeners();

    return response;
  }

  List<WholesaleAttributeImageModel> buildAttributeImages(VariationController variationController) {
    final List<WholesaleAttributeImageModel> groups = [];
    final Map<String, String> colorCodes = _colorCodesByName(variationController);

    _variationImages.forEach((key, images) {
      if (images.isEmpty) {
        return;
      }

      final int separator = key.indexOf('::');
      final int attributeId = int.tryParse(key.substring(0, separator)) ?? 0;
      final String value = key.substring(separator + 2);

      final bool isColor = attributeId == 0;

      final String? resolvedValue = isColor ? colorCodes[value] : value;
      if (resolvedValue == null) {
        return;
      }

      final List<VariationImageModel> stored = images.where((image) => image.isStored).toList();
      final List<VariationImageModel> picked = images.where((image) => !image.isStored).toList();
      final List<VariationImageModel> merged = [...stored, ...picked];

      final List<int> galleryIndexes = [];
      for (int i = 0; i < merged.length; i++) {
        if (merged[i].includeInAdditionalImages) {
          galleryIndexes.add(i);
        }
      }

      groups.add(WholesaleAttributeImageModel(
        type: isColor ? 'color' : 'attribute',
        attributeId: isColor ? null : attributeId,
        value: resolvedValue,
        existingImages: stored.map((image) => image.storedKey!).toList(),
        images: picked.map((image) => image.file!).toList(),
        galleryIndexes: galleryIndexes,
      ));
    });

    return groups;
  }

  List<AttributeModel> variationTypeAttributes(VariationController variationController) {
    return (variationController.attributeList ?? <AttributeModel>[])
        .where((attribute) => attribute.active && attribute.attribute.id != null)
        .toList();
  }

  bool _isVariationTypeSelectable(VariationController variationController) {
    return variationTypeAttributes(variationController)
        .any((attribute) => attribute.attribute.id == _selectedVariationTypeAttrId);
  }

  String? _variationTypeValue(VariationController variationController) {
    if (!_isVariationBasePricing || !_isVariationTypeSelectable(variationController)) {
      return null;
    }
    return _selectedVariationTypeAttrId == 0 ? 'color' : _selectedVariationTypeAttrId.toString();
  }

}
