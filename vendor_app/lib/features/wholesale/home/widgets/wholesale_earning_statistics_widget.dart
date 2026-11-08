import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/earning_statistics_chart_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/home/controllers/wholesale_home_controller.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class WholesaleEarningStatisticsWidget extends StatelessWidget {
  const WholesaleEarningStatisticsWidget({super.key});

  static const List<String> _filters = ['this_year', 'this_month', 'this_week'];
  static const List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  static const List<String> _weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  String _label(int filterIndex, int index) {
    if (filterIndex == 0 && index < _months.length) return _months[index];
    if (filterIndex == 2 && index < _weekDays.length) return _weekDays[index];
    return '${index + 1}';
  }

  List<EarningChartPoint> _chartData(BuildContext context, List<double>? amounts, int filterIndex) {
    return (amounts ?? []).asMap().entries.map((entry) {
      return EarningChartPoint(_label(filterIndex, entry.key), PriceConverter.convertAmount(entry.value, context));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleHomeController>(
      builder: (context, wholesaleHomeController, child) {
        final int filterIndex = wholesaleHomeController.revenueFilterIndex;
        final List<EarningChartPoint> incomeChartList = _chartData(context, wholesaleHomeController.earnings, filterIndex);
        final List<EarningChartPoint> expenseChartList = _chartData(context, wholesaleHomeController.commissions, filterIndex);

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.05), spreadRadius: 0, blurRadius: 2),
              BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.05), spreadRadius: -3, blurRadius: 12, offset: Offset.fromDirection(0, 6)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
            child: EarningStatisticsChartWidget(
              title: getTranslated('earning_statistic', context)!,
              primaryLabel: getTranslated('earnings', context)!,
              secondaryLabel: getTranslated('commission_given', context)!,
              primaryPoints: incomeChartList,
              secondaryPoints: expenseChartList,
              filter: EarningStatisticsFilterWidget(
                value: _filters[filterIndex],
                options: _filters,
                labelBuilder: (String option) => getTranslated(option, context)!,
                onChanged: (String value) => wholesaleHomeController.setRevenueFilterIndex(_filters.indexOf(value)),
              ),
            ),
          ),
        );
      },
    );
  }
}
