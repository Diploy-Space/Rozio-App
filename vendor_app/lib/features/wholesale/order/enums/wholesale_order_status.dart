enum WholesaleOrderStatus {
  pending,
  confirmed,
  processing,
  delivered,
  failed,
  returned,
  cancelled,
  outForDelivery;

  static WholesaleOrderStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'confirmed':
        return WholesaleOrderStatus.confirmed;
      case 'processing':
        return WholesaleOrderStatus.processing;
      case 'delivered':
        return WholesaleOrderStatus.delivered;
      case 'failed':
        return WholesaleOrderStatus.failed;
      case 'returned':
        return WholesaleOrderStatus.returned;
      case 'canceled':
        return WholesaleOrderStatus.cancelled;
      case 'out_for_delivery':
        return WholesaleOrderStatus.outForDelivery;
      case 'pending':
      default:
        return WholesaleOrderStatus.pending;
    }
  }


  String get translationKey {
    switch (this) {
      case WholesaleOrderStatus.pending:
        return 'pending';
      case WholesaleOrderStatus.confirmed:
        return 'confirmed';
      case WholesaleOrderStatus.processing:
        return 'processing';
      case WholesaleOrderStatus.delivered:
        return 'delivered';
      case WholesaleOrderStatus.failed:
        return 'failed';
      case WholesaleOrderStatus.returned:
        return 'returned';
      case WholesaleOrderStatus.cancelled:
        return 'cancelled';
      case WholesaleOrderStatus.outForDelivery:
        return 'out_for_delivery';
    }
  }

  String get value {
    switch (this) {
      case WholesaleOrderStatus.cancelled:
        return 'canceled';
      case WholesaleOrderStatus.outForDelivery:
        return 'out_for_delivery';
      default:
        return name;
    }
  }
}
