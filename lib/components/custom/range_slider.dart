import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:flutter/material.dart';

class RangeSliderCustom extends StatefulWidget {
  const RangeSliderCustom(
      {super.key,
      required this.title,
      required this.maxValue,
      required this.divisions});

  final String title;
  final double maxValue;
  final int divisions;

  @override
  State<RangeSliderCustom> createState() => _RangeSliderExampleState();
}

class _RangeSliderExampleState extends State<RangeSliderCustom> {
  RangeValues _currentRangeValues = const RangeValues(100000, 10000000);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            valueIndicatorColor: AppColors.primary,
            valueIndicatorTextStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          child: RangeSlider(
            values: _currentRangeValues,
            max: widget.maxValue,
            min: 100000,
            divisions: widget.divisions,
            activeColor: AppColors.primary,
            labels: RangeLabels(
              formatMoney(_currentRangeValues.start),
              formatMoney(_currentRangeValues.end),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatMoney(_currentRangeValues.start),
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              formatMoney(_currentRangeValues.end),
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
