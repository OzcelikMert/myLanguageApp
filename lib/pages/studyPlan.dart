import 'package:flutter/material.dart';
import 'package:my_language_app/components/pages/studyPlan/studyTypeButton.dart';
import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/config/db/tables/words.dart';
import 'package:my_language_app/constants/page.const.dart';
import 'package:my_language_app/constants/studyType.const.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/provider.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.model.dart';
import 'package:my_language_app/models/providers/language.provider.model.dart';
import 'package:my_language_app/models/providers/page.provider.model.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/models/services/word.model.dart';
import 'package:my_language_app/myLib/variable/array.dart';
import 'package:my_language_app/services/language.service.dart';
import 'package:my_language_app/services/word.service.dart';

class PageStudyPlan extends StatefulWidget {
  final BuildContext context;

  const PageStudyPlan({Key? key, required this.context}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageStudyPlanState();
}

class _PageStudyPlanState extends State<PageStudyPlan> {
  late List<WordGetCountReportResultModel> _stateWordCountReports = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageInit();
    });
  }

  _pageInit() async {
    final pageProviderModel = ProviderLib.get<PageProviderModel>(context);
    pageProviderModel.setTitle("Study Plan");
    final languageProviderModel =
        ProviderLib.get<LanguageProviderModel>(context);

    var wordCountReports = await WordService.getCountReport(
        WordGetCountReportParamModel(
            wordLanguageId: languageProviderModel.selectedLanguage.languageId));

    setState(() {
      _stateWordCountReports = wordCountReports;
    });

    pageProviderModel.setIsLoading(false);
  }

  void onClickStudy(int type) async {
    var reports = MyLibArray.findMulti(
        array: _stateWordCountReports,
        key: DBTableWords.columnStudyType,
        value: type);
    var unstudiedReports = MyLibArray.findMulti(
        array: reports, key: DBTableWords.columnIsStudy, value: 0);

    int totalWordCount = reports.isNotEmpty
        ? reports.map((e) => e.wordCount).reduce((a, b) => a + b)
        : 0;
    int unstudiedWordCount = unstudiedReports.isNotEmpty
        ? unstudiedReports.map((e) => e.wordCount).reduce((a, b) => a + b)
        : 0;

    if (totalWordCount == 0) {
      DialogLib.show(
          context,
          ComponentDialogOptions(
              content:
                  "There are no words. Please firstly you must add a word.",
              icon: ComponentDialogIcon.error));
    } else {
      DialogLib.show(
          context,
          ComponentDialogOptions(
              title: "Are you sure?",
              content:
                  "You have selected '${StudyTypeConst.getTypeName(type)}'. ${unstudiedWordCount == 0 ? "If you continue your all words in '${StudyTypeConst.getTypeName(type)}' will set is 'unstudied'." : ""} Are you sure you want to continue?",
              showCancelButton: true,
              icon: ComponentDialogIcon.confirm,
              onPressed: (bool isConfirm) async {
                if (isConfirm) {
                  await DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content: "Loading...",
                          icon: ComponentDialogIcon.loading));

                  final languageProviderModel =
                      ProviderLib.get<LanguageProviderModel>(context);

                  bool changeRoute = true;

                  if (unstudiedWordCount == 0) {
                    var wordUpdate = await WordService.update(
                        WordUpdateParamModel(
                            whereWordLanguageId: languageProviderModel
                                .selectedLanguage.languageId,
                            whereWordStudyType: type,
                            wordIsStudy: 0));
                    if (wordUpdate < 1) {
                      changeRoute = false;
                    }
                  }

                  var date = DateTime.now().toUtc().toString();
                  var languageUpdate = await LanguageService.update(
                      LanguageUpdateParamModel(
                        whereLanguageId:
                            languageProviderModel.selectedLanguage.languageId,
                        languageDailyUpdatedAt:
                            type == StudyTypeConst.Daily ? date : null,
                        languageWeeklyUpdatedAt:
                            type == StudyTypeConst.Weekly ? date : null,
                        languageMonthlyUpdatedAt:
                            type == StudyTypeConst.Monthly ? date : null,
                      ),
                      context);

                  if (languageUpdate < 1) {
                    changeRoute = false;
                  }

                  if (changeRoute) {
                    await RouteLib.change(
                        context: context,
                        target: PageConst.routeNames.study,
                        arguments: {DBTableWords.columnStudyType: type});
                  } else {
                    DialogLib.show(
                        context,
                        ComponentDialogOptions(
                            content: "It couldn't continue!",
                            icon: ComponentDialogIcon.error));
                  }
                  return false;
                }
              }));
    }
  }

  Widget componentDaily() {
    final languageProviderModel =
        ProviderLib.get<LanguageProviderModel>(context, listen: true);
    var reports = MyLibArray.findMulti(
        array: _stateWordCountReports,
        key: DBTableWords.columnStudyType,
        value: StudyTypeConst.Daily);
    var studiedReports = MyLibArray.findMulti(
        array: reports, key: DBTableWords.columnIsStudy, value: 1);
    var unstudiedReports = MyLibArray.findMulti(
        array: reports, key: DBTableWords.columnIsStudy, value: 0);

    return ComponentStudyTypeButton(
        bgColor: ThemeConst.colors.success,
        title: StudyTypeConst.getTypeName(StudyTypeConst.Daily),
        onStartPressed: () => onClickStudy(StudyTypeConst.Daily),
        lastStudyDate: DateTime.parse(languageProviderModel
            .selectedLanguage.languageDailyUpdatedAt
            .toString()),
        totalWords: reports.isNotEmpty
            ? reports.map((e) => e.wordCount).reduce((a, b) => a + b)
            : 0,
        studiedWords: studiedReports.isNotEmpty
            ? studiedReports.map((e) => e.wordCount).reduce((a, b) => a + b)
            : 0,
        unstudiedWords: unstudiedReports.isNotEmpty
            ? unstudiedReports.map((e) => e.wordCount).reduce((a, b) => a + b)
            : 0);
  }

  Widget componentWeekly() {
    final languageProviderModel =
        ProviderLib.get<LanguageProviderModel>(context, listen: true);
    var reports = MyLibArray.findMulti(
        array: _stateWordCountReports,
        key: DBTableWords.columnStudyType,
        value: StudyTypeConst.Weekly);
    var studiedReports = MyLibArray.findMulti(
        array: reports, key: DBTableWords.columnIsStudy, value: 1);
    var unstudiedReports = MyLibArray.findMulti(
        array: reports, key: DBTableWords.columnIsStudy, value: 0);

    return ComponentStudyTypeButton(
        bgColor: ThemeConst.colors.danger,
        title: StudyTypeConst.getTypeName(StudyTypeConst.Weekly),
        onStartPressed: () => onClickStudy(StudyTypeConst.Weekly),
        lastStudyDate: DateTime.parse(languageProviderModel
            .selectedLanguage.languageWeeklyUpdatedAt
            .toString()),
        totalWords: reports.isNotEmpty
            ? reports
                .map((e) => e.wordCount)
                .reduce((a, b) => a + b)
            : 0,
        studiedWords: studiedReports.isNotEmpty
            ? studiedReports
                .map((e) => e.wordCount)
                .reduce((a, b) => a + b)
            : 0,
        unstudiedWords: unstudiedReports.isNotEmpty
            ? unstudiedReports
                .map((e) => e.wordCount)
                .reduce((a, b) => a + b)
            : 0);
  }

  Widget componentMonthly() {
    final languageProviderModel =
        ProviderLib.get<LanguageProviderModel>(context, listen: true);
    var reports = MyLibArray.findMulti(
        array: _stateWordCountReports,
        key: DBTableWords.columnStudyType,
        value: StudyTypeConst.Monthly);
    var studiedReports = MyLibArray.findMulti(
        array: reports, key: DBTableWords.columnIsStudy, value: 1);
    var unstudiedReports = MyLibArray.findMulti(
        array: reports, key: DBTableWords.columnIsStudy, value: 0);

    return ComponentStudyTypeButton(
        bgColor: ThemeConst.colors.info,
        title: StudyTypeConst.getTypeName(StudyTypeConst.Monthly),
        onStartPressed: () => onClickStudy(StudyTypeConst.Monthly),
        lastStudyDate: DateTime.parse(languageProviderModel
            .selectedLanguage.languageMonthlyUpdatedAt
            .toString()),
        totalWords: reports.isNotEmpty
            ? reports
                .map((e) => e.wordCount)
                .reduce((a, b) => a + b)
            : 0,
        studiedWords: studiedReports.isNotEmpty
            ? studiedReports
                .map((e) => e.wordCount)
                .reduce((a, b) => a + b)
            : 0,
        unstudiedWords: unstudiedReports.isNotEmpty
            ? unstudiedReports
                .map((e) => e.wordCount)
                .reduce((a, b) => a + b)
            : 0);
  }

  @override
  Widget build(BuildContext context) {
    final pageProviderModel =
        ProviderLib.get<PageProviderModel>(context, listen: true);

    return pageProviderModel.isLoading
        ? Container()
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                componentDaily(),
                Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
                componentWeekly(),
                Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
                componentMonthly(),
              ],
            ),
          );
  }
}
