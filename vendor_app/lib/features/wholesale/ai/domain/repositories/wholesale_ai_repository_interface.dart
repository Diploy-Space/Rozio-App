import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class WholesaleAiRepositoryInterface implements RepositoryInterface {
  Future<ApiResponse> getGenerateLimit();
  Future<ApiResponse> generateTitle({required String name, required String langCode});
  Future<ApiResponse> generateDescription({required String name, required String langCode});
  Future<ApiResponse> generateGeneralSetup({required String name, required String description});
  Future<ApiResponse> generatePricingSetup({required String name, required String description});
  Future<ApiResponse> generateVariationSetup({required String name, required String description});
  Future<ApiResponse> generateSeoSection({required String name, required String description});
  Future<ApiResponse> generateFaq({required String name, required String description, required String langCode, List<String> existingQuestions = const []});
  Future<ApiResponse> analyzeImage({required XFile image});
}
