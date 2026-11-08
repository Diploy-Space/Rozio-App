import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_search_field_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/third_party_deliveryman/controllers/third_party_deliveryman_controller.dart';
import 'package:sixvalley_vendor_app/features/third_party_deliveryman/domain/models/courier_provider_model.dart';
import 'package:sixvalley_vendor_app/features/third_party_deliveryman/screens/courier_provider_config_screen.dart';
import 'package:sixvalley_vendor_app/features/third_party_deliveryman/widgets/courier_provider_card_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/features/third_party_deliveryman/widgets/courier_provider_card_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/third_party_deliveryman/controllers/wholesale_third_party_deliveryman_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class ThirdPartyDeliveryPartnerScreen extends StatelessWidget {
  const ThirdPartyDeliveryPartnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool showWholesaleTab =
        Provider.of<SplashController>(context, listen: false).configModel?.wholesaleDeliveryPartnerSetupStatus == true;

    if (!showWholesaleTab) {
      return Scaffold(
        appBar: CustomAppBarWidget(title: getTranslated('delivery_partner_integration', context)),
        body: const _DeliveryPartnerListView(),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBarWidget(title: getTranslated('delivery_partner_integration', context)),
        body: Column(children: [
          TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).hintColor,
            dividerColor: Colors.transparent,
            labelStyle: titilliumRegular.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: Dimensions.fontSizeDefault,
            ),
            tabs: [
              Tab(text: getTranslated('retail', context) ?? 'Retail'),
              Tab(text: getTranslated('wholesale', context) ?? 'Wholesale'),
            ],
          ),
          Expanded(
            child: TabBarView(children: [
              const _DeliveryPartnerListView(),
              // Wholesale carrier account — same UI, served by the wholesale courier endpoints.
              ChangeNotifierProvider<ThirdPartyDeliverymanController>.value(
                value: Provider.of<WholesaleThirdPartyDeliverymanController>(context, listen: false),
                child: const _DeliveryPartnerListView(),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _DeliveryPartnerListView extends StatefulWidget {
  const _DeliveryPartnerListView();

  @override
  State<_DeliveryPartnerListView> createState() => _DeliveryPartnerListViewState();
}

class _DeliveryPartnerListViewState extends State<_DeliveryPartnerListView> with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ThirdPartyDeliverymanController>(context, listen: false).getCourierConfig(context);
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ThirdPartyDeliverymanController>(
      builder: (context, controller, _) {
        if (controller.isLoading && controller.providers.isEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            itemCount: 6,
            itemBuilder: (_, __) => const CourierProviderCardShimmerWidget(),
          );
        }

        final List<CourierProviderModel> filteredProviders = controller.providers.where((provider) =>
            (provider.label ?? '').toLowerCase().contains(_searchQuery.toLowerCase())).toList();

        return RefreshIndicator(
          onRefresh: () => controller.getCourierConfig(context),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoBannerWidget(
                  icon: Icons.info_outline,
                  color: Theme.of(context).colorScheme.tertiary,
                  text: getTranslated('delivery_partner_config_info', context) ?? '',
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                if (!controller.hasEnabledProvider) _InfoBannerWidget(
                  icon: Icons.warning_amber_rounded,
                  color: Theme.of(context).colorScheme.error,
                  text: getTranslated('no_delivery_partner_enabled_warning', context) ?? '',
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Text(getTranslated('delivery_partner_list', context) ?? '', style: titilliumBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                )),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                CustomSearchFieldWidget(
                  controller: _searchController,
                  hint: getTranslated('search_by_delivery_partner_name', context),
                  prefix: '',
                  showCloseIcon: _searchQuery.isNotEmpty,
                  iconPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                if (filteredProviders.isEmpty)
                  const NoDataScreen(title: 'no_data_found', image: Images.noData)
                else
                  ...filteredProviders.map((provider) => CourierProviderCardWidget(
                    provider: provider,
                    onToggle: (isEnabled) => controller.toggleProvider(context, provider, isEnabled),
                    onConfigureTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider<ThirdPartyDeliverymanController>.value(
                        value: controller,
                        child: CourierProviderConfigScreen(provider: provider),
                      ),
                    )),
                  )),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoBannerWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _InfoBannerWidget({required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(child: Text(text, style: titilliumRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ))),
        ],
      ),
    );
  }
}
