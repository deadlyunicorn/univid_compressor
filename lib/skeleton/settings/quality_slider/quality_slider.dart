import "package:flutter/material.dart";
import "package:univid_compressor/core/widgets.dart";

class QualitySlider extends StatefulWidget {
  const QualitySlider({
    super.key,
  });

  @override
  State<QualitySlider> createState() => _QualitySliderState();
}

class _QualitySliderState extends State<QualitySlider> {
  double qualityValue = 1;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: ColumnWithSpacings(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text( "Quality: ${(qualityValue * 100 ).toStringAsFixed(2)} %", ),
            Slider(
              min: 0.2,
              activeColor: Theme.of(context).colorScheme.secondary,
              value: qualityValue,
              onChanged: (double value) {
                setState(() {
                  qualityValue = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
