enum WholesaleRefundStatus {
  pending,
  approved,
  rejected,
  refunded;

  static WholesaleRefundStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'approved':
        return WholesaleRefundStatus.approved;
      case 'rejected':
        return WholesaleRefundStatus.rejected;
      case 'refunded':
        return WholesaleRefundStatus.refunded;
      case 'pending':
      default:
        return WholesaleRefundStatus.pending;
    }
  }

  String get translationKey {
    switch (this) {
      case WholesaleRefundStatus.pending:
        return 'pending';
      case WholesaleRefundStatus.approved:
        return 'approved';
      case WholesaleRefundStatus.rejected:
        return 'rejected';
      case WholesaleRefundStatus.refunded:
        return 'refunded';
    }
  }

  String get value => name;
}
