import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/helper/debounce_helper.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';

class InvoiceDownloadButtonWidget extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onDownload;
  const InvoiceDownloadButtonWidget({super.key, required this.isLoading, required this.onDownload});

  @override
  State<InvoiceDownloadButtonWidget> createState() => _InvoiceDownloadButtonWidgetState();
}

class _InvoiceDownloadButtonWidgetState extends State<InvoiceDownloadButtonWidget> {
  final DebounceHelper _debounce = DebounceHelper(milliseconds: 500);

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isLoading ? null : () => _debounce.run(widget.onDownload),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: widget.isLoading
            ? Padding(
            padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: const SizedBox(height: 30, width: 30, child: CircularProgressIndicator(strokeWidth: 1)
            )) : const Padding(
          padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: CustomAssetImageWidget(Images.downloadInvoice, height: 30, width: 30),
        ),
      ),
    );
  }
}
