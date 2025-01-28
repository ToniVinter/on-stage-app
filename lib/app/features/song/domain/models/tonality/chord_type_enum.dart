enum ChordTypeEnum { flat, natural, sharp }

extension ChordTypeEnumExtension on ChordTypeEnum {
  String get name {
    switch (this) {
      case ChordTypeEnum.flat:
        return '♭ (flat)';
      case ChordTypeEnum.natural:
        return 'natural';
      case ChordTypeEnum.sharp:
        return '♯ (sharp)';
    }
  }
}