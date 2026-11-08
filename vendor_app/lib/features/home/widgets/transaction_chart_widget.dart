import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/earning_statistics_chart_widget.dart';
import 'package:sixvalley_vendor_app/features/home/widgets/empty_earning_state_widget.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/bank_info/controllers/bank_info_controller.dart';

class TransactionChart extends StatefulWidget {

  const TransactionChart({super.key});

  @override
  State<StatefulWidget> createState() => TransactionChartState();
}

class TransactionChartState extends State<TransactionChart> {
  bool isEarningEmpty = false;
  final Color leftBarColor = const Color(0xff4E9BF0);
  final Color rightBarColor = const Color(0xFFF4BE37);
  final double width = 5;

  final List<String> weeks = ['','Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
  final List<String> months = ['','Jan','Feb','Mar','Apr','May','June','July','Aug','Sep','Oct','Nov','Dec'];
  List<EarningChartPoint> _expanseChartList = [];

  List<EarningChartPoint> _incomeChartList = [];


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BankInfoController>(
      builder: (context,bankInfoProvider, _) {
        isEarningEmpty = !(bankInfoProvider.lim > 1);

        List<double> earnings = [];
        List<double> commissions = [];
        if(bankInfoProvider.userCommissions != null && bankInfoProvider.userEarnings != null){
          for(double? earn in bankInfoProvider.userEarnings!) {
            earnings.add(PriceConverter.convertAmount(earn!, context));
          }
          for(double? commission in bankInfoProvider.userCommissions!) {
            commissions.add(PriceConverter.convertAmount(commission!, context));
          }
        }


        if(earnings.length < 9){

          _expanseChartList = commissions.asMap().entries.map((e) {
            return EarningChartPoint(weeks[e.key.toInt()], e.value);
          }).toList();

          _incomeChartList = earnings.asMap().entries.map((e) {
            return EarningChartPoint(weeks[e.key.toInt()], e.value);
          }).toList();

        }else if( earnings.length < 15){
          _expanseChartList = commissions.asMap().entries.map((e) {
            return EarningChartPoint(months[e.key.toInt()], e.value);
          }).toList();

          _incomeChartList = earnings.asMap().entries.map((e) {
            return EarningChartPoint(months[e.key.toInt()], e.value);
          }).toList();
        }else{
          _expanseChartList = commissions.asMap().entries.map((e) {
            return EarningChartPoint(e.key.toString(), e.value);
          }).toList();

          _incomeChartList = earnings.asMap().entries.map((e) {
            return EarningChartPoint(e.key.toString(), e.value);
          }).toList();
        }

        return EarningStatisticsChartWidget(
          aspectRatio: isEarningEmpty ? 1.3 : 1,
          title: getTranslated('earning_statistic', context)!,
          primaryLabel: getTranslated('earnings', context)!,
          secondaryLabel: getTranslated('commission_given', context)!,
          primaryPoints: _incomeChartList,
          secondaryPoints: _expanseChartList,
          emptyState: isEarningEmpty ? const EmptyEarningStateWidget() : null,
          filter: EarningStatisticsFilterWidget(
            value: bankInfoProvider.revenueFilterTypeIndex == 0 ? 'this_year' : bankInfoProvider.revenueFilterTypeIndex == 1 ? 'this_month' : 'this_week',
            options: const <String>['this_year', 'this_month', 'this_week'],
            labelBuilder: (String option) => getTranslated(option, context)!,
            onChanged: (String value) {
              bankInfoProvider.setRevenueFilterName(context, value, true);
              bankInfoProvider.setRevenueFilterType(value == 'this_year' ? 0 : value == 'this_month' ? 1 : 2, true);
            },
          ),
        );
      }
    );
  }
}

List<Color> gradientColors = [
  const Color(0xFF1B7FED),
  const Color(0xff4560ad),
];

List<Color> commissionGradientColors = [
  const Color(0xFFF4BE37),
  const Color(0xFFF4BE37),
];



class EarningStatisticsShimmer extends StatelessWidget {
  final bool isDarkMode;
  const EarningStatisticsShimmer({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = Theme.of(context).colorScheme.secondaryContainer;

    final baseColor = Theme.of(context).hintColor.withValues(alpha: 0.18);
    final highlightColor = Theme.of(context).hintColor.withValues(alpha: 0.06);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(width: 36, height: 36, color: shimmerColor),
                const SizedBox(width: 12),
                Container(height: 14, width: 120, color: shimmerColor),
                const Spacer(),
                Container(height: 50, width: 120, color: shimmerColor),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(height: 10, width: 100, color: shimmerColor),
                ]),
                const SizedBox(width: 12),
                Row(children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(height: 10, width: 100, color: shimmerColor),
                ]),
              ],
            ),
            const SizedBox(height: 38),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

