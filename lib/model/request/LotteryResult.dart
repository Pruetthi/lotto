class LottoResult {
  final String number;
  final int rid;

  LottoResult({required this.number, required this.rid});

  factory LottoResult.fromJson(Map<String, dynamic> json) {
    return LottoResult(number: json['number'].toString(), rid: json['rid']);
  }
}
