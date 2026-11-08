import 'package:sixvalley_vendor_app/data/model/api_envelope.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/tax_vat_model.dart';

class PricingModel {
  String? message;
  Data? data;
  int? remainingCount;

  PricingModel({this.message, this.data, this.remainingCount});

  PricingModel.fromJson(dynamic json) {
    final Map content = ApiEnvelope.content(json);

    message = ApiEnvelope.message(json);
    remainingCount = ApiEnvelope.remainingCount(json);

    final dynamic payload = content['data'];
    data = payload is Map ? Data.fromJson(Map<String, dynamic>.from(payload)) : null;
  }
}

class Data {
  double? unitPrice;
  int? minimumOrderQuantity;
  int? currentStock;
  String? discountType;
  double? discountAmount;
  double? shippingCost;
  int? isShippingCostMultil;
  List<TaxVatModel>? vatTax;
  List<int> taxIds;

  Data(
      {this.unitPrice,
        this.minimumOrderQuantity,
        this.currentStock,
        this.discountType,
        this.discountAmount,
        this.shippingCost,
        this.isShippingCostMultil,
        this.vatTax,
        this.taxIds = const []});

  Data.fromJson(Map<String, dynamic> json) : taxIds = [] {
    unitPrice = double.tryParse(json['unit_price']?.toString() ?? '');
    minimumOrderQuantity = int.tryParse(json['minimum_order_quantity']?.toString() ?? '');
    currentStock = int.tryParse(json['current_stock']?.toString() ?? '');
    discountType = json['discount_type']?.toString();
    discountAmount = double.tryParse(json['discount_amount']?.toString() ?? '');
    shippingCost = double.tryParse(json['shipping_cost']?.toString() ?? '');
    isShippingCostMultil = int.tryParse(json['is_shipping_cost_multil']?.toString() ?? '');

    final dynamic taxes = json['vatTax'] ?? json['vat_tax'] ?? json['tax_ids'];
    if (taxes is List) {
      final List<TaxVatModel> parsed = [];

      for (final dynamic tax in taxes) {
        if (tax is Map) {
          parsed.add(TaxVatModel.fromJson(Map<String, dynamic>.from(tax)));
        } else {
          final int? id = int.tryParse(tax?.toString() ?? '');
          if (id != null) taxIds.add(id);
        }
      }

      if (parsed.isNotEmpty) vatTax = parsed;
    }
  }
}
