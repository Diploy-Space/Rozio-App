import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/repositories/wholesale_ai_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/services/wholesale_ai_service_interface.dart';

class WholesaleAiService implements WholesaleAiServiceInterface {
  final WholesaleAiRepositoryInterface wholesaleAiRepoInterface;
  WholesaleAiService({required this.wholesaleAiRepoInterface});

  @override
  Future<ApiResponse> getGenerateLimit() {
    return wholesaleAiRepoInterface.getGenerateLimit();
  }

  @override
  Future<ApiResponse> generateTitle({required String name, required String langCode}) {
    return wholesaleAiRepoInterface.generateTitle(name: name, langCode: langCode);
  }

  @override
  Future<ApiResponse> generateDescription({required String name, required String langCode}) {
    return wholesaleAiRepoInterface.generateDescription(name: name, langCode: langCode);
  }

  @override
  Future<ApiResponse> generateGeneralSetup({required String name, required String description}) {
    return wholesaleAiRepoInterface.generateGeneralSetup(name: name, description: description);
  }

  @override
  Future<ApiResponse> generatePricingSetup({required String name, required String description}) {
    return wholesaleAiRepoInterface.generatePricingSetup(name: name, description: description);
  }

  @override
  Future<ApiResponse> generateVariationSetup({required String name, required String description}) {
    return wholesaleAiRepoInterface.generateVariationSetup(name: name, description: description);
  }

  @override
  Future<ApiResponse> generateSeoSection({required String name, required String description}) {
    return wholesaleAiRepoInterface.generateSeoSection(name: name, description: description);
  }

  @override
  Future<ApiResponse> generateFaq({required String name, required String description, required String langCode, List<String> existingQuestions = const []}) {
    return wholesaleAiRepoInterface.generateFaq(name: name, description: description, langCode: langCode, existingQuestions: existingQuestions);
  }

  @override
  Future<ApiResponse> analyzeImage({required XFile image}) {
    return wholesaleAiRepoInterface.analyzeImage(image: image);
  }
}
