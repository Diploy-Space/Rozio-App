import 'package:flutter/material.dart';

class OrderStatusColorHelper {
  const OrderStatusColorHelper._();

  static const double backgroundOpacity = .1;

  static Color statusTextColor(BuildContext context, String? status) {
    switch (status) {
      case 'delivered':
      case 'confirmed':
        return Theme.of(context).colorScheme.onTertiaryContainer;
      case 'pending':
        return Theme.of(context).primaryColor;
      case 'processing':
        return Theme.of(context).colorScheme.outline;
      case 'canceled':
      case 'cancelled':
      case 'failed':
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).colorScheme.secondary;
    }
  }

  static Color statusBgColor(BuildContext context, String? status) {
    return statusTextColor(context, status).withValues(alpha: backgroundOpacity);
  }

  static Color analyticsTextColor(BuildContext context, String? status) {
    switch (status) {
      case 'pending':
        return Theme.of(context).colorScheme.error;
      case 'processing':
        return Theme.of(context).colorScheme.tertiary;
      case 'confirmed':
        return Theme.of(context).colorScheme.onTertiaryContainer;
      case 'out_for_delivery':
        return Colors.deepPurpleAccent;
      default:
        return statusTextColor(context, status);
    }
  }

  static Color analyticsBgColor(BuildContext context, String? status) {
    return analyticsTextColor(context, status).withValues(alpha: backgroundOpacity);
  }
}
