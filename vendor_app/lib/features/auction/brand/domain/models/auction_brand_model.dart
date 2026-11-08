import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/data/model/pagination_model.dart';

class AuctionBrandModel {
  int? id;
  String? name;
  String? image;
  ImageFullUrl? imageFullUrl;

  AuctionBrandModel({this.id, this.name, this.image, this.imageFullUrl});

  AuctionBrandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    imageFullUrl = json['image_full_url'] is Map<String, dynamic> ? ImageFullUrl.fromJson(json['image_full_url']) : null;
  }
}

class AuctionBrandListModel {
  List<AuctionBrandModel> brands;
  PaginationModel? pagination;

  AuctionBrandListModel({List<AuctionBrandModel>? brands, this.pagination}) : brands = brands ?? [];

  AuctionBrandListModel.fromJson(Map<String, dynamic> json) : brands = [] {
    final dynamic content = json['content'] is Map ? json['content'] : json;

    if (content['data'] is List) {
      for (final dynamic brand in content['data']) {
        brands.add(AuctionBrandModel.fromJson(brand));
      }
    }

    if (content['pagination'] is Map) {
      pagination = PaginationModel.fromJson(content['pagination']);
    }
  }
}
