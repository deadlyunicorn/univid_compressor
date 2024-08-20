import "package:flutter/material.dart";
import "package:univid_compressor/core/widgets.dart";

class SmallRadioSelector<T> extends StatelessWidget {
  const SmallRadioSelector({
    required this.title,
    required this.valueMap,
    required this.selectedValue,
    required this.onChanged,
    super.key,
  });

  final String title;
  final Map<String, T> valueMap;
  final T selectedValue;
  final void Function(T? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return RowWithSpacings(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title),
        ...valueMap.entries.map(
          (MapEntry<String, T> entry) => Row(
            children: <Widget>[
              Radio<T>(
                value: entry.value,
                groupValue: selectedValue,
                onChanged: onChanged,
              ),
              Text(entry.key),
            ],
          ),
        ),
      ],
    );
  }
}
