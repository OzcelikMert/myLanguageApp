import 'package:flutter/material.dart';
import 'package:my_language_app/constants/theme.const.dart';

class ComponentProgress extends StatelessWidget {
  final double currentValue;
  final double maxValue;
  final String? text;
  final Color? color;
  final double? fontSize;

  const ComponentProgress({Key? key, required this.maxValue, required this.currentValue, this.text, this.color, this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progressValue = currentValue / maxValue;
    progressValue = progressValue.isNaN || progressValue.isInfinite ? 0 : progressValue;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text ?? 'Progress',
              style: TextStyle(
                fontSize: fontSize ?? ThemeConst.fontSizes.sm,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '${(progressValue * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: fontSize ?? ThemeConst.fontSizes.sm,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: ThemeConst.paddings.xsm)),
        LinearProgressIndicator(
          value: progressValue,
          backgroundColor: ThemeConst.colors.dark.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(color ?? ThemeConst.colors.primary),
        ),
      ],
    );
  }
}