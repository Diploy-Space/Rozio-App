import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/data/model/pagination_model.dart';

class WholesaleCategoryModel {
  int? id;
  String? name;
  String? icon;
  ImageFullUrl? iconFullUrl;
  int? productCount;

  WholesaleCategoryModel({this.id, this.name, this.icon, this.iconFullUrl, this.productCount});

  WholesaleCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    iconFullUrl = json['icon_full_url'] != null ? ImageFullUrl.fromJson(json['icon_full_url']) : null;
    productCount = json['product_count'];
  }
}

class WholesaleCategoryListModel {
  List<WholesaleCategoryModel> categories;
  PaginationModel? pagination;

  WholesaleCategoryListModel({List<WholesaleCategoryModel>? categories, this.pagination}) : categories = categories ?? [];

  WholesaleCategoryListModel.fromJson(Map<String, dynamic> json) : categories = [] {
    final dynamic content = json['content'];
    if (content == null) {
      return;
    }

    if (content['data'] != null) {
      for (final dynamic category in content['data']) {
        categories.add(WholesaleCategoryModel.fromJson(category));
      }
    }

    if (content['pagination'] != null) {
      pagination = PaginationModel.fromJson(content['pagination']);
    }
  }
}
