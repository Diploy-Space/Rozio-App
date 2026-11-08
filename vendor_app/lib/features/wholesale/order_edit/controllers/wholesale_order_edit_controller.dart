import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order/domain/models/wholesale_order_details_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order_edit/domain/models/wholesale_order_edit_cart_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/order_edit/domain/services/wholesale_order_edit_service_interface.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/domain/models/wholesale_product_list_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productList/enums/wholesale_product_status.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';

class WholesaleOrderEditController extends ChangeNotifier {
  final WholesaleOrderEditServiceInterface wholesaleOrderEditServiceInterface;
  WholesaleOrderEditController({required this.wholesaleOrderEditServiceInterface});

  final List<WholesaleOrderEditCartModel> _cartList = [];
  List<WholesaleOrderEditCartModel> get cartList => _cartList;

  List<WholesaleProductListModel> _searchResult = [];
  List<WholesaleProductListModel> get searchResult => _searchResult;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double get orderAmount => _cartList.fold(0, (sum, item) => sum + (item.unitPrice * item.quantity));

  void setProductToCart(List<WholesaleOrderDetailsModel> lines) {
    _cartList.clear();
    for (final line in lines) {
      _cartList.add(WholesaleOrderEditCartModel.fromOrderLine(line));
    }
    notifyListeners();
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      _searchResult = [];
      notifyListeners();
      return;
    }
    _searchResult = _placeholderProducts.where((product) {
      final bool alreadyInCart = _cartList.any((cartItem) => cartItem.id == product.id);
      return !alreadyInCart &&
          product.approvalStatus == WholesaleProductStatus.approved &&
          (product.name ?? '').toLowerCase().contains(query.toLowerCase());
    }).toList();
    notifyListeners();
  }

  static final List<WholesaleProductListModel> _placeholderProducts = [
    WholesaleProductListModel(id: 1, name: 'Leather white Bag', minPrice: 35640, maxPrice: 44360, requestStatus: 1),
    WholesaleProductListModel(id: 2, name: 'Mastering the Art of Shoe: A Complete Guide to Personal', minPrice: 35640, maxPrice: 44360, requestStatus: 2),
    WholesaleProductListModel(id: 3, name: 'Mastering the Art of Hat: A Complete Guide to Personal and Intellectual Growth', minPrice: 35640, maxPrice: 44360, requestStatus: 2),
    WholesaleProductListModel(id: 4, name: 'Mastering the Art of Shoe: A Complete Guide to Personal and Intellectual', minPrice: 35640, maxPrice: 44360, requestStatus: 1),
    WholesaleProductListModel(id: 5, name: 'Leather white Bag', minPrice: 35640, maxPrice: 44360, requestStatus: 1),
    WholesaleProductListModel(id: 6, name: 'Mastering the Art of Hat: A Complete Guide to Personal and Intellectual Growth', minPrice: 35640, maxPrice: 44360, requestStatus: 1),
  ];

  void emptySearchResult() {
    _searchResult = [];
    notifyListeners();
  }

  void addToCart(WholesaleProductListModel product) {
    _cartList.add(WholesaleOrderEditCartModel.fromProductListModel(product));
    _searchResult = [];
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartList.removeAt(index);
    notifyListeners();
  }

  void setQuantity(int index, int quantity) {
    _cartList[index].quantity = quantity;
    notifyListeners();
  }

  Future<bool> editOrderSubmit(BuildContext context, int? orderId) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoading = false;
    notifyListeners();
    showCustomSnackBarWidget(getTranslated('updated_successfully', context) ?? '', context, isError: false);
    return true;
  }
}
