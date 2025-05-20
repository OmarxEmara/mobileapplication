import 'package:flutter/material.dart';

class FeatureSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  const FeatureSlider({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value.toStringAsFixed(1)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: 100,
          onChanged: onChanged,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
