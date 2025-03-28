// CarPaymentEntry.dart
class CarPaymentEntry {
  final String category; // '주유', '정비', '세차'
  final int amount;
  final DateTime date; // ✅ 날짜 필드 추가

  CarPaymentEntry({
    required this.category,
    required this.amount,
    required this.date, // ✅ 생성자에 포함
  });
}
