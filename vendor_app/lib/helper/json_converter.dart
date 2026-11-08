class JsonConverter {
  static bool? toBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    return value.toString() == '1' || value.toString().toLowerCase() == 'true';
  }
}
