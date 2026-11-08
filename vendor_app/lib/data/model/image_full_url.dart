class ImageFullUrl {
  String? key;
  String? path;
  int? status;

  ImageFullUrl({this.key, this.path, this.status});

  ImageFullUrl.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    path = json['path'];
    status = json['status'];
    if(status != 200){
      path = '';
    }
  }

  factory ImageFullUrl.fromDynamic(dynamic value) {
    if (value is Map) return ImageFullUrl.fromJson(Map<String, dynamic>.from(value));
    if (value is String && value.isNotEmpty) return ImageFullUrl(key: value, path: value, status: 200);
    return ImageFullUrl(path: '', status: 404);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['path'] = path;
    data['status'] = status;
    return data;
  }
}