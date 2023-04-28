
import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/pageScaffold.dart';
import 'package:my_language_app/constants/studyTypes.const.dart';
import 'package:my_language_app/lib/element.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';

import '../components/elements/button.dart';

class PageStudyPlan extends StatefulWidget {
  const PageStudyPlan({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageStudyPlanState();
}

class _PageStudyPlanState extends State<PageStudyPlan> {
  void onClickStudy(int type) {
    (ElementLib(context)).showMessageBox(
        title: "Are you sure?",
        content: "You have selected '"+StudyTypes.getTypeName(type)+"'. Are you sure about this?",
        onPressedOkay: () {
          RouteLib(context).change(target: StudyTypes.getRouteName(type));
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: "Home",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ComponentButton(
                onPressed: () => onClickStudy(StudyTypes.Daily),
                text: "Daily",
                bgColor: Colors.teal,
            ),
            const Padding(padding: EdgeInsets.all(16)),
            ComponentButton(
              onPressed: () => onClickStudy(StudyTypes.Weekly),
              text: "Weekly",
              bgColor: Colors.blue,
            ),
            const Padding(padding: EdgeInsets.all(16)),
            ComponentButton(
              onPressed: () => onClickStudy(StudyTypes.Monthly),
              text: "Monthly",
            ),
          ],
        ),
      )
    );
  }
}