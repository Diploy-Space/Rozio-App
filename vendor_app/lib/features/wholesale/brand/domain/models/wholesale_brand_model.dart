import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/data/model/pagination_model.dart';

class WholesaleBrandModel {
  int? id;
  String? name;
  String? image;
  ImageFullUrl? imageFullUrl;

  WholesaleBrandModel({this.id, this.name, this.image, this.imageFullUrl});

  WholesaleBrandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    imageFullUrl = json['image_full_url'] != null ? ImageFullUrl.fromJson(json['image_full_url']) : null;
  }
}

class WholesaleBrandListModel {
  List<WholesaleBrandModel> brands;
  PaginationModel? pagination;

  WholesaleBrandListModel({List<WholesaleBrandModel>? brands, this.pagination}) : brands = brands ?? [];

  WholesaleBrandListModel.fromJson(Map<String, dynamic> json) : brands = [] {
    final dynamic content = json['content'];
    if (content == null) {
      return;
    }

    if (content['data'] != null) {
      for (final dynamic brand in content['data']) {
        brands.add(WholesaleBrandModel.fromJson(brand));
      }
    }

    if (content['pagination'] != null) {
      pagination = PaginationModel.fromJson(content['pagination']);
    }
  }
}
