import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/third_party_deliveryman/controllers/third_party_deliveryman_controller.dart';
import 'package:sixvalley_vendor_app/features/third_party_deliveryman/domain/models/courier_enabled_provider_model.dart';
import 'package:sixvalley_vendor_app/features/third_party_deliveryman/domain/models/courier_location_option_model.dart';
import 'package:sixvalley_vendor_app/features/third_party_deliveryman/domain/models/courier_provider_model.dart';
import 'package:sixvalley_vendor_app/features/third_party_deliveryman/widgets/send_to_courier_confirmation_dialog.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

// A first booking (POST /courier/dispatch), a revise of an already-booked
// order's details (POST /courier/revise - no carrier call), or a switch to
// a different partner (POST /courier/dispatch with replace_existing: true).
enum SendToCourierMode { book, revise, switchPartner }

class SendToCourierScreen extends StatefulWidget {
  final int orderId;
  final CourierEnabledProviderModel provider;
  final String recipientName;
  final String recipientPhone;
  final String recipientAddress;
  final double codAmount;
  final double? orderValue;
  final String? latitude;
  final String? longitude;
  final Map<String, dynamic>? initialDispatchDetails;
  final SendToCourierMode mode;

  const SendToCourierScreen({
    super.key,
    required this.orderId,
    required this.provider,
    required this.recipientName,
    required this.recipientPhone,
    required this.recipientAddress,
    required this.codAmount,
    this.orderValue,
    this.latitude,
    this.longitude,
    this.initialDispatchDetails,
    this.mode = SendToCourierMode.book,
  });

  @override
  State<SendToCourierScreen> createState() => _SendToCourierScreenState();
}

class _SendToCourierScreenState extends State<SendToCourierScreen> {
  late final Map<String, TextEditingController> _controllers;
  String? _selectedDeliveryTypeId;

  double? _estimateTotal;
  String? _estimateCurrency;
  String? _estimateMessage;

  List<CourierLocationOptionModel> _storeOptions = [];
  List<CourierLocationOptionModel> _cityOptions = [];
  List<CourierLocationOptionModel> _zoneOptions = [];
  List<CourierLocationOptionModel> _areaOptions = [];

  bool _isLoadingStores = false;
  bool _isLoadingCities = false;
  bool _isLoadingZones = false;
  bool _isLoadingAreas = false;

  String? _locationErrorMessage;

  bool get _isCatalogMode => widget.provider.addressMode == 'catalog';
  bool get _hasStoreField => (widget.provider.optionalFields ?? []).contains('store_id');
  bool get _hasZoneLevel => (widget.provider.levels ?? []).contains('zone');

  // Providers with a design-prescribed field order (one field per row on
  // mobile), distinct from the generic key-driven layout built from
  // required_fields/optional_fields — see _buildOrderedFields. A provider
  // with no entry here (e.g. DHL, Aramex) just falls back to that generic
  // layout untouched.
  static const Map<String, List<String>> _customFieldOrders = {
    'lalamove': [
      'recipient_name',
      'recipient_phone',
      'cod_amount',
      'recipient_address',
      'latitude',
      'longitude',
      'delivery_type',
      'weight',
      'quantity',
      'item_description',
      'note',
    ],
    'redx': [
      'store_id',
      'recipient_name',
      'recipient_phone',
      'cod_amount',
      'recipient_address',
      'area_id',
      'weight',
      'quantity',
      'item_description',
      'note',
    ],
    'pathao': [
      'store_id',
      'recipient_name',
      'recipient_phone',
      'cod_amount',
      'recipient_address',
      'city_id',
      'zone_id',
      'area_id',
      'delivery_type',
      'weight',
      'quantity',
      'item_description',
      'note',
    ],
  };

  List<String>? get _customFieldOrder => _customFieldOrders[widget.provider.id];

  @override
  void initState() {
    super.initState();
    final List<String> allFields = {
      ...?widget.provider.requiredFields,
      ...(widget.provider.optionalFields ?? <String>[]).where((key) => key != 'delivery_type'),
    }.toList();
    _controllers = {
      for (final key in allFields)
        key: TextEditingController(text: _initialValueFor(key)),
    };
    _selectedDeliveryTypeId = widget.initialDispatchDetails?['delivery_type']?.toString();

    if (_hasStoreField) _loadStores();

    if (_isCatalogMode) {
      if (widget.initialDispatchDetails != null) {
        _seedLocationOptions();
      } else {
        final List<String> levels = widget.provider.levels ?? [];
        if (levels.contains('city')) {
          _loadCities();
        } else if (levels.contains('area')) {
          // e.g. RedX: no cascade, a single flat area list.
          _loadAreas('all');
        }
      }
    }
  }

  // Populates the city/zone/area dropdown option lists to match the values
  // already seeded into the controllers from initialDispatchDetails, without
  // going through _loadZones/_loadAreas (which reset the very fields we're
  // trying to preserve — appropriate for user-driven cascades, not preload).
  Future<void> _seedLocationOptions() async {
    final List<String> levels = widget.provider.levels ?? [];
    if (levels.contains('city')) {
      await _loadCities();
      if (!mounted) return;
      final String? cityId = _textOf('city_id');
      if (cityId == null) return;
      if (levels.contains('zone')) {
        await _fetchZoneOptions(cityId);
        if (!mounted) return;
        final String? zoneId = _textOf('zone_id');
        if (zoneId != null) await _fetchAreaOptions(zoneId);
      } else if (levels.contains('area')) {
        await _fetchAreaOptions(cityId);
      }
    } else if (levels.contains('area')) {
      await _fetchAreaOptions('all');
    }
  }

  void _setFieldValue(String key, String? value) {
    _controllers[key]?.text = value ?? '';
  }

  Future<void> _loadStores() async {
    setState(() => _isLoadingStores = true);
    final controller = Provider.of<ThirdPartyDeliverymanController>(context, listen: false);
    final result = await controller.getPickupStores(context, widget.provider.id ?? '');
    if (!mounted) return;
    setState(() {
      _isLoadingStores = false;
      _storeOptions = result.supported ? result.options : [];
    });
  }

  Future<void> _loadCities() async {
    setState(() => _isLoadingCities = true);
    final controller = Provider.of<ThirdPartyDeliverymanController>(context, listen: false);
    final result = await controller.getCities(context, widget.provider.id ?? '');
    if (!mounted) return;
    setState(() {
      _isLoadingCities = false;
      _cityOptions = result.options;
    });
    _handleLocationLoadResult(result.options, result.message);
  }

  Future<void> _loadZones(String cityId) async {
    setState(() {
      _zoneOptions = [];
      _areaOptions = [];
      _setFieldValue('zone_id', null);
      _setFieldValue('area_id', null);
    });
    await _fetchZoneOptions(cityId);
  }

  Future<void> _loadAreas(String zoneId) async {
    setState(() {
      _areaOptions = [];
      _setFieldValue('area_id', null);
    });
    await _fetchAreaOptions(zoneId);
  }

  // Fetch-only variants used both by the user-driven cascade above (which
  // resets the dependent field first) and by _seedLocationOptions (which
  // must NOT clear the value it's trying to preload options for).
  Future<void> _fetchZoneOptions(String cityId) async {
    setState(() => _isLoadingZones = true);
    final controller = Provider.of<ThirdPartyDeliverymanController>(context, listen: false);
    final result = await controller.getZones(context, widget.provider.id ?? '', cityId);
    if (!mounted) return;
    setState(() {
      _isLoadingZones = false;
      _zoneOptions = result.options;
    });
    _handleLocationLoadResult(result.options, result.message);
  }

  Future<void> _fetchAreaOptions(String zoneId) async {
    setState(() => _isLoadingAreas = true);
    final controller = Provider.of<ThirdPartyDeliverymanController>(context, listen: false);
    final result = await controller.getAreas(context, widget.provider.id ?? '', zoneId);
    if (!mounted) return;
    setState(() {
      _isLoadingAreas = false;
      _areaOptions = result.options;
    });
    _handleLocationLoadResult(result.options, result.message);
  }

  void _handleLocationLoadResult(List<CourierLocationOptionModel> options, String? message) {
    if (options.isEmpty && message != null && message.isNotEmpty) {
      final String toastMessage = '${getTranslated('could_not_load_options_from_the_delivery_partner', context) ?? 'Could not load options from the delivery partner'}: $message';
      setState(() => _locationErrorMessage = toastMessage);
      showCustomSnackBarWidget(toastMessage, context, sanckBarType: SnackBarType.error);
    } else {
      setState(() => _locationErrorMessage = null);
    }
  }

  String _initialValueFor(String key) {
    final dynamic seeded = widget.initialDispatchDetails?[key];
    if (seeded != null && seeded.toString().trim().isNotEmpty) return seeded.toString();

    switch (key) {
      case 'recipient_name': return widget.recipientName;
      case 'recipient_phone': return widget.recipientPhone;
      case 'recipient_address': return widget.recipientAddress;
      case 'cod_amount': return widget.codAmount.toStringAsFixed(2);
      case 'order_value': return widget.orderValue?.toStringAsFixed(2) ?? '';
      case 'item_description': return 'Order #${widget.orderId}';
      case 'latitude': return widget.latitude ?? '';
      case 'longitude': return widget.longitude ?? '';
      default: return '';
    }
  }

  void _reset() {
    for (final entry in _controllers.entries) {
      entry.value.text = _initialValueFor(entry.key);
    }
    setState(() {
      _selectedDeliveryTypeId = widget.initialDispatchDetails?['delivery_type']?.toString();
      _estimateTotal = null;
      _estimateCurrency = null;
      _estimateMessage = null;
      if (_hasZoneLevel) {
        _zoneOptions = [];
        _areaOptions = [];
      }
    });
    if (_isCatalogMode && widget.initialDispatchDetails != null) {
      _seedLocationOptions();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _validate() {
    for (final key in widget.provider.requiredFields ?? <String>[]) {
      if ((_controllers[key]?.text.trim() ?? '').isEmpty) {
        showCustomSnackBarWidget(
          '${getTranslated(key, context) ?? key} ${getTranslated('is_required', context) ?? 'is required'}',
          context,
          sanckBarType: SnackBarType.warning,
        );
        return false;
      }
    }
    return true;
  }

  String? _textOf(String key) {
    final String? text = _controllers[key]?.text.trim();
    return (text == null || text.isEmpty) ? null : text;
  }

  num? _numOf(String key) {
    final String? text = _textOf(key);
    return text == null ? null : num.tryParse(text);
  }

  Map<String, dynamic> _buildEstimateBody() {
    return {
      'provider': widget.provider.id,
      'store_id': _textOf('store_id'),
      'weight': _numOf('weight'),
      'cod_amount': _numOf('cod_amount') ?? widget.codAmount,
      'city_id': _textOf('city_id'),
      'zone_id': _textOf('zone_id'),
      'area_id': _textOf('area_id'),
      'country_code': _textOf('country_code'),
      'postal_code': _textOf('postal_code'),
      'city_name': _textOf('city_name'),
      'latitude': _textOf('latitude'),
      'longitude': _textOf('longitude'),
      'source_branch': null,
      'source_branch_id': null,
      'destination_branch': _textOf('destination_branch'),
      'destination_branch_id': null,
      'recipient_address': _textOf('recipient_address'),
      'delivery_type': _selectedDeliveryTypeId,
    };
  }

  Future<void> _estimate() async {
    final bool hasWeight = _numOf('weight') != null;
    final bool hasLocationSignal = ['area_id', 'zone_id', 'city_id', 'latitude', 'longitude', 'postal_code', 'city_name', 'destination_branch']
        .any((key) => _textOf(key) != null);

    if (!hasWeight || !hasLocationSignal) {
      final String hint = getTranslated('fill_weight_and_location_then_estimate', context) ?? '';
      setState(() {
        _estimateTotal = null;
        _estimateCurrency = null;
        _estimateMessage = hint;
      });
      showCustomSnackBarWidget(hint, context, sanckBarType: SnackBarType.warning);
      return;
    }

    final controller = Provider.of<ThirdPartyDeliverymanController>(context, listen: false);
    final result = await controller.estimateDeliveryCharge(context, _buildEstimateBody());

    if (!mounted) return;
    setState(() {
      if (!result.ok) {
        _estimateTotal = null;
        _estimateCurrency = null;
        _estimateMessage = result.message ?? getTranslated('something_went_wrong', context);
      } else if (!result.supported) {
        _estimateTotal = null;
        _estimateCurrency = null;
        _estimateMessage = getTranslated('estimate_not_supported', context);
      } else {
        _estimateTotal = result.total;
        _estimateCurrency = result.currency;
        _estimateMessage = null;
      }
    });
  }

  Map<String, dynamic> _buildDispatchBody() {
    return {
      'provider': widget.provider.id,
      'host_order_reference': widget.orderId.toString(),
      if (widget.mode == SendToCourierMode.switchPartner) 'replace_existing': true,

      'recipient_name': _textOf('recipient_name'),
      'recipient_phone': _textOf('recipient_phone'),
      'recipient_address': _textOf('recipient_address'),

      'store_id': _textOf('store_id'),

      'city_id': _textOf('city_id'),
      'zone_id': _textOf('zone_id'),
      'area_id': _textOf('area_id'),

      'country_code': _textOf('country_code'),
      'postal_code': _textOf('postal_code'),
      'city_name': _textOf('city_name'),
      'state_province': _textOf('state_province'),

      'latitude': _textOf('latitude'),
      'longitude': _textOf('longitude'),

      'source_branch': _textOf('source_branch'),
      'source_branch_id': _textOf('source_branch_id'),
      'destination_branch': _textOf('destination_branch'),
      'destination_branch_id': _textOf('destination_branch_id'),

      'weight': _numOf('weight'),
      'quantity': _numOf('quantity'),
      'cod_amount': _numOf('cod_amount') ?? widget.codAmount,
      'order_value': _numOf('order_value') ?? widget.orderValue,
      'item_description': _textOf('item_description') ?? 'Order #${widget.orderId}',
      'delivery_type': _selectedDeliveryTypeId,
      'note': _textOf('note'),
    };
  }

  Future<void> _submit() async {
    if (!_validate()) return;

    final bool isRevise = widget.mode == SendToCourierMode.revise;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => isRevise
          ? const ReviseDeliveryConfirmationDialog()
          : SendToCourierConfirmationDialog(providerLabel: widget.provider.label ?? ''),
    );
    if (confirmed != true) return;
    if (!mounted) return;

    final controller = Provider.of<ThirdPartyDeliverymanController>(context, listen: false);
    final body = _buildDispatchBody();
    final result = isRevise
        ? await controller.reviseDeliveryDetails(context, body)
        : await controller.sendToCourier(context, body);

    if (!mounted) return;

    if (result.success) {
      // Pop first, then let the screen we return to show the confirmation —
      // showing a SnackBar here and popping in the same frame raced with the
      // page transition and left this screen rendering a broken, empty layout.
      final String fallbackMessage = isRevise
          ? getTranslated('delivery_information_updated_successfully', context) ?? ''
          : getTranslated('sent_to_courier_successfully', context) ?? '';
      Navigator.of(context).pop(result.message.isNotEmpty ? result.message : fallbackMessage);
    } else {
      showCustomSnackBarWidget(
        result.message.isNotEmpty ? result.message : getTranslated('something_went_wrong', context),
        context,
        sanckBarType: SnackBarType.error,
      );
    }
  }

  bool _isRequiredField(String key) => (widget.provider.requiredFields ?? <String>[]).contains(key);

  String? _hintFor(String key) {
    switch (key) {
      case 'weight': return 'Ex: 0.5';
      case 'quantity': return 'Ex: 1';
      case 'item_description': return 'Ex: Cotton t-shirts';
      case 'note': return 'Ex: Handle with care';
      default: return null;
    }
  }

  Widget _buildDeliveryTypeDropdown() {
    return _DeliveryTypeDropdown(
      deliveryTypes: widget.provider.deliveryTypes ?? [],
      selectedValue: _selectedDeliveryTypeId,
      isRequired: _isRequiredField('delivery_type'),
      onChanged: (value) => setState(() => _selectedDeliveryTypeId = value),
    );
  }

  List<Widget> _buildOrderedFields(List<String> order) {
    return order.map(_buildField).toList();
  }

  Widget _buildField(String key) {
    switch (key) {
      case 'city_id': return _buildCityDropdown();
      case 'zone_id': return _buildZoneDropdown();
      case 'area_id': return _buildAreaDropdown();
      case 'store_id': return _buildStoreDropdown();
      case 'delivery_type': return _buildDeliveryTypeDropdown();
      case 'weight': return _WeightField(controller: _controllers['weight'], isRequired: _isRequiredField('weight'));
    }

    final bool isNumeric = key == 'cod_amount' || key == 'latitude' || key == 'longitude'
        || key == 'quantity' || key == 'order_value';
    final int maxLine = key == 'recipient_address' || key == 'note' ? 3 : 1;

    return _GenericField(
      fieldKey: key,
      controller: _controllers[key],
      isRequired: _isRequiredField(key),
      isNumeric: isNumeric,
      maxLine: maxLine,
      hintText: _hintFor(key),
    );
  }

  Widget _buildCityDropdown() {
    return _OptionDropdown(
      labelKey: 'city_id',
      isRequired: _isRequiredField('city_id'),
      value: _textOf('city_id'),
      options: _cityOptions,
      isLoading: _isLoadingCities,
      enabled: true,
      hasLocationError: _locationErrorMessage != null,
      onChanged: (value) {
        setState(() => _setFieldValue('city_id', value));
        if (value != null) _loadZones(value);
      },
    );
  }

  Widget _buildZoneDropdown() {
    return _OptionDropdown(
      labelKey: 'zone_id',
      isRequired: _isRequiredField('zone_id'),
      value: _textOf('zone_id'),
      options: _zoneOptions,
      isLoading: _isLoadingZones,
      enabled: _textOf('city_id') != null,
      hasLocationError: _locationErrorMessage != null,
      onChanged: (value) {
        setState(() => _setFieldValue('zone_id', value));
        if (value != null) _loadAreas(value);
      },
    );
  }

  Widget _buildAreaDropdown() {
    final bool enabled = !_hasZoneLevel || _textOf('zone_id') != null;
    return _OptionDropdown(
      labelKey: 'area_id',
      isRequired: _isRequiredField('area_id'),
      value: _textOf('area_id'),
      options: _areaOptions,
      isLoading: _isLoadingAreas,
      enabled: enabled,
      hasLocationError: _locationErrorMessage != null,
      onChanged: (value) => setState(() => _setFieldValue('area_id', value)),
    );
  }

  Widget _buildStoreDropdown() {
    return _OptionDropdown(
      labelKey: 'store_id',
      isRequired: _isRequiredField('store_id'),
      value: _textOf('store_id'),
      options: _storeOptions,
      isLoading: _isLoadingStores,
      enabled: true,
      hasLocationError: _locationErrorMessage != null,
      onChanged: (value) => setState(() => _setFieldValue('store_id', value)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final requiredFields = widget.provider.requiredFields ?? [];
    final optionalFields = (widget.provider.optionalFields ?? []).where((key) => key != 'delivery_type').toList();
    final deliveryTypes = widget.provider.deliveryTypes ?? [];

    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated(
        switch (widget.mode) {
          SendToCourierMode.revise => 'update_delivery_information',
          SendToCourierMode.switchPartner => 'switch_delivery_partner',
          SendToCourierMode.book => 'send_to_courier',
        },
        context,
      )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.provider.label ?? '', style: titilliumBold.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            )),

            if (_locationErrorMessage != null) ...[
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.08),
                  border: Border.all(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.35)),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error_outline, size: 18, color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Text(_locationErrorMessage!, style: titilliumRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).colorScheme.error,
                      )),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: Dimensions.paddingSizeDefault),

            if (_customFieldOrder != null)
              ..._buildOrderedFields(_customFieldOrder!)
            else ...[
              ...requiredFields.map(_buildField),
              ...optionalFields.map(_buildField),
              if (deliveryTypes.isNotEmpty) _buildDeliveryTypeDropdown(),
            ],

            _EstimateCard(
              estimateTotal: _estimateTotal,
              estimateCurrency: _estimateCurrency,
              estimateMessage: _estimateMessage,
              onEstimate: _estimate,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: CustomButtonWidget(
                  isColor: true,
                  btnTxt: getTranslated('reset', context),
                  backgroundColor: Theme.of(context).hintColor.withValues(alpha: .1),
                  fontColor: Theme.of(context).textTheme.bodyLarge?.color,
                  onTap: _reset,),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: Consumer<ThirdPartyDeliverymanController>(
                  builder: (context, controller, _) => CustomButtonWidget(
                    btnTxt: getTranslated('submit', context),
                    isLoading: widget.mode == SendToCourierMode.revise ? controller.isRevising : controller.isDispatching,
                    onTap: _submit,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String fieldKey;
  final bool isRequired;

  const _FieldLabel({required this.fieldKey, required this.isRequired});

  // Title/tooltip overrides shared across every provider with a custom field
  // order — a key with no entry here just falls back to the generic
  // getTranslated(key) label and no tooltip.
  static const Map<String, String> _customFieldTitleKeys = {
    'recipient_name': 'receivers_name',
    'recipient_phone': 'receivers_phone',
    'cod_amount': 'cash_to_collect',
    'recipient_address': 'delivery_address',
    'latitude': 'delivery_point_latitude',
    'longitude': 'delivery_point_longitude',
    'delivery_type': 'delivery_service',
    'weight': 'parcel_weight',
    'quantity': 'number_of_items',
    'item_description': 'parcel_contents',
    'note': 'rider_instructions',
    'store_id': 'store_id',
    'city_id': 'delivery_city',
    'zone_id': 'delivery_zone',
    'area_id': 'delivery_area',
  };

  static const Map<String, String> _customFieldTooltipKeys = {
    'cod_amount': 'cash_to_collect_tooltip',
    'latitude': 'delivery_point_latitude_tooltip',
    'longitude': 'delivery_point_longitude_tooltip',
    'delivery_type': 'delivery_service_tooltip',
    'item_description': 'parcel_contents_tooltip',
    'note': 'rider_instructions_tooltip',
    'store_id': 'pickup_store_tooltip',
    'recipient_address': 'delivery_address_tooltip',
  };

  @override
  Widget build(BuildContext context) {
    final String title = getTranslated(_customFieldTitleKeys[fieldKey] ?? fieldKey, context) ?? fieldKey;
    final String? tooltipKey = _customFieldTooltipKeys[fieldKey];
    final String? tooltip = tooltipKey != null ? getTranslated(tooltipKey, context) : null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: RichText(
            text: TextSpan(
              style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
              children: [
                TextSpan(text: title),
                if (isRequired)
                  TextSpan(text: ' *', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
            ),
          ),
        ),
        if (tooltip != null) ...[
          const SizedBox(width: 4),
          JustTheTooltip(
            triggerMode: TooltipTriggerMode.tap,
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            content: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Text(tooltip, style: titilliumRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall)),
            ),
            child: Icon(Icons.info_outline, size: 16, color: Theme.of(context).hintColor),
          ),
        ],
      ],
    );
  }
}

