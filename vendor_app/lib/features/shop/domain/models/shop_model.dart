import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/helper/json_converter.dart';

class ShopModel {
  int? id;
  String? name;
  String? address;
  String? contact;
  String? image;
  ImageFullUrl? imageFullUrl;
  String? createdAt;
  String? updatedAt;
  String? banner;
  ImageFullUrl? bannerFullUrl;
  ImageFullUrl? tinCertificateFullUrl;
  String? bottomBanner;
  ImageFullUrl? bottomBannerFullUrl;
  String? offerBanner;
  ImageFullUrl? offerBannerFullUrl;
  double? ratting;
  int? rattingCount;
  bool? temporaryClose;
  bool? wholesaleTemporaryClose;
  bool? auctionTemporaryClose;
  String? vacationEndDate;
  String? vacationStartDate;
  bool? vacationStatus;
  String? vacationDurationType;
  String? vacationNote;
  List<String>? vacationModules;
  String? taxIdentificationNumber;
  String? tinExpireDate;
  ImageFullUrl? wholesaleTinCertificateFullUrl;
  String? wholesaleTaxIdentificationNumber;
  String? wholesaleTinExpireDate;
  ImageFullUrl? auctionTinCertificateFullUrl;
  String? auctionTaxIdentificationNumber;
  String? auctionTinExpireDate;
  int? totalReview;
  int? totalOrder;
  int? totalProducts;
  ShopModuleTotals? wholesaleTotals;
  AuctionModuleTotals? auctionTotals;
  int? reorderLevel;
  Map<String, dynamic>? setupGuideApp;

  ShopModel(
      {this.id,
        this.name,
        this.address,
        this.contact,
        this.image,
        this.imageFullUrl,
        this.createdAt,
        this.updatedAt,
        this.banner,
        this.bannerFullUrl,
        this.tinCertificateFullUrl,
        this.bottomBanner,
        this.bottomBannerFullUrl,
        this.offerBanner,
        this.offerBannerFullUrl,
        this.ratting,
        this.rattingCount,
        this.temporaryClose,
        this.wholesaleTemporaryClose,
        this.auctionTemporaryClose,
        this.vacationEndDate,
        this.vacationStartDate,
        this.vacationStatus,
        this.vacationDurationType,
        this.vacationNote,
        this.vacationModules,
        this.taxIdentificationNumber,
        this.tinExpireDate,
        this.wholesaleTinCertificateFullUrl,
        this.wholesaleTaxIdentificationNumber,
        this.wholesaleTinExpireDate,
        this.auctionTinCertificateFullUrl,
        this.auctionTaxIdentificationNumber,
        this.auctionTinExpireDate,
        this.totalReview,
        this.totalOrder,
        this.totalProducts,
        this.setupGuideApp,
        this.reorderLevel,
      });

  ShopModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    contact = json['contact'];
    image = json['image'];
    imageFullUrl = json['image_full_url'] != null ? ImageFullUrl.fromJson(json['image_full_url']) : null;
    createdAt = _toLocalDateString(json['created_at']);
    updatedAt = json['updated_at'];
    banner = json['banner'];
    bottomBanner = json['bottom_banner'];
    offerBanner = json['offer_banner'];
    ratting = double.tryParse('${json['rating']}') ?? 0;
    rattingCount = json['rating_count'];
    temporaryClose = json['temporary_close'] != null ? !JsonConverter.toBool(json['temporary_close'])! : true;
    wholesaleTemporaryClose = json['wholesale_temporary_close'] != null ? !JsonConverter.toBool(json['wholesale_temporary_close'])! : true;
    auctionTemporaryClose = json['auction_temporary_close'] != null ? !JsonConverter.toBool(json['auction_temporary_close'])! : true;
    vacationEndDate = _toLocalDateString(json['vacation_end_date']);
    vacationStartDate = _toLocalDateString(json['vacation_start_date']);
    vacationStatus = JsonConverter.toBool(json['vacation_status']) ?? false;
    offerBannerFullUrl = json['offer_banner_full_url'] != null ? ImageFullUrl.fromJson(json['offer_banner_full_url']) : null;
    bannerFullUrl = json['banner_full_url'] != null ? ImageFullUrl.fromJson(json['banner_full_url']) : null;
    bottomBannerFullUrl = json['bottom_banner_full_url'] != null ? ImageFullUrl.fromJson(json['bottom_banner_full_url']) : null;
    tinCertificateFullUrl = json['tin_certificate_full_url'] != null ? ImageFullUrl.fromJson(json['tin_certificate_full_url']) : null;
    vacationDurationType = json['vacation_duration_type'] ?? 'custom';
    vacationNote = json['vacation_note'] ?? '';
    vacationModules = json['vacation_modules'] is List ? List<String>.from((json['vacation_modules'] as List).map((module) => module.toString())) : [];
    taxIdentificationNumber = json['tax_identification_number'];
    tinExpireDate = _toLocalDateString(json['tin_expire_date']);
    wholesaleTinCertificateFullUrl = json['wholesale_tin_certificate_full_url'] != null ? ImageFullUrl.fromJson(json['wholesale_tin_certificate_full_url']) : null;
    wholesaleTaxIdentificationNumber = json['wholesale_tax_identification_number'];
    wholesaleTinExpireDate = _toLocalDateString(json['wholesale_tin_expire_date']);
    auctionTinCertificateFullUrl = json['auction_tin_certificate_full_url'] != null ? ImageFullUrl.fromJson(json['auction_tin_certificate_full_url']) : null;
    auctionTaxIdentificationNumber = json['auction_tax_identification_number'];
    auctionTinExpireDate = _toLocalDateString(json['auction_tin_expire_date']);
    totalProducts = json['total_products'];
    totalOrder = json['total_orders'];
    totalReview = json['total_reviews'];
    if (json['module_totals'] is Map) {
      final Map moduleTotals = json['module_totals'];
      wholesaleTotals = moduleTotals['wholesale'] is Map ? ShopModuleTotals.fromJson(Map<String, dynamic>.from(moduleTotals['wholesale'])) : null;
      auctionTotals = moduleTotals['auction'] is Map ? AuctionModuleTotals.fromJson(Map<String, dynamic>.from(moduleTotals['auction'])) : null;
    }
    setupGuideApp = json['setup_guide_app'] != null ? Map<String, dynamic>.from(json['setup_guide_app']) : null;
    reorderLevel = json['stock_limit'] != null ? int.tryParse(json['stock_limit'].toString()) : null;
  }

  bool isModuleAvailable(String module) {
    switch (module) {
      case 'retail':
        return temporaryClose ?? false;
      case 'wholesale':
        return wholesaleTemporaryClose ?? false;
      case 'auction':
        return auctionTemporaryClose ?? false;
      default:
        return false;
    }
  }

  static String? _toLocalDateString(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString())?.toLocal().toString() ?? value.toString();
  }
}

class ShopModuleTotals {
  final int totalOrders;
  final int totalProducts;
  final int totalReviews;

  ShopModuleTotals({this.totalOrders = 0, this.totalProducts = 0, this.totalReviews = 0});

  factory ShopModuleTotals.fromJson(Map<String, dynamic> json) {
    return ShopModuleTotals(
      totalOrders: int.tryParse('${json['total_orders']}') ?? 0,
      totalProducts: int.tryParse('${json['total_products']}') ?? 0,
      totalReviews: int.tryParse('${json['total_reviews']}') ?? 0,
    );
  }
}

class AuctionModuleTotals {
  final int totalAuctionCreated;
  final int totalDelivered;

  AuctionModuleTotals({this.totalAuctionCreated = 0, this.totalDelivered = 0});

  factory AuctionModuleTotals.fromJson(Map<String, dynamic> json) {
    return AuctionModuleTotals(
      totalAuctionCreated: int.tryParse('${json['total_auction_created']}') ?? 0,
      totalDelivered: int.tryParse('${json['total_delivered']}') ?? 0,
    );
  }
}
