import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/data/model/pagination_model.dart';

class AuctionCategoryModel {
  int? id;
  String? name;
  String? icon;
  ImageFullUrl? iconFullUrl;
  int? productCount;

  AuctionCategoryModel({this.id, this.name, this.icon, this.iconFullUrl, this.productCount});

  AuctionCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    iconFullUrl = json['icon_full_url'] is Map<String, dynamic> ? ImageFullUrl.fromJson(json['icon_full_url']) : null;
    productCount = json['product_count'];
  }
}

class AuctionCategoryListModel {
  List<AuctionCategoryModel> categories;
  PaginationModel? pagination;

  AuctionCategoryListModel({List<AuctionCategoryModel>? categories, this.pagination}) : categories = categories ?? [];

  AuctionCategoryListModel.fromJson(Map<String, dynamic> json) : categories = [] {
    final dynamic content = json['content'] is Map ? json['content'] : json;

    if (content['data'] is List) {
      for (final dynamic category in content['data']) {
        categories.add(AuctionCategoryModel.fromJson(category));
      }
    }

    if (content['pagination'] is Map) {
      pagination = PaginationModel.fromJson(content['pagination']);
    }
  }
}
