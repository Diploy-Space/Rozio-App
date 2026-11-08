class ApiEnvelope {

  static Map content(dynamic data) {
    if (data is! Map) return const {};
    return data['content'] is Map ? data['content'] : data;
  }

  static String? message(dynamic data) {
    if (data is! Map) return null;
    final dynamic message = data['message'] ?? content(data)['message'];
    return message?.toString();
  }

  static int? remainingCount(dynamic data) {
    if (data is! Map) return null;
    final Map body = content(data);

    final dynamic direct = body['remaining_count'];
    if (direct != null) return int.tryParse(direct.toString());

    final dynamic payload = body['data'];
    if (payload is Map && payload['remaining_count'] != null) {
      return int.tryParse(payload['remaining_count'].toString());
    }
    return null;
  }

  static Map dataObject(dynamic data) {
    final Map body = content(data);
    return body['data'] is Map ? body['data'] : body;
  }

  static String? errorMessage(dynamic data) {
    if (data is! Map) return null;
    final String? summary = message(data);
    if (summary != null && summary.trim().isNotEmpty) return summary;

    final dynamic errors = data['errors'];
    if (errors is List && errors.isNotEmpty && errors.first is Map) {
      final dynamic first = (errors.first as Map)['message'];
      if (first != null && first.toString().trim().isNotEmpty) {
        return first.toString();
      }
    }
    return null;
  }
}
