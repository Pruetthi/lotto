import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:lotto/config/internal_config.dart';
import 'package:lotto/model/request/lottery.dart';

class Reward extends StatefulWidget {
  const Reward({super.key});

  @override
  State<Reward> createState() => _RewardState();
}

class _RewardState extends State<Reward> {
  String prize1 = '';
  String prize2 = '';
  String prize3 = '';
  String last3 = '';
  String last2 = '';

  List<Lottery> lotteries = [];

  final Random _rnd = Random();

  // กล่อง 6 หลักสำหรับรางวัลที่ 1
  List<String> get sixBoxes {
    final s = prize1.padLeft(6, '-');
    return s.split('');
  }

  @override
  void initState() {
    super.initState();
    fetchLotteries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าออกรางวัล'),
        centerTitle: true,
        backgroundColor: Colors.red[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            // 👉 ส่วนออกกรางวัล
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ออกกรางวัล',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: sixBoxes.map((d) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 42,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red.shade400,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.red.shade50,
                          ),
                          child: Text(
                            d == '-' ? '' : d,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: generateRewards,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'สุ่มออกรางวัล',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // 👉 ส่วนผลรางวัล
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ผลรางวัล',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // รางวัลที่ 1-3
            buildPrizeCard('รางวัลที่ 1', prize1),
            buildPrizeCard('รางวัลที่ 2', prize2),
            buildPrizeCard('รางวัลที่ 3', prize3),

            const SizedBox(height: 12),

            // เลขท้าย
            Row(
              children: [
                Expanded(child: buildSmallPrize('เลขท้าย 3 ตัว', last3)),
                const SizedBox(width: 12),
                Expanded(child: buildSmallPrize('เลขท้าย 2 ตัว', last2)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPrizeCard(String title, String number) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.red, width: 2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Text(
              number.isEmpty ? '-' : number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSmallPrize(String title, String number) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.red, width: 2),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Text(
            number.isEmpty ? '-' : number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  // ดึงหวยจาก API
  Future<void> fetchLotteries() async {
    try {
      final response = await http.get(
        Uri.parse('$API_ENDPOINT/createlotto'), // เปลี่ยน IP ให้ตรงเซิร์ฟเวอร์
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        setState(() {
          lotteries = data.map((json) => Lottery.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load lotteries');
      }
    } catch (e) {
      print('Error fetching lotteries: $e');
    }
  }

  void generateRewards() {
    if (lotteries.length < 3) return;

    final pickedNumbers = <int>{};

    int pickUnique() {
      int num;
      do {
        num = lotteries[_rnd.nextInt(lotteries.length)].number;
      } while (pickedNumbers.contains(num));
      pickedNumbers.add(num);
      return num;
    }

    setState(() {
      // รางวัลที่ 1-3
      prize1 = pickUnique().toString().padLeft(6, '0');
      prize2 = pickUnique().toString().padLeft(6, '0');
      prize3 = pickUnique().toString().padLeft(6, '0');

      // เลขท้าย 3 ตัว เอาจากรางวัลที่ 1
      last3 = prize1.substring(prize1.length - 3);

      // เลขท้าย 2 ตัว (สุ่มใหม่ ไม่ซ้ำกับเลขที่จับไปแล้ว)
      last2 = pickUnique().toString().padLeft(6, '0').substring(4, 6);
    });

    // บันทึกลง reward table
    saveReward('รางวัลที่1', 6000000, lotteries[0].lid);
    saveReward('รางวัลที่2', 200000, lotteries[1].lid);
    saveReward('รางวัลที่3', 80000, lotteries[2].lid);

    saveReward('เลขท้าย3ตัว', 2000, lotteries.last.lid);
    saveReward('เลขท้าย2ตัว', 4000, lotteries[0].lid);
  }

  Future<void> saveReward(String type, int money, int lid) async {
    try {
      final response = await http.post(
        Uri.parse('$API_ENDPOINT/addReward'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'reward_type': type,
          'reward_money': money,
          'lid': lid,
        }),
      );

      if (response.statusCode == 200) {
        print('บันทึกรางวัล $type สำเร็จ');
      } else {
        print('บันทึกรางวัล $type ล้มเหลว: ${response.body}');
      }
    } catch (e) {
      print('Error saving reward: $e');
    }
  }
}
