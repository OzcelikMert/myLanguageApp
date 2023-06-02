import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_language_app/components/elements/button.dart';
import 'package:my_language_app/components/elements/iconButton.dart';
import 'package:my_language_app/components/elements/progress.dart';
import 'package:my_language_app/constants/theme.const.dart';

class ComponentStudyTypeButton extends StatelessWidget {
  final String title;
  final DateTime lastStudyDate;
  final int totalWords;
  final int studiedWords;
  final int unstudiedWords;
  final Function onStartPressed;
  final Color? bgColor;
  final Function onRestartPressed;

  ComponentStudyTypeButton(
      {required this.title,
      required this.totalWords,
      required this.onStartPressed,
      required this.studiedWords,
      required this.unstudiedWords,
      this.bgColor,
      required this.lastStudyDate,
      required this.onRestartPressed});

  @override
  Widget build(BuildContext context) {
    var dateDiff = DateTime.now().difference(lastStudyDate);
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: ThemeConst.paddings.md, horizontal: ThemeConst.paddings.sm),
      decoration: BoxDecoration(
        color: bgColor ?? ThemeConst.colors.dark,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ThemeConst.colors.dark.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: ThemeConst.fontSizes.lg,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: ThemeConst.paddings.sm)),
          Text(
            'Total Word Count: $totalWords',
            style: TextStyle(fontSize: ThemeConst.fontSizes.md),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: ThemeConst.paddings.xsm)),
          Text(
            'Studied Word Count: $studiedWords',
            style: TextStyle(fontSize: ThemeConst.fontSizes.md),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: ThemeConst.paddings.xsm)),
          Text(
            'Unstudied Word Count: $unstudiedWords',
            style: TextStyle(fontSize: ThemeConst.fontSizes.md),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: ThemeConst.paddings.xsm)),
          Text(
            'Last Study Date: ${DateFormat.yMd().add_Hm().format(lastStudyDate.toLocal())} (${dateDiff.inDays > 0 ? "${dateDiff.inDays} Days ago" : dateDiff.inDays == -1 ? "Yesterday" : "Today"})',
            style: TextStyle(fontSize: ThemeConst.fontSizes.md),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: ThemeConst.paddings.md)),
          Row(
            children: [
              Expanded(flex: 9, child: ComponentProgress(
                maxValue: totalWords.toDouble(),
                currentValue: studiedWords.toDouble(),
              )),
              Expanded(flex: 1, child: ComponentIconButton(
                onPressed: () => onRestartPressed(),
                icon: Icons.restart_alt,
              )),
            ],
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: ThemeConst.paddings.sm)),
          ComponentButton(
            text: 'Start Studying',
            buttonSize: ComponentButtonSize.sm,
            onPressed: () => onStartPressed(),
            icon: Icons.not_started_outlined,
            reverseIconAlign: true,
          )
        ],
      ),
    );
  }
}
