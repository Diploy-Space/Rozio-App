import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';

class AiVariationModel {
  String? message;
  Data? data;
  int? remainingCount;

  AiVariationModel({this.message, this.data, this.remainingCount});

  AiVariationModel.fromJson(dynamic json) {
    final Map content = ApiEnvelope.content(json);

    message = ApiEnvelope.message(json);
    remainingCount = ApiEnvelope.remainingCount(json);

    final dynamic payload = content['data'];
    data = payload is Map ? Data.fromJson(Map<String, dynamic>.from(payload)) : null;
  }
}

class Data {
  int? colorsActive;
  List<AiColors>? colors;
  List<ChoiceAttributes>? choiceAttributes;
  List<GenereateVariation>? genereateVariation;

  Data({this.colorsActive, this.colors, this.choiceAttributes,  this.genereateVariation});

  Data.fromJson(Map<String, dynamic> json) {
    colorsActive = int.tryParse(json['colors_active']?.toString() ?? '');

    final dynamic rawColors = json['colors'];
    if (rawColors is List) {
      colors = rawColors
          .whereType<Map>().map((Map color) => AiColors.fromJson(Map<String, dynamic>.from(color))).where((AiColors color) => (color.name ?? '').trim().isNotEmpty)
          .toList();
    }

    final dynamic rawAttributes = json['choice_attributes'];
    if (rawAttributes is List) {
      choiceAttributes = rawAttributes
          .whereType<Map>().map((Map attribute) => ChoiceAttributes.fromJson(Map<String, dynamic>.from(attribute)))
          .where((ChoiceAttributes attribute) => attribute.id != null && (attribute.values?.isNotEmpty ?? false)).toList();
    }

    final dynamic rawVariations = json['genereate_variation'];
    if (rawVariations is List) {
      genereateVariation = rawVariations
          .whereType<Map>().map((Map variation) => GenereateVariation.fromJson(Map<String, dynamic>.from(variation))).toList();
    }
  }
}

class AiColors {
  String? name;
  String? code;

  AiColors({this.name, this.code});

  AiColors.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    code = json['code']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    return data;
  }
}

class ChoiceAttributes {
  int? id;
  String? name;
  List<String>? values;

  ChoiceAttributes({this.id, this.values});

  ChoiceAttributes.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    name = json['name']?.toString();
    values = _toStringList(json['options']);
  }

  static List<String> _toStringList(dynamic value) {
    if (value is! List) return const [];

    return value.map((dynamic item) => item?.toString().trim() ?? '').where((String item) => item.isNotEmpty).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['options'] = values;
    return data;
  }
}


class GenereateVariation {
  String? option;
  String? sku;
  double? price;
  int? stock;

  GenereateVariation({this.option, this.sku, this.price, this.stock});

  GenereateVariation.fromJson(Map<String, dynamic> json) {
    option = json['option']?.toString();
    sku = json['sku']?.toString();
    price = double.tryParse(json['price']?.toString() ?? '');
    stock = int.tryParse(json['stock']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['option'] = option;
    data['sku'] = sku;
    data['price'] = price;
    data['stock'] = stock;
    return data;
  }
}