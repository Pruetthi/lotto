class Lottery {
  final int lid;
  final int number;
  final int price;
  final String status;
  final int? uid;
  final int? rid;

  Lottery({
    required this.lid,
    required this.number,
    required this.price,
    required this.status,
    this.uid,
    this.rid,
  });

  factory Lottery.fromJson(Map<String, dynamic> json) {
    return Lottery(
      lid: json['lid'],
      number: json['number'],
      price: json['price'],
      status: json['status'],
      uid: json['uid'],
      rid: json['rid'],
    );
  }
}
