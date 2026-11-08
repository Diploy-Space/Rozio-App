import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EarningChartPoint {
  final String x;
  final double y;
  const EarningChartPoint(this.x, this.y);
}

class EarningStatisticsChartWidget extends StatelessWidget {
  final String title;
  final Widget filter;
  final String primaryLabel;
  final String secondaryLabel;
  final List<EarningChartPoint> primaryPoints;
  final List<EarningChartPoint> secondaryPoints;
  final Widget? emptyState;
  final double aspectRatio;

  static const Color primarySeriesColor = Color(0xFF1455AC);
  static const Color secondarySeriesColor = Color(0xFFF4BE37);

  const EarningStatisticsChartWidget({
    super.key,
    required this.title,
    required this.filter,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.primaryPoints,
    required this.secondaryPoints,
    this.emptyState,
    this.aspectRatio = 1,
  });


  String? _highlightedLabel() {
    final DateTime now = DateTime.now();
    final String month = DateFormat('MMM').format(now);
    final String weekday = DateFormat('EEE').format(now);

    for (final EarningChartPoint point in primaryPoints) {
      if (point.x.isEmpty) continue;
      if (point.x.startsWith(month) || month.startsWith(point.x)) return point.x;
      if (point.x.startsWith(weekday) || weekday.startsWith(point.x)) return point.x;
    }
    return null;
  }

  String _compact(double value) {
    final double abs = value.abs();
    if (abs >= 1000000000) return '${_trim(value / 1000000000)}b';
    if (abs >= 1000000) return '${_trim(value / 1000000)}m';
    if (abs >= 1000) return '${_trim(value / 1000)}k';
    return _trim(value);
  }

  String _trim(double value) => value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1);

  @override
  Widget build(BuildContext context) {
    final String? highlighted = _highlightedLabel();
    final Color gridColor = Theme.of(context).hintColor.withValues(alpha: 0.25);
    final TextStyle axisLabelStyle = robotoRegular.copyWith(
      fontSize: Dimensions.fontSizeSmall,
      color: Theme.of(context).hintColor,
    );

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingEye),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: robotoBold.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: Dimensions.fontSizeExtraLargeTwenty,
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                filter,
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: _LegendItem(color: primarySeriesColor, label: primaryLabel)),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Flexible(child: _LegendItem(color: secondarySeriesColor, label: secondaryLabel)),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            if (emptyState != null)
              emptyState!
            else
              Expanded(
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  margin: EdgeInsets.zero,
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    axisLine: AxisLine(width: 1, color: gridColor),
                    labelStyle: axisLabelStyle,
                    axisLabelFormatter: (AxisLabelRenderDetails details) {
                      final bool isActive = highlighted != null && details.text == highlighted;
                      return ChartAxisLabel(
                        details.text,
                        isActive
                            ? robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)
                            : details.textStyle,
                      );
                    },
                  ),
                  primaryYAxis: NumericAxis(
                    majorGridLines: MajorGridLines(width: 1, dashArray: const [4, 4], color: gridColor),
                    majorTickLines: const MajorTickLines(size: 0),
                    axisLine: const AxisLine(width: 0),
                    labelStyle: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    axisLabelFormatter: (AxisLabelRenderDetails details) =>
                        ChartAxisLabel(_compact(details.value.toDouble()), details.textStyle),
                  ),
                  series: [
                    SplineAreaSeries<EarningChartPoint, String>(
                      name: secondaryLabel,
                      dataSource: secondaryPoints,
                      xValueMapper: (EarningChartPoint point, _) => point.x,
                      yValueMapper: (EarningChartPoint point, _) => point.y,
                      splineType: SplineType.monotonic,
                      borderColor: secondarySeriesColor,
                      borderWidth: 3,
                      dashArray: const <double>[6, 4],
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [secondarySeriesColor.withValues(alpha: 0.35), secondarySeriesColor.withValues(alpha: 0.02)],
                      ),
                    ),
                    SplineAreaSeries<EarningChartPoint, String>(
                      name: primaryLabel,
                      dataSource: primaryPoints,
                      xValueMapper: (EarningChartPoint point, _) => point.x,
                      yValueMapper: (EarningChartPoint point, _) => point.y,
                      splineType: SplineType.monotonic,
                      borderColor: primarySeriesColor,
                      borderWidth: 3,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [primarySeriesColor.withValues(alpha: 0.35), primarySeriesColor.withValues(alpha: 0.02)],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: Dimensions.paddingSize),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDashed;
  const _LegendItem({required this.color, required this.label, this.isDashed = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24,
          height: 12,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isDashed)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 7, height: 3, color: color),
                    Container(width: 7, height: 3, color: color),
                  ],
                )
              else
                Container(height: 3, color: color),
              isDashed
                  ? Transform.rotate(angle: 0.785398, child: Container(width: 8, height: 8, color: color))
                  : Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            ],
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        Flexible(
          child: Text(label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault),
          ),
        ),
      ],
    );
  }
}

class EarningStatisticsFilterWidget extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final String Function(String) labelBuilder;

  const EarningStatisticsFilterWidget({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44, width: 130,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(width: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.25)),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: DropdownButton<String>(
        iconEnabledColor: Theme.of(context).hintColor,
        value: value,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(labelBuilder(option),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          );
        }).toList(),
        onChanged: (String? selected) => onChanged(selected!),
        isExpanded: true,
        underline: const SizedBox(),
      ),
    );
  }
}
