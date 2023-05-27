class WordTypeConst {
  static const word = 1;
  static const sentence = 2;

  static getTypeName(int type) {
    String name = "";
    switch(type) {
      case WordTypeConst.word: name = "Word"; break;
      case WordTypeConst.sentence: name = "Sentence"; break;
    }
    return name;
  }
}