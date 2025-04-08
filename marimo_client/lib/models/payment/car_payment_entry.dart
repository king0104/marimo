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

  /// 🔽 서버에서 받아온 JSON 데이터를 쉽게 변환하는 생성자
  factory CarPaymentEntry.fromJson(Map<String, dynamic> item) {
    return CarPaymentEntry(
      paymentId: item['paymentId'].toString(),
      category: item['type'],
      amount: item['price'],
      date: DateTime.parse(item['paymentDate']),
      details: item,
    );
  }

  /// ✅ 한글 카테고리 변환 getter
  String get categoryKr {
    switch (category.toUpperCase()) {
      case 'OIL':
        return '주유';
      case 'REPAIR':
        return '정비';
      case 'WASH':
        return '세차';
      default:
        return category;
    }
  }
}
