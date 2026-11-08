import 'package:sixvalley_vendor_app/features/wholesale/order/domain/models/wholesale_order_details_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/domain/models/wholesale_product_list_model.dart';

class WholesaleOrderEditCartModel {
  final int? id;
  final String? name;
  final String? thumbnail;
  final double unitPrice;
  int quantity;
  final bool isOrderProduct;

  WholesaleOrderEditCartModel({
    required this.id,
    required this.name,
    this.thumbnail,
    required this.unitPrice,
    required this.quantity,
    required this.isOrderProduct,
  });

  factory WholesaleOrderEditCartModel.fromOrderLine(WholesaleOrderDetailsModel line) {
    return WholesaleOrderEditCartModel(
      id: line.productId,
      name: line.productDetails?.name,
      thumbnail: line.wholesale?.thumbnail,
      unitPrice: line.wholesale?.unitPrice ?? line.price ?? 0,
      quantity: line.qty ?? 1,
      isOrderProduct: true,
    );
  }

  factory WholesaleOrderEditCartModel.fromProductListModel(WholesaleProductListModel product) {
    return WholesaleOrderEditCartModel(
      id: product.id,
      name: product.name,
      thumbnail: product.thumbnail,
      unitPrice: product.minPrice ?? 0,
      quantity: 1,
      isOrderProduct: false,
    );
  }
}
