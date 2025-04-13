extension HangeulWordBreakExtension on String {
  /// 한글 텍스트에서 자연스러운 단어 단위 줄바꿈 처리를 위해 Zero Width Joiner(​\u200D)를 삽입한다.
  /// 이 확장 메서드를 사용하면 Text에서 단어 단위 줄바꿈이 적용된다.
  String withHangeulWordBreak() {
    final RegExp emoji = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|'
      r'\ud83c[\ud000-\udfff]|'
      r'\ud83d[\ud000-\udfff]|'
      r'\ud83e[\ud000-\udfff])',
    );

    final List<String> words = split(' ');
    final List<String> result = [];

    for (var word in words) {
      if (emoji.hasMatch(word)) {
        result.add(word);
      } else {
        final spaced = word.replaceAllMapped(
          RegExp(r'(\S)(?=\S)'),
          (match) => '${match[1]}\u200D',
        );
        result.add(spaced);
      }
    }

    return result.join(' ');
  }
}
