class OrderHelper {
  static List<String> statusListFor(String? shippingResponsibility) {
    if(shippingResponsibility == 'inhouse_shipping') {
      return ['pending', 'confirmed', 'processing'];
    }
    return ['pending', 'confirmed', 'processing', 'out_for_delivery', 'delivered', 'returned', 'failed', 'canceled'];
  }
}
