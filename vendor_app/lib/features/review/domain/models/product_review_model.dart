import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/features/review/domain/models/review_model.dart';

class ProductReviewModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<GroupWiseRating>? groupWiseRating;
  String? averageRating;
  List<ReviewModel>? reviews;

  ProductReviewModel(
      {this.totalSize,
        this.limit,
        this.offset,
        this.groupWiseRating,
        this.averageRating,
        this.reviews});

  ProductReviewModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['reviews']);
    totalSize = envelope.totalSize;
    limit = envelope.limit?.toString();
    offset = envelope.offset?.toString();
    if (envelope.read('group-wise-rating') is List) {
      groupWiseRating = (envelope.read('group-wise-rating') as List).map((v) => GroupWiseRating.fromJson(v)).toList();
    }
    averageRating = envelope.read('average_rating')?.toString() ?? "0";
    reviews = envelope.data?.map((v) => ReviewModel.fromJson(v)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (groupWiseRating != null) {
      data['group-wise-rating'] =
          groupWiseRating!.map((v) => v.toJson()).toList();
    }
    data['average_rating'] = averageRating;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GroupWiseRating {
  int? rating;
  int? total;

  GroupWiseRating({this.rating, this.total});

  GroupWiseRating.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating'] = rating;
    data['total'] = total;
    return data;
  }
}
