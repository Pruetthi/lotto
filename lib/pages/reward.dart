import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:lotto/config/internal_config.dart';
import 'package:lotto/model/request/UserResponse.dart';
import 'package:lotto/model/request/lottery.dart';
import 'package:lotto/pages/check.dart';
import 'package:lotto/pages/create.dart';
import 'package:lotto/pages/history.dart';
import 'package:lotto/pages/home.dart';
import 'package:lotto/pages/login.dart';
import 'package:lotto/pages/member.dart';

class Reward extends StatefulWidget {
  final UserResponse currentUser;
  const Reward({super.key, required this.currentUser});

  @override
  State<Reward> createState() => _RewardState();
}

class _RewardState extends State<Reward> {
  int _selectedIndex = 0;
  String prize1 = '';
  String prize2 = '';
  String prize3 = '';
  String last3 = '';
  String last2 = '';

  List<Lottery> lotteries = [];

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
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF9E090F),
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset("assets/image/logo.png", fit: BoxFit.cover),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.currentUser.wallet.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),

            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.white),
              onSelected: (value) {
                if (value == 'home') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HomePage(currentUser: widget.currentUser),
                    ),
                  );
                } else if (value == 'profile') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MemberPage(currentUser: widget.currentUser),
                    ),
                  );
                } else if (value == 'orders') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HistoryPage(currentUser: widget.currentUser),
                    ),
                  );
                } else if (value == 'check') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LotteryResultPage(currentUser: widget.currentUser),
                    ),
                  );
                } else if (value == 'admin') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("นี่คือเมนูสำหรับผู้ดูแลระบบ"),
                    ),
                  );
                } else if (value == 'logout') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("ยืนยันการออกจากระบบ"),
                        content: Text("คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?"),
                        actions: [
                          TextButton(
                            child: Text("ยกเลิก"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("ยืนยัน"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                (route) => false,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else if (value == 'create') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreatePage(currentUser: widget.currentUser),
                    ),
                  );
                } else if (value == 'reward') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Reward(currentUser: widget.currentUser),
                    ),
                  );
                }
              },
              itemBuilder: (context) {
                List<PopupMenuEntry<String>> items = [
                  const PopupMenuItem<String>(
                    value: 'home',
                    child: Text('หน้าหลัก'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'profile',
                    child: Text('โปรไฟล์'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'orders',
                    child: Text('คำสั่งซื้อ'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'check',
                    child: Text('ผลรางวัล'),
                  ),
                ];

                if (widget.currentUser.status == 'admin') {
                  items.add(
                    PopupMenuItem<String>(
                      value: 'create',
                      child: const Text('สร้างหวย'),
                    ),
                  );
                  items.add(
                    PopupMenuItem<String>(
                      value: 'reward',
                      child: const Text('ออกรางวัล'),
                    ),
                  );
                }

                items.add(
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('ออกจากระบบ'),
                  ),
                );

                return items;
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
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
                      onPressed: confirmGenerateRewards, // generateRewards,
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
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

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

            buildPrizeCard('รางวัลที่ 1', prize1),
            buildPrizeCard('รางวัลที่ 2', prize2),
            buildPrizeCard('รางวัลที่ 3', prize3),

            const SizedBox(height: 12),

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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: const Color(0xFF9E090F),
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(currentUser: widget.currentUser),
              ),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HistoryPage(currentUser: widget.currentUser),
              ),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    LotteryResultPage(currentUser: widget.currentUser),
              ),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MemberPage(currentUser: widget.currentUser),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าแรก'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'คำสั่งซื้อ'),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership),
            label: 'ผลรางวัล',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'สมาชิก'),
        ],
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

  void confirmGenerateRewards() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("เลือกวิธีออกรางวัล"),
          content: const Text(
            "คุณต้องการสุ่มจากหวยทั้งหมด หรือสุ่มจากเฉพาะที่มีคนซื้อแล้ว?",
          ),
          actions: [
            TextButton(
              child: const Text("หวยทั้งหมด"),
              onPressed: () {
                Navigator.of(context).pop();
                generateRewards(fromAll: true); // ส่ง true = สุ่มจากทั้งหมด
              },
            ),
            TextButton(
              child: const Text("เฉพาะที่ซื้อแล้ว"),
              onPressed: () {
                Navigator.of(context).pop();
                generateRewards(
                  fromAll: false,
                ); // ส่ง false = สุ่มจากที่ขายแล้ว
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchLotteries() async {
    try {
      final response = await http.get(Uri.parse('$API_ENDPOINT/createlotto'));
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

  Future<void> generateRewards({bool fromAll = true}) async {
    // เลือก source ตามจากทั้งหมด or เฉพาะที่ขายแล้ว
    final sourceLotteries = fromAll
        ? lotteries
        : lotteries.where((l) => l.status == 'sell').toList();

    if (sourceLotteries.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("หวยไม่พอสำหรับสุ่มรางวัล (ต้องมีอย่างน้อย 3 ใบ)"),
        ),
      );
      return;
    }

    final picked = <Lottery>[];
    final _rnd = Random();

    Lottery pickUniqueLottery() {
      Lottery lotto;
      int tries = 0;
      do {
        lotto = sourceLotteries[_rnd.nextInt(sourceLotteries.length)];
        tries++;
        if (tries > 50) break; // ป้องกัน loop ไม่รู้จบ (ป้องกันกรณีข้อมูลแปลก)
      } while (picked.contains(lotto));
      picked.add(lotto);
      return lotto;
    }

    // สุ่มรางวัลที่ 1-3 (unique)
    final l1 = pickUniqueLottery();
    final l2 = pickUniqueLottery();
    final l3 = pickUniqueLottery();

    final prize1Num = l1.number.toString().padLeft(6, '0');
    final prize2Num = l2.number.toString().padLeft(6, '0');
    final prize3Num = l3.number.toString().padLeft(6, '0');

    final exclude2 = {
      prize1Num.substring(prize1Num.length - 2),
      prize2Num.substring(prize2Num.length - 2),
      prize3Num.substring(prize3Num.length - 2),
    };

    // หา candidate ที่เป็นไปได้ (ตัดรางวัล 1–3 และตัดเลขท้ายที่ต้องห้ามออก)
    final candidate2Digits = sourceLotteries.where((lotto) {
      final numStr = lotto.number.toString().padLeft(6, '0');
      final last2 = numStr.substring(numStr.length - 2);
      return !exclude2.contains(last2) &&
          lotto.lid != l1.lid &&
          lotto.lid != l2.lid &&
          lotto.lid != l3.lid;
    }).toList();

    // เลขท้าย 3 ตัว: เอาจากรางวัลที่ 1 (ตามที่ต้องการ)
    final last3Digits = prize1Num.substring(prize1Num.length - 3);

    // เลขท้าย 2 ตัว: สุ่มใหม่ 00-99 (ไม่เกี่ยวกับรางวัลที่ 1)
    // เลขท้าย 2 ตัว
    // เลือกจาก candidate (ถ้ามี)
    String last2Digits;
    if (candidate2Digits.isNotEmpty) {
      final picked = candidate2Digits[_rnd.nextInt(candidate2Digits.length)];
      last2Digits = picked.number.toString().padLeft(6, '0').substring(4);
    } else {
      // fallback ถ้าไม่มีจริง ๆ (ป้องกัน crash)
      last2Digits = _rnd.nextInt(100).toString().padLeft(2, '0');
    }

    // หาใบที่ถูกรางวัลเลขท้าย 3 (ยกเว้น r1,r2,r3)
    final lLast3List = lotteries.where((lotto) {
      final s = lotto.number.toString().padLeft(6, '0');
      return s.endsWith(last3Digits) &&
          lotto.lid != l1.lid &&
          lotto.lid != l2.lid &&
          lotto.lid != l3.lid;
    }).toList();

    // หาใบที่ถูกรางวัลเลขท้าย 2 (ยกเว้น r1,r2,r3)
    final lLast2List = lotteries.where((lotto) {
      final s = lotto.number.toString().padLeft(6, '0');
      return s.endsWith(last2Digits) &&
          lotto.lid != l1.lid &&
          lotto.lid != l2.lid &&
          lotto.lid != l3.lid;
    }).toList();

    // อัพเดตในฐานข้อมูล (await เพื่อให้แน่ใจว่า update เสร็จ)
    try {
      await updateLottoReward(1, l1.lid);
      await updateLottoReward(2, l2.lid);
      await updateLottoReward(3, l3.lid);

      for (final lotto in lLast3List) {
        await updateLottoReward(4, lotto.lid);
      }
      for (final lotto in lLast2List) {
        await updateLottoReward(5, lotto.lid);
      }
    } catch (e) {
      print('อัพเดตรางวัลล้มเหลว: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("อัพเดตรางวัลล้มเหลว: $e")));
      return;
    }

    // เก็บ state เพื่อแสดงผลบน UI
    setState(() {
      prize1 = prize1Num;
      prize2 = prize2Num;
      prize3 = prize3Num;
      last3 = last3Digits;
      last2 = last2Digits;
    });

    // debug log
    print('รางวัลที่1: $prize1Num, last3: $last3Digits');
    print(
      'เลขท้าย2 (สุ่ม): $last2Digits, ผู้ถูกรางวัล2ตัว: ${lLast2List.map((e) => e.number)}',
    );
  }

  Future<void> updateLottoReward(int rid, int lid) async {
    try {
      final response = await http.post(
        Uri.parse('$API_ENDPOINT/updateLottoReward'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'rid': rid, 'lid': lid}),
      );

      if (response.statusCode == 200) {
        print('อัพเดต lid=$lid เป็นรางวัล rid=$rid สำเร็จ');
      } else {
        print('อัพเดตล้มเหลว: ${response.body}');
      }
    } catch (e) {
      print('Error update reward: $e');
    }
  }
}
