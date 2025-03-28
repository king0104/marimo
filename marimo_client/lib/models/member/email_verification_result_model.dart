class EmailVerificationResult {
  final bool valid;

  EmailVerificationResult({required this.valid});

  factory EmailVerificationResult.fromJson(Map<String, dynamic> json) {
    return EmailVerificationResult(valid: json['valid'] as bool);
  }
}
