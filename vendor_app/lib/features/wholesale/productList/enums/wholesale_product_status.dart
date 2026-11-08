enum WholesaleProductStatus {
  approved,
  denied,
  newProduct;

  static WholesaleProductStatus fromRequestStatus(int? value) {
    switch (value) {
      case 2:
        return WholesaleProductStatus.denied;
      case 0:
        return WholesaleProductStatus.newProduct;
      case 1:
      default:
        return WholesaleProductStatus.approved;
    }
  }

  String get stateValue {
    switch (this) {
      case WholesaleProductStatus.approved:
        return 'approved';
      case WholesaleProductStatus.denied:
        return 'denied';
      case WholesaleProductStatus.newProduct:
        return 'pending';
    }
  }

  String get translationKey {
    switch (this) {
      case WholesaleProductStatus.approved:
        return 'approved';
      case WholesaleProductStatus.denied:
        return 'denied';
      case WholesaleProductStatus.newProduct:
        return 'pending';
    }
  }
}
