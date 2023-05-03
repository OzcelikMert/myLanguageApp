import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/button.dart';

class ComponentStudyTypeButton extends StatelessWidget {
  final String title;
  final int totalWords;
  final int studiedWords;
  final int unstudiedWords;
  final Function onStartPressed;
  final Color? bgColor;

  ComponentStudyTypeButton({
    required this.title,
    required this.totalWords,
    required this.onStartPressed,
    required this.studiedWords,
    required this.unstudiedWords,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    double progressValue = studiedWords.toDouble() / totalWords.toDouble();
    progressValue =
        progressValue.isNaN || progressValue.isInfinite ? 0 : progressValue;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.black26,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26.withOpacity(0.5),
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Total Word Count: $totalWords',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            'Studied Word Count: $studiedWords',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            'Unstudied Word Count: $unstudiedWords',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '${(progressValue * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          SizedBox(height: 5),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
          SizedBox(height: 10),
          ComponentButton(
            text: 'Start Studying',
            buttonSize: ComponentButtonSize.sm,
            onPressed: () => onStartPressed(),
            icon: Icons.not_started_outlined,
            reverseIconAlign: true,
          ),
        ],
      ),
    );
  }
}
