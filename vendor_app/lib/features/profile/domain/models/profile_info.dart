import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/helper/json_converter.dart';

class ProfileInfoModel {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? image;
  ImageFullUrl? imageFullUrl;
  String? email;
  String? password;
  String? status;
  String? rememberToken;
  String? createdAt;
  String? updatedAt;
  String? bankName;
  String? branch;
  String? accountNo;
  String? holderName;
  String? authToken;
  double? salesCommissionPercentage;
  String? gst;
  int? productCount;
  int? posActive;
  int? ordersCount;
  Wallet? wallet;
  double? minimumOrderAmount;
  double? freeOverDeliveryAmount;
  int? freeOverDeliveryAmountStatus;
  double? wholesaleFreeOverDeliveryAmount;
  int? wholesaleFreeOverDeliveryAmountStatus;
  double? auctionTotalEarning;
  double? auctionTotalVat;
  double? auctionTotalShipping;
  double? auctionWithdrawableBalance;
  double? auctionPendingWithdraw;
  double? auctionTotalCommissionGiven;
  double? auctionPendingCommission;
  double? auctionTotalPendingAmount;
  bool? auctionWalletVisible;
  bool? showAuctionMenuForVendor;
  bool? isVerified;

  ProfileInfoModel(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.image,
        this.imageFullUrl,
        this.email,
        this.password,
        this.status,
        this.rememberToken,
        this.createdAt,
        this.updatedAt,
        this.bankName,
        this.branch,
        this.accountNo,
        this.holderName,
        this.authToken,
        this.salesCommissionPercentage,
        this.gst,
        this.posActive,
        this.productCount,
        this.ordersCount,
        this.wallet,
        this.minimumOrderAmount,
        this.freeOverDeliveryAmount,
        this.freeOverDeliveryAmountStatus,
        this.wholesaleFreeOverDeliveryAmount,
        this.wholesaleFreeOverDeliveryAmountStatus,
        this.auctionTotalEarning,
        this.auctionTotalVat,
        this.auctionTotalShipping,
        this.auctionWithdrawableBalance,
        this.auctionPendingWithdraw,
        this.auctionTotalCommissionGiven,
        this.auctionPendingCommission,
        this.auctionTotalPendingAmount,
        this.auctionWalletVisible,
        this.showAuctionMenuForVendor,
        this.isVerified,
      });

  ProfileInfoModel.fromJson(Map<String, dynamic> response) {
    // v6 wraps the profile in `content.data`; v3 was flat.
    final dynamic content = response['content'];
    final Map<String, dynamic> json = content is Map && content['data'] is Map
        ? Map<String, dynamic>.from(content['data'])
        : response;

    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    image = json['image'];
    email = json['email'];
    password = json['password'];
    status = json['status'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bankName = json['bank_name'];
    branch = json['branch'];
    accountNo = json['account_no'];
    holderName = json['holder_name'];
    authToken = json['auth_token'];
    salesCommissionPercentage = double.tryParse(json['sales_commission_percentage'].toString());
    gst = json['gst'];
    posActive = int.tryParse(json['pos_status'].toString()) ?? 0;
    productCount = json['product_count'];
    ordersCount = json['orders_count'];
    wallet = json['wallet'] is Map ? Wallet.fromJson(Map<String, dynamic>.from(json['wallet'])) : null;
    minimumOrderAmount = double.tryParse(json['minimum_order_amount'].toString()) ?? 0;
    freeOverDeliveryAmount = double.tryParse(json['free_delivery_over_amount'].toString()) ?? 0;
    freeOverDeliveryAmountStatus = int.tryParse(json['free_delivery_status'].toString()) ?? 0;
    wholesaleFreeOverDeliveryAmount = double.tryParse(json['wholesale_free_delivery_over_amount'].toString()) ?? 0;
    wholesaleFreeOverDeliveryAmountStatus = int.tryParse(json['wholesale_free_delivery_status'].toString()) ?? 0;

    auctionTotalEarning = double.tryParse(json['auction_total_earning'].toString());
    auctionTotalVat = double.tryParse(json['auction_total_vat'].toString());
    auctionTotalShipping = double.tryParse(json['auction_total_shipping'].toString());
    auctionWithdrawableBalance = double.tryParse(json['auction_withdrawable_balance'].toString());
    auctionPendingWithdraw = double.tryParse(json['auction_pending_withdraw'].toString());
    auctionTotalCommissionGiven = double.tryParse(json['auction_total_commission_given'].toString());
    auctionPendingCommission = double.tryParse(json['auction_pending_commission'].toString());
    auctionTotalPendingAmount = double.tryParse(json['auction_total_pending_amount'].toString());
    // v6 always sends real booleans; v3 sometimes sent '1'/1 for these three.
    auctionWalletVisible = JsonConverter.toBool(json['auction_wallet_visible']) ?? false;
    showAuctionMenuForVendor = JsonConverter.toBool(json['show_auction_menu_for_vendor']) ?? false;
    isVerified = JsonConverter.toBool(json['is_verified']) ?? false;

    imageFullUrl = json['image_full_url'] is Map
        ? ImageFullUrl.fromJson(Map<String, dynamic>.from(json['image_full_url']))
        : null;
  }


}

class Wallet {
  int? id;
  double? totalEarning;
  double? withdrawn;
  String? createdAt;
  String? updatedAt;
  double? commissionGiven;
  double? pendingWithdraw;
  double? deliveryChargeEarned;
  double? collectedCash;
  double? totalTaxCollected;

  Wallet(
      {this.id,
        this.totalEarning,
        this.withdrawn,
        this.createdAt,
        this.updatedAt,
        this.commissionGiven,
        this.pendingWithdraw,
        this.deliveryChargeEarned,
        this.collectedCash,
        this.totalTaxCollected});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalEarning = double.tryParse(json['total_earning'].toString()) ?? 0;
    withdrawn = double.tryParse(json['withdrawn'].toString()) ?? 0;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    commissionGiven = double.tryParse(json['commission_given'].toString()) ?? 0;
    pendingWithdraw = double.tryParse(json['pending_withdraw'].toString()) ?? 0;
    deliveryChargeEarned = double.tryParse(json['delivery_charge_earned'].toString()) ?? 0;
    collectedCash = double.tryParse(json['collected_cash'].toString()) ?? 0;
    totalTaxCollected = double.tryParse(json['total_tax_collected'].toString()) ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['total_earning'] = totalEarning;
    data['withdrawn'] = withdrawn;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['commission_given'] = commissionGiven;
    data['pending_withdraw'] = pendingWithdraw;
    data['delivery_charge_earned'] = deliveryChargeEarned;
    data['collected_cash'] = collectedCash;
    data['total_tax_collected'] = totalTaxCollected;
    return data;
  }
}