class _EstimateCard extends StatelessWidget {
  final double? estimateTotal;
  final String? estimateCurrency;
  final String? estimateMessage;
  final VoidCallback onEstimate;

  const _EstimateCard({
    required this.estimateTotal,
    required this.estimateCurrency,
    required this.estimateMessage,
    required this.onEstimate,
  });

  @override
  Widget build(BuildContext context) {
    final String subtitle = estimateMessage
        ?? (estimateTotal != null ? '${estimateTotal!.toStringAsFixed(0)} ${estimateCurrency ?? ''}'.trim()
        : getTranslated('fill_weight_and_location_then_estimate', context) ?? '');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(getTranslated('estimated_delivery_charge', context) ?? '', style: titilliumBold.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                )),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Text(subtitle, style: titilliumRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).hintColor,
                )),
              ],
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Consumer<ThirdPartyDeliverymanController>(
            builder: (context, controller, _) => OutlinedButton(
              onPressed: controller.isEstimating ? null : onEstimate,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).primaryColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
              ),
              child: controller.isEstimating
                  ? SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).primaryColor))
                  : Text(getTranslated('estimate', context) ?? '', style: titilliumBold.copyWith(color: Theme.of(context).primaryColor)),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightField extends StatelessWidget {
  final TextEditingController? controller;
  final bool isRequired;

  const _WeightField({required this.controller, required this.isRequired});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(fieldKey: 'weight', isRequired: isRequired),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: CustomTextFieldWidget(
                    controller: controller,
                    border: true,
                    hintText: 'Ex: 0.5',
                    textInputType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: .35)),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  ),
                  alignment: Alignment.center,
                  child: Text('Kg', style: titilliumRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GenericField extends StatelessWidget {
  final String fieldKey;
  final TextEditingController? controller;
  final bool isRequired;
  final bool isNumeric;
  final int maxLine;
  final String? hintText;

  const _GenericField({
    required this.fieldKey,
    required this.controller,
    required this.isRequired,
    required this.isNumeric,
    required this.maxLine,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(fieldKey: fieldKey, isRequired: isRequired),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          CustomTextFieldWidget(
            controller: controller,
            border: true,
            maxLine: maxLine,
            hintText: hintText,
            textInputType: isNumeric
                ? const TextInputType.numberWithOptions(decimal: true)
                : fieldKey == 'recipient_phone' ? TextInputType.phone : TextInputType.text,
          ),
        ],
      ),
    );
  }
}

