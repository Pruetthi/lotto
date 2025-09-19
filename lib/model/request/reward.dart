class Lottery {
  final int lid;
  final int number;
  final String status;

  Lottery({required this.lid, required this.number, required this.status});

  factory Lottery.fromJson(Map<String, dynamic> json) {
    return Lottery(
      lid: json['lid'],
      number: json['number'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'lid': lid, 'number': number, 'status': status};
  }
}
