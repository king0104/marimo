// CarPaymentEntry.dart
class CarPaymentEntry {
  final String paymentId;
  final String category; // '주유', '정비', '세차'
  final int amount;
  final DateTime date; // ✅ 날짜 필드
  final Map<String, dynamic> details; // 카테고리별 세부 정보

  CarPaymentEntry({
    required this.paymentId,
    required this.category,
    required this.amount,
    required this.date,
    required this.details,
  });
}
