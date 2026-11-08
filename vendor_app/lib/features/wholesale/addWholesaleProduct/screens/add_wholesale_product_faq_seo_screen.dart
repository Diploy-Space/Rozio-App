import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_bottom_nav_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_faq_form_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_faq_list_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_seo_section_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_seo_setup_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class AddWholesaleProductFaqSeoScreen extends StatefulWidget {
  final Function(int) onTabChanged;
  final VoidCallback onSubmit;
  final bool isUpdate;
  const AddWholesaleProductFaqSeoScreen({super.key, required this.onTabChanged, required this.onSubmit, this.isUpdate = false});

  @override
  State<AddWholesaleProductFaqSeoScreen> createState() => AddWholesaleProductFaqSeoScreenState();
}

class AddWholesaleProductFaqSeoScreenState extends State<AddWholesaleProductFaqSeoScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            child: Column(
              children: [
                const AddWholesaleProductFaqFormWidget(),
                SizedBox(height: Dimensions.paddingSizeLarge),

                const AddWholesaleProductFaqListWidget(),
                SizedBox(height: Dimensions.paddingSizeLarge),

                const AddWholesaleProductSeoSectionWidget(),
                SizedBox(height: Dimensions.paddingSizeLarge),

                const AddWholesaleProductSeoSetupWidget(),
              ],
            ),
          ),
        ),
        Consumer<AddWholesaleProductController>(
          builder: (context, controller, _) {
            return AddWholesaleProductBottomNavWidget(
              onGoBack: () => widget.onTabChanged(2),
              actionLabel: widget.isUpdate
                  ? (getTranslated('update', context) ?? 'Update')
                  : (getTranslated('submit', context) ?? 'Submit'),
              onAction: widget.onSubmit,
              isLoading: controller.isLoading,
            );
          },
        ),
      ],
    );
  }
}