class _OptionDropdown extends StatelessWidget {
  final String labelKey;
  final bool isRequired;
  final String? value;
  final List<CourierLocationOptionModel> options;
  final bool isLoading;
  final bool enabled;
  final bool hasLocationError;
  final ValueChanged<String?> onChanged;

  const _OptionDropdown({
    required this.labelKey,
    required this.isRequired,
    required this.value,
    required this.options,
    required this.isLoading,
    required this.enabled,
    required this.hasLocationError,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // A location lookup that came back with the "carrier fault" shape
    // (empty options + a message, see _handleLocationLoadResult) leaves the
    // whole cascade unusable — lock every location dropdown rather than let
    // the merchant pick from a partially-loaded, broken cascade.
    final bool effectivelyEnabled = enabled && !hasLocationError;

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(fieldKey: labelKey, isRequired: isRequired),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: .35)),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              color: effectivelyEnabled ? Theme.of(context).highlightColor : Theme.of(context).disabledColor.withValues(alpha: .08),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                initialValue: value,
                isExpanded: true,
                decoration: const InputDecoration(border: InputBorder.none),
                hint: Text(isLoading ? '${getTranslated('loading', context) ?? 'Loading'}...' : getTranslated('select', context) ?? 'Select'),
                items: options.map((option) => DropdownMenuItem<String>(
                  value: option.id,
                  child: Text(option.name ?? '', style: titilliumRegular.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  )),
                )).toList(),
                onChanged: effectivelyEnabled && !isLoading ? onChanged : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryTypeDropdown extends StatelessWidget {
  final List<CourierFieldOptionModel> deliveryTypes;
  final String? selectedValue;
  final bool isRequired;
  final ValueChanged<String?> onChanged;

  const _DeliveryTypeDropdown({
    required this.deliveryTypes,
    required this.selectedValue,
    required this.isRequired,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(fieldKey: 'delivery_type', isRequired: isRequired),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: .35)),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              color: Theme.of(context).highlightColor,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                initialValue: selectedValue,
                isExpanded: true,
                decoration: const InputDecoration(border: InputBorder.none),
                hint: Text(getTranslated('select', context) ?? 'Select'),
                items: deliveryTypes.map((type) => DropdownMenuItem<String>(
                  value: type.id,
                  child: Text(type.label ?? '', style: titilliumRegular.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  )),
                )).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
