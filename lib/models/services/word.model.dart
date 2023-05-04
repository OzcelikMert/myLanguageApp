class WordGetParamModel {
  final int? wordId;
  final int wordLanguageId;
  final int? wordStudyType;
  final int? wordIsStudy;

  WordGetParamModel({
    required this.wordLanguageId,
    this.wordId,
    this.wordStudyType,
    this.wordIsStudy
  });
}

class WordGetCountReportParamModel {
  final int wordLanguageId;

  WordGetCountReportParamModel({
    required this.wordLanguageId
  });
}


class WordAddParamModel {
  final int wordLanguageId;
  final String wordTextTarget;
  final String wordTextNative;
  final String wordComment;
  final int wordStudyType;

  WordAddParamModel({
    required this.wordTextTarget,
    required this.wordTextNative,
    required this.wordLanguageId,
    required this.wordComment,
    required this.wordStudyType
  });
}

class WordUpdateParamModel {
  final int wordId;
  final String? wordTextTarget;
  final String? wordTextNative;
  final String? wordComment;
  final int? wordStudyType;
  final int? wordIsStudy;

  WordUpdateParamModel({
    required this.wordId,
    this.wordTextTarget,
    this.wordTextNative,
    this.wordComment,
    this.wordStudyType,
    this.wordIsStudy
  });
}

class WordDeleteParamModel {
  final int? wordId;
  final int? wordLanguageId;

  WordDeleteParamModel({
    this.wordId,
    this.wordLanguageId
  });
}