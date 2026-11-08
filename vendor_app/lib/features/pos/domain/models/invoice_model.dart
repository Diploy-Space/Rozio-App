// import 'package:sixvalley_vendor_app/features/addProduct/domain/models/edt_product_model.dart';

import '../../../product/domain/models/product_model.dart';

class InvoiceModel {
  double? orderAmount;
  double? paidAmount;
  String? createdAt;
  double? discountAmount;
  double? extraDiscount;
  String? extraDiscountType;
  String? paymentMethod;
  List<Details>? details;
  double? totalTaxAmount;

  InvoiceModel(
    {
      this.orderAmount,
      this.paidAmount,
      this.createdAt,
      this.extraDiscount,
      this.extraDiscountType,
      this.paymentMethod,
      this.details,
      this.totalTaxAmount
    }
  );

  InvoiceModel.fromJson(Map<String, dynamic> raw) {
    // v6 envelope: the order is under content.data (v3 had it at the root).
    final dynamic content = raw['content'];
    final Map<String, dynamic> json = (content is Map && content['data'] is Map)
        ? Map<String, dynamic>.from(content['data'])
        : raw;

    if(json['order_amount'] != null){
      orderAmount = double.tryParse(json['order_amount'].toString());
    }

    if(json['paid_amount'] != null){
      paidAmount = double.tryParse(json['paid_amount'].toString());
    }

    createdAt = json['created_at'];
    paymentMethod = json['payment_method'];

    // v6's invoice response doesn't include discount/tax breakdown fields;
    // callers already fall back to 0 when these are null.
    if(json['discount_amount'] != null){
      discountAmount = double.tryParse(json['discount_amount'].toString());
    }
    if(json['extra_discount'] != null){
      extraDiscount = double.tryParse(json['extra_discount'].toString());
    }

    extraDiscountType = json['extra_discount_type'];

    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(Details.fromJson(Map<String, dynamic>.from(v)));
      });
    }

    if (json['total_tax_amount'] != null) {
      totalTaxAmount = double.tryParse(json['total_tax_amount'].toString())  ;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_amount'] = orderAmount;
    data['paid_amount'] = paidAmount;
    data['created_at'] = createdAt;
    data['discount_amount'] = discountAmount;
    data['extra_discount'] = extraDiscount;
    data['payment_method'] = paymentMethod;
    data['total_tax_amount'] = totalTaxAmount;
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  int? id;
  ProductDetails? productDetails;
  int? qty;
  double? price;
  double? tax;
  double? discount;
  String? discountType;
  String? variant;
  String? taxModel;


  Details(
      {this.id,
        this.productDetails,
        this.qty,
        this.price,
        this.tax,
        this.discount,
        this.discountType,
        this.variant,
        this.taxModel
        });

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productDetails = json['product_details'] != null
        ? ProductDetails.fromJson(json['product_details'])
        : null;
    qty = json['qty'];
    if(json['price'] != null){
      try{
        price = json['price'].toDouble();
      }catch(e){
        price = double.parse(json['price'].toString());
      }
    }

    if(json['tax'] != null){
      try{
        tax = json['tax'].toDouble();
      }catch(e){
        tax = double.parse(json['tax'].toString());
      }
    }

    if(json['discount'] != null){
      try{
        discount = json['discount'].toDouble();
      }catch(e){
        discount = double.parse(json['discount'].toString());
      }
    }
    discountType = json['discount_type'];

    variant = json['variant'];

    taxModel = json['tax_model'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (productDetails != null) {
      data['product_details'] = productDetails!.toJson();
    }
    data['qty'] = qty;
    data['price'] = price;
    data['tax'] = tax;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['variant'] = variant;
    return data;
  }
}

class ProductDetails {

  String? name;
  String? taxModel;
  double? discount;
  double? unitPrice;
  String? discountType;
  String? productType;
  List<Variation>? variation;
  List<DigitalVariation>? digitalVariation;
  ClearanceSale? clearanceSale;
  double? tax;

  ProductDetails(
    {
      this.name,
      this.taxModel,
      this.discount,
      this.discountType,
      this.variation,
      this.digitalVariation,
      this.productType,
      this.unitPrice,
      this.clearanceSale,
      this.tax
    });

  ProductDetails.fromJson(Map<String, dynamic> json) {

    name = json['name'];
    taxModel = json['tax_model'];
    discount = json['discount'] != null ? double.tryParse(json['discount'].toString()) : 0;
    discountType = json['discount_type'];
    productType = json['product_type'];
    // v6's invoice line items omit unit_price entirely; default to 0 instead of crashing.
    unitPrice = json['unit_price'] != null ? double.tryParse(json['unit_price'].toString()) : 0;

    if (json['variation'] != null && json['category_ids'] is !String) {
      variation = [];
      json['variation'].forEach((v) {
        variation!.add(Variation.fromJson(v));
      });
    }

    if (json['digital_variation'] != null) {
      digitalVariation = <DigitalVariation>[];
      json['digital_variation'].forEach((v) {
        digitalVariation!.add(DigitalVariation.fromJson(v));
      });
    }

    clearanceSale = json['clearance_sale'] != null ? ClearanceSale.fromJson(json['clearance_sale']) : null;
    tax =  json['tax'] != null ? double.tryParse(json['tax'].toString()) : 0;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['discount'] = taxModel;
    data['tax_model'] = taxModel;

    return data;
  }
}

