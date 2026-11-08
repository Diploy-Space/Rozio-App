import 'package:sixvalley_vendor_app/features/ai/domain/models/ai_variation_model.dart';

class WholesaleAiVariationModel {
  final int? colorsActive;

  final List<AiColors> colors;
  final List<ChoiceAttributes> choiceAttributes;

  final List<GenereateVariation> generatedVariations;

  final int? remainingCount;

  WholesaleAiVariationModel({
    this.colorsActive,
    this.colors = const [],
    this.choiceAttributes = const [],
    this.generatedVariations = const [],
    this.remainingCount,
  });

  factory WholesaleAiVariationModel.fromJson(Map<String, dynamic> json) {
    final dynamic content = json['content'];
    if (content is! Map<String, dynamic>) {
      return WholesaleAiVariationModel();
    }

    final int? remainingCount = int.tryParse(content['remaining_count']?.toString() ?? '');

    final dynamic data = content['data'];
    if (data is! Map<String, dynamic>) {
      return WholesaleAiVariationModel(remainingCount: remainingCount);
    }

    return WholesaleAiVariationModel(
      colorsActive: int.tryParse(data['colors_active']?.toString() ?? ''),
      colors: _toColors(data['colors']),
      choiceAttributes: _toChoiceAttributes(data['choice_attributes']),
      generatedVariations: _toGeneratedVariations(data['genereate_variation']),
      remainingCount: remainingCount,
    );
  }

  static List<AiColors> _toColors(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map((Map<String, dynamic> color) => AiColors(
              name: color['name']?.toString(),
              code: color['code']?.toString(),
            ))
        .where((AiColors color) => (color.name ?? '').trim().isNotEmpty)
        .toList();
  }

  static List<ChoiceAttributes> _toChoiceAttributes(dynamic value) {
    if (value is! List) {
      return const [];
    }

    final List<ChoiceAttributes> attributes = [];

    for (final Map<String, dynamic> attribute in value.whereType<Map<String, dynamic>>()) {
      final int? id = int.tryParse(attribute['id']?.toString() ?? '');
      final dynamic options = attribute['options'];

      if (id == null || options is! List) {
        continue;
      }

      final List<String> values = options
          .map((dynamic option) => option?.toString().trim() ?? '')
          .where((String option) => option.isNotEmpty)
          .toList();

      if (values.isNotEmpty) {
        attributes.add(ChoiceAttributes(id: id, values: values));
      }
    }

    return attributes;
  }

  static List<GenereateVariation> _toGeneratedVariations(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map((Map<String, dynamic> variation) => GenereateVariation(
              option: variation['option']?.toString(),
              sku: variation['sku']?.toString(),
              price: double.tryParse(variation['price']?.toString() ?? ''),
              stock: int.tryParse(variation['stock']?.toString() ?? ''),
            ))
        .toList();
  }
}
