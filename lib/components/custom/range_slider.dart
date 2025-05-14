import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:flutter/material.dart';

class RangeSliderCustom extends StatefulWidget {
  const RangeSliderCustom({
    super.key,
    required this.title,
    required this.divisions,
    required this.rangeValues,
    required this.maxValue,
    required this.minValue,
    required this.onChanged,
  });

  final String title;
  final double maxValue;
  final double minValue;
  final int divisions;
  final RangeValues rangeValues;
  final Function(RangeValues) onChanged;

  @override
  State<RangeSliderCustom> createState() => _RangeSliderCustomState();
}

class _RangeSliderCustomState extends State<RangeSliderCustom> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            valueIndicatorColor: AppColors.primary,
            valueIndicatorTextStyle: const TextStyle(color: Colors.white),
          ),
          child: RangeSlider(
            values: widget.rangeValues,
            max: widget.maxValue,
            min: widget.minValue,
            divisions: widget.divisions,
            activeColor: AppColors.primary,
            labels: RangeLabels(
              formatMoney(widget.rangeValues.start),
              formatMoney(widget.rangeValues.end),
            ),
            onChanged: widget.onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatMoney(widget.rangeValues.start),
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              formatMoney(widget.rangeValues.end),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
