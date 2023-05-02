class WordGetParamModel {
  final int? wordId;
  final int? wordLanguageId;
  final int? wordStudyType;
  final int? wordIsStudy;

  WordGetParamModel({
    this.wordId,
    this.wordLanguageId,
    this.wordStudyType,
    this.wordIsStudy
  });
}

class WordAddParamModel {
  final int wordLanguageId;
  final String wordText;
  final String wordComment;
  final int wordStudyType;

  WordAddParamModel({
    required this.wordText,
    required this.wordLanguageId,
    required this.wordComment,
    required this.wordStudyType
  });
}

class WordUpdateParamModel {
  final int wordId;
  final String? wordText;
  final String? wordComment;
  final int? wordStudyType;
  final int? wordIsStudy;

  WordUpdateParamModel({
    required this.wordId,
    this.wordText,
    this.wordComment,
    this.wordStudyType,
    this.wordIsStudy
  });
}

class WordDeleteParamModel {
  final int wordId;

  WordDeleteParamModel({
    required this.wordId
  });
}