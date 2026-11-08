import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_image_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/enums/wholesale_ai_image_step.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_faq_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_general_setup_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_limit_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_pricing_setup_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_seo_section_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_variation_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_text_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/services/wholesale_ai_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/helper/product_helper.dart';

class WholesaleAiController with ChangeNotifier {
  final WholesaleAiServiceInterface wholesaleAiServiceInterface;

  WholesaleAiController({required this.wholesaleAiServiceInterface});

  int _genLimit = 0;
  int get genLimit => _genLimit;

  Future<void> getGenerateLimit() async {
    final ApiResponse apiResponse = await wholesaleAiServiceInterface.getGenerateLimit();

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _genLimit = WholesaleAiLimitModel.fromJson(apiResponse.response!.data).remainingCount;
    }

    notifyListeners();
  }

  bool _titleLoading = false;
  bool get titleLoading => _titleLoading;

  Future<void> generateTitle({
    required String name,
    required String langCode,
    required TextEditingController nameController,
  }) async {
    if (name.trim().isEmpty || _titleLoading) {
      return;
    }

    _titleLoading = true;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleAiServiceInterface.generateTitle(name: name.trim(), langCode: langCode);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final WholesaleAiTextModel title = WholesaleAiTextModel.fromJson(apiResponse.response!.data);

      if (title.data != null && title.data!.isNotEmpty) {
        nameController.text = title.data!;
      }
      _applyRemainingCount(title.remainingCount);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _titleLoading = false;
    notifyListeners();
  }

  bool _descLoading = false;
  bool get descLoading => _descLoading;

  Future<void> generateDescription({
    required String name,
    required String langCode,
    required TextEditingController descriptionController,
  }) async {
    if (name.trim().isEmpty || _descLoading) {
      return;
    }

    _descLoading = true;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleAiServiceInterface.generateDescription(name: name.trim(), langCode: langCode);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final WholesaleAiTextModel description = WholesaleAiTextModel.fromJson(apiResponse.response!.data);

      final String plainDescription = ProductHelper.htmlToPlainText(description.data ?? '');
      if (plainDescription.isNotEmpty) {
        descriptionController.text = plainDescription;
      }
      _applyRemainingCount(description.remainingCount);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _descLoading = false;
    notifyListeners();
  }

  bool _generalSetupLoading = false;
  bool get generalSetupLoading => _generalSetupLoading;

  Future<void> generateGeneralSetup({
    required String name,
    required String description,
    required Future<void> Function(WholesaleAiGeneralSetupModel setup) apply,
  }) async {
    if (name.trim().isEmpty || description.trim().isEmpty || _generalSetupLoading) {
      return;
    }

    _generalSetupLoading = true;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleAiServiceInterface.generateGeneralSetup(
      name: name.trim(),
      description: description.trim(),
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final WholesaleAiGeneralSetupModel generalSetup = WholesaleAiGeneralSetupModel.fromJson(apiResponse.response!.data);
      _applyRemainingCount(generalSetup.remainingCount);
      await apply(generalSetup);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _generalSetupLoading = false;
    notifyListeners();
  }

  bool _pricingSetupLoading = false;
  bool get pricingSetupLoading => _pricingSetupLoading;

  Future<void> generatePricingSetup({
    required String name,
    required String description,
    required Future<void> Function(WholesaleAiPricingSetupModel pricing) apply,
  }) async {
    if (name.trim().isEmpty || description.trim().isEmpty || _pricingSetupLoading) {
      return;
    }

    _pricingSetupLoading = true;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleAiServiceInterface.generatePricingSetup(
      name: name.trim(),
      description: description.trim(),
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final WholesaleAiPricingSetupModel pricingSetup = WholesaleAiPricingSetupModel.fromJson(apiResponse.response!.data);
      _applyRemainingCount(pricingSetup.remainingCount);
      await apply(pricingSetup);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _pricingSetupLoading = false;
    notifyListeners();
  }

  bool _variationSetupLoading = false;
  bool get variationSetupLoading => _variationSetupLoading;

  Future<void> generateVariationSetup({
    required String name,
    required String description,
    required Future<void> Function(WholesaleAiVariationModel variation) apply,
  }) async {
    if (name.trim().isEmpty || description.trim().isEmpty || _variationSetupLoading) {
      return;
    }

    _variationSetupLoading = true;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleAiServiceInterface.generateVariationSetup(
      name: name.trim(),
      description: description.trim(),
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final WholesaleAiVariationModel variationSetup = WholesaleAiVariationModel.fromJson(apiResponse.response!.data);
      _applyRemainingCount(variationSetup.remainingCount);
      await apply(variationSetup);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _variationSetupLoading = false;
    notifyListeners();
  }

  bool _seoSectionLoading = false;
  bool get seoSectionLoading => _seoSectionLoading;

  Future<void> generateSeoSection({
    required String name,
    required String description,
    required Future<void> Function(WholesaleAiSeoSectionModel seo) apply,
  }) async {
    if (name.trim().isEmpty || _seoSectionLoading) {
      return;
    }

    _seoSectionLoading = true;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleAiServiceInterface.generateSeoSection(
      name: name.trim(),
      description: description.trim(),
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final WholesaleAiSeoSectionModel seoSection = WholesaleAiSeoSectionModel.fromJson(apiResponse.response!.data);
      _applyRemainingCount(seoSection.remainingCount);
      await apply(seoSection);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _seoSectionLoading = false;
    notifyListeners();
  }

  bool _faqLoading = false;
  bool get faqLoading => _faqLoading;

  final Map<String, List<String>> _generatedFaqQuestions = {};

  void clearGeneratedFaqQuestions() {
    _generatedFaqQuestions.clear();
  }

  Future<void> generateFaq({
    required String name,
    required String description,
    required String langCode,
    required Future<void> Function(WholesaleAiFaqModel faq) apply,
  }) async {
    if (name.trim().isEmpty || description.trim().isEmpty || _faqLoading) {
      return;
    }

    _faqLoading = true;
    notifyListeners();

    final ApiResponse apiResponse = await wholesaleAiServiceInterface.generateFaq(
      name: name.trim(),
      description: description.trim(),
      langCode: langCode,
      existingQuestions: List.unmodifiable(_generatedFaqQuestions[langCode] ?? const <String>[]),
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final WholesaleAiFaqModel faq = WholesaleAiFaqModel.fromJson(apiResponse.response!.data);
      final List<String> generatedQuestions = _generatedFaqQuestions.putIfAbsent(langCode, () => []);
      for (final WholesaleAiFaq entry in faq.faqs) {
        if (!generatedQuestions.contains(entry.question)) {
          generatedQuestions.add(entry.question);
        }
      }

      if (faq.faqs.isEmpty) {
        debugPrint('WholesaleAiController.generateFaq: no FAQs parsed from ${apiResponse.response!.data}');
      }
      _applyRemainingCount(faq.remainingCount);
      await apply(faq);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _faqLoading = false;
    notifyListeners();
  }

  XFile? _pickedImage;
  XFile? get pickedImage => _pickedImage;

  bool _imageLoading = false;
  bool get imageLoading => _imageLoading;

  Future<void> pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: AppConstants.imageQuality);
      if (image != null) {
        _pickedImage = image;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('WholesaleAiController.pickImage: $e');
    }
  }

  void removeImage({bool willUpdate = true}) {
    _pickedImage = null;
    if (willUpdate) {
      notifyListeners();
    }
  }

  Future<String?> analyzeImage() async {
    if (_pickedImage == null || _imageLoading) {
      return null;
    }

    _imageLoading = true;
    notifyListeners();

    String? name;
    try {
      final XFile compressed = await _compressImage(File(_pickedImage!.path));
      final ApiResponse apiResponse = await wholesaleAiServiceInterface.analyzeImage(image: compressed);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        final WholesaleAiImageModel image = WholesaleAiImageModel.fromJson(apiResponse.response!.data);
        _applyRemainingCount(image.remainingCount);
        name = image.name;

        if (name == null) {
          debugPrint('WholesaleAiController.analyzeImage: no product name parsed from ${apiResponse.response!.data}');
          showCustomSnackBarWidget(getTranslated('could_not_identify_product_from_image', Get.context!), Get.context!, sanckBarType: SnackBarType.warning);
        }
      } else {
        ApiChecker.checkApi(apiResponse);
      }
    } catch (e) {
      debugPrint('WholesaleAiController.analyzeImage: $e');
      showCustomSnackBarWidget(getTranslated('image_compression_failed', Get.context!), Get.context!, sanckBarType: SnackBarType.error);
    }

    _imageLoading = false;
    notifyListeners();
    return name;
  }

  Future<XFile> _compressImage(File imageFile) async {
    final String targetPath = path.join(Directory.systemTemp.path, 'wholesale_ai_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
    final XFile? compressed = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      targetPath,
      quality: 10,
      minHeight: 800,
      minWidth: 800,
    );
    if (compressed == null) {
      throw StateError('Image compression failed');
    }
    return compressed;
  }

  bool _imageAutoFillRunning = false;
  bool get imageAutoFillRunning => _imageAutoFillRunning;

  int _imageLanguageIndex = 0;
  int get imageLanguageIndex => _imageLanguageIndex;

  final Set<WholesaleAiImageStep> _pendingImageSteps = {};

  void startImageAutoFill({required int languageIndex}) {
    _pendingImageSteps.clear();
    _imageLanguageIndex = languageIndex;
    _imageAutoFillRunning = true;
    notifyListeners();
  }

  void finishImageAutoFill({required bool armFollowUps}) {
    if (armFollowUps) {
      _pendingImageSteps.addAll(WholesaleAiImageStep.values);
    }
    _imageAutoFillRunning = false;
    notifyListeners();
  }

  bool consumeImageStep(WholesaleAiImageStep step) => _pendingImageSteps.remove(step);

  void clearImageAutoFill() {
    _pendingImageSteps.clear();
    _imageAutoFillRunning = false;
    _imageLanguageIndex = 0;
  }

  void _applyRemainingCount(int? count) {
    if (count != null) {
      _genLimit = count;
    }
  }
}
