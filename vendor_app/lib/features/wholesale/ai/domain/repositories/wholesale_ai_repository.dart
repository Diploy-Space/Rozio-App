import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/repositories/wholesale_ai_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class WholesaleAiRepository implements WholesaleAiRepositoryInterface {
  final DioClient? dioClient;
  WholesaleAiRepository({required this.dioClient});

  @override
  Future<ApiResponse> getGenerateLimit() async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleGenerateLimitCheck);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> generateTitle({required String name, required String langCode}) async {
    try {
      final response = await dioClient!.post(
        AppConstants.wholesaleTitleAutoFill,
        data: {'name': name, 'langCode': langCode},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> generateDescription({required String name, required String langCode}) async {
    try {
      final response = await dioClient!.post(
        AppConstants.wholesaleDescriptionAutoFill,
        data: {'name': name, 'langCode': langCode},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> generateGeneralSetup({required String name, required String description}) async {
    try {
      final response = await dioClient!.post(
        AppConstants.wholesaleGeneralSetupAutoFill,
        data: {'name': name, 'description': description},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> generatePricingSetup({required String name, required String description}) async {
    try {
      final response = await dioClient!.post(
        AppConstants.wholesalePricingSetupAutoFill,
        data: {'name': name, 'description': description},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> generateVariationSetup({required String name, required String description}) async {
    try {
      final response = await dioClient!.post(
        AppConstants.wholesaleVariationSetupAutoFill,
        data: {'name': name, 'description': description},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> generateSeoSection({required String name, required String description}) async {
    try {
      final response = await dioClient!.post(
        AppConstants.wholesaleSeoSectionAutoFill,
        data: {'name': name, 'description': description},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> generateFaq({required String name, required String description, required String langCode, List<String> existingQuestions = const []}) async {
    try {
      final response = await dioClient!.post(
        AppConstants.wholesaleFaqAutoFill,
        data: {
          'name': name,
          'description': description,
          'langCode': langCode,
          if (existingQuestions.isNotEmpty) 'existing_questions': existingQuestions,
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> analyzeImage({required XFile image}) async {
    try {
      final MultipartFile multipartFile = MultipartFile.fromBytes(await image.readAsBytes(), filename: image.name);
      final response = await dioClient!.postMultipart(
        AppConstants.wholesaleAnalyzeImageAutoFill,
        data: <String, dynamic>{},
        files: [MultipartWithKey(key: 'image', multipartFile: multipartFile)],
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
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
