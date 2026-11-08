import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/emergency_contract/domain/models/emergency_contact_model.dart';
import 'package:sixvalley_vendor_app/features/emergency_contract/controllers/emergency_contact_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_loader_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/emergency_contract/widgets/emergency_contact_card_widget.dart';



class EmergencyContactListViewWidget extends StatelessWidget {
  const EmergencyContactListViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmergencyContactController>(
      builder: (context, emergencyContactProvider, child) {
        List<ContactList> contactList;
        contactList = !emergencyContactProvider.isSearchActive ? emergencyContactProvider.contactList : emergencyContactProvider.contactSearchList;


        return SliverMainAxisGroup(slivers: [
          !emergencyContactProvider.isLoading ? contactList.isNotEmpty ?
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeSmall,
                vertical: Dimensions.paddingSizeSmall),
            sliver: SliverList.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                return EmergencyContactCardWidget(contactList: contactList[index], index: index);
              },
            ),
          ): SliverToBoxAdapter(child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/4),
            child: const NoDataScreen(),
          )) : SliverToBoxAdapter(child: Container(transform: Matrix4.translationValues(0, -MediaQuery.of(context).size.height/2.5, 0),
              child: const CustomLoaderWidget())),

          SliverToBoxAdapter(child: emergencyContactProvider.isLoading ? Center(child: Padding(
            padding: const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : const SizedBox.shrink()),

        ]);
      },
    );
  }
}
