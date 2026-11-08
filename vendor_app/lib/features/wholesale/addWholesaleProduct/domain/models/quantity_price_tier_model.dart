import 'package:flutter/material.dart';

class QuantityPriceTierModel {
  final TextEditingController minQtyController;
  final TextEditingController maxQtyController;
  final TextEditingController unitPriceController;

  QuantityPriceTierModel({
    TextEditingController? minQtyController,
    TextEditingController? maxQtyController,
    TextEditingController? unitPriceController,
  })  : minQtyController = minQtyController ?? TextEditingController(),
        maxQtyController = maxQtyController ?? TextEditingController(),
        unitPriceController = unitPriceController ?? TextEditingController();

  void dispose() {
    minQtyController.dispose();
    maxQtyController.dispose();
    unitPriceController.dispose();
  }
}
