import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_loader_widget.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/controllers/delivery_man_controller.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/delivery_man_withdraw_model.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/screens/withdraw/withdraw_card.dart';



class WithdrawListView extends StatelessWidget {
  const WithdrawListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryManController>(
      builder: (context, deliveryManProvider, child) {
        List<Withdraws> withdrawList;
        withdrawList = deliveryManProvider.withdrawList;


        return SliverMainAxisGroup(slivers: [
          withdrawList.isNotEmpty ?
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeSmall,
                vertical: Dimensions.paddingSizeSmall),
            sliver: SliverList.builder(
              itemCount: withdrawList.length,
              itemBuilder: (context, index) {
                return WithdrawCardWidget(withdraw: withdrawList[index], index: index);
              },
            ),
          ): const SliverToBoxAdapter(child: NoDataScreen()),

          SliverToBoxAdapter(
            child: deliveryManProvider.isLoading ? Container(transform: Matrix4.translationValues(0, -MediaQuery.of(context).size.height/1.5, 0),
              child: const CustomLoaderWidget()) : const SizedBox.shrink(),
          ),

        ]);
      },
    );
  }
}
