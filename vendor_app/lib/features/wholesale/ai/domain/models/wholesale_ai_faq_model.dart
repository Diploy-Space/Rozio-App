import 'dart:convert';

class WholesaleAiFaqModel {
  final List<WholesaleAiFaq> faqs;
  final int? remainingCount;

  WholesaleAiFaqModel({this.faqs = const [], this.remainingCount});

  factory WholesaleAiFaqModel.fromJson(dynamic json) {
    final dynamic content = json is Map ? json['content'] : null;
    if (content is! Map) {
      return WholesaleAiFaqModel();
    }

    return WholesaleAiFaqModel(
      faqs: _toFaqList(content['data'])
          .whereType<Map>()
          .map((Map entry) => WholesaleAiFaq.fromJson(Map<String, dynamic>.from(entry)))
          .where((WholesaleAiFaq faq) => faq.question.isNotEmpty && faq.answer.isNotEmpty)
          .toList(),
      remainingCount: int.tryParse(content['remaining_count']?.toString() ?? ''),
    );
  }

  static List<dynamic> _toFaqList(dynamic data) {
    dynamic value = data;
    if (value is String) {
      try {
        value = jsonDecode(value);
      } catch (_) {
        return const [];
      }
    }

    if (value is List) {
      return value;
    }
    if (value is Map) {
      if (value.containsKey('question')) {
        return [value];
      }
      for (final String key in const ['faqs', 'faq', 'data', 'items']) {
        if (value[key] is List) {
          return value[key] as List;
        }
      }
      final Iterable<List> lists = value.values.whereType<List>();
      if (lists.isNotEmpty) {
        return lists.first;
      }
    }
    return const [];
  }
}

class WholesaleAiFaq {
  final String question;
  final String answer;
  final int? priority;

  WholesaleAiFaq({required this.question, required this.answer, this.priority});

  factory WholesaleAiFaq.fromJson(Map<String, dynamic> json) {
    return WholesaleAiFaq(
      question: json['question']?.toString().trim() ?? '',
      answer: json['answer']?.toString().trim() ?? '',
      priority: int.tryParse(json['priority']?.toString() ?? ''),
    );
  }
}
