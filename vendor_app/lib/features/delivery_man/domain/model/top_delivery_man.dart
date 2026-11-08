import 'package:sixvalley_vendor_app/data/model/api_list_envelope.dart';
import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';

class TopDeliveryManModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<DeliveryMan>? deliveryMan;

  TopDeliveryManModel({this.totalSize, this.limit, this.offset, this.deliveryMan});

  TopDeliveryManModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['delivery_man']);
    totalSize = envelope.totalSize;
    limit = envelope.limit?.toString();
    offset = envelope.offset?.toString();
    deliveryMan = envelope.data?.map((v) => DeliveryMan.fromJson(v)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (deliveryMan != null) {
      data['delivery_man'] = deliveryMan!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveryMan {
  int? id;
  String? fName;
  String? lName;
  String? address;
  String? countryCode;
  String? phone;
  String? email;
  String? identityNumber;
  String? identityType;
  List<dynamic>? identityImage;
  List<ImageFullUrl>? identityImageFullUrl;
  String? image;
  ImageFullUrl? imageFullUrl;
  int? isOnline;
  int? isActive;
  double? averageRating;
  int? ordersCount;

  DeliveryMan(
      {this.id,
        this.fName,
        this.lName,
        this.address,
        this.countryCode,
        this.phone,
        this.email,
        this.identityNumber,
        this.identityType,
        this.identityImage,
        this.identityImageFullUrl,
        this.image,
        this.imageFullUrl,
        this.isOnline,
        this.isActive,
        this.averageRating,
        this.ordersCount
      });

  DeliveryMan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    address = json['address'];
    countryCode = json['country_code'];
    phone = json['phone'];
    email = json['email'];
    identityNumber = json['identity_number'];
    identityType = json['identity_type'];
    if(json['identity_image'] != null  && json['identity_image'] is List){
      // identityImage = jsonDecode(json['identity_image']);
    }
    final dynamic identityImages = json['identity_image_full_url'];
    if (identityImages is List) {
      identityImageFullUrl = identityImages.map((v) => ImageFullUrl.fromJson(v)).toList();
    } else if (identityImages is Map) {
      identityImageFullUrl = [ImageFullUrl.fromJson(Map<String, dynamic>.from(identityImages))];
    } else {
      identityImageFullUrl = [];
    }
    image = json['image'];
    isOnline = int.parse(json['is_online'].toString());
    isActive = int.tryParse('${json['is_active']}');
    averageRating = double.tryParse('${json['average_rating']}') ?? 0;
    ordersCount = int.tryParse('${json['orders_count']}') ?? 0;
    imageFullUrl = json['image_full_url'] != null ? ImageFullUrl.fromJson(json['image_full_url']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['address'] = address;
    data['country_code'] = countryCode;
    data['phone'] = phone;
    data['email'] = email;
    data['identity_number'] = identityNumber;
    data['identity_type'] = identityType;
    data['identity_image'] = identityImage;
    data['image'] = image;
    data['is_online'] = isOnline;
    data['is_active'] = isActive;
    data['average_rating'] = averageRating;
    data['orders_count'] = ordersCount;
    return data;
  }
}
