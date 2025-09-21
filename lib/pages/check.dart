import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lotto/config/internal_config.dart';
import 'package:lotto/model/request/LotteryResult.dart';
import 'package:lotto/model/request/UserResponse.dart';
import 'package:lotto/pages/create.dart';
import 'package:lotto/pages/history.dart';
import 'package:lotto/pages/home.dart';
import 'package:lotto/pages/login.dart';
import 'package:lotto/pages/member.dart';
import 'package:lotto/pages/reward.dart';

class LotteryResultPage extends StatefulWidget {
  final UserResponse currentUser;
  const LotteryResultPage({super.key, required this.currentUser});
  @override
  State<LotteryResultPage> createState() => _LotteryResultPageState();
}

class _LotteryResultPageState extends State<LotteryResultPage> {
  int _selectedIndex = 0;

  Future<List<LottoResult>> fetchLottoResult() async {
    final response = await http.get(Uri.parse('$API_ENDPOINT/lottoResult'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((json) => LottoResult.fromJson(json)).toList();
    } else {
      throw Exception('ไม่สามารถโหลดผลรางวัลได้');
    }
  }

  Map<int, List<String>> groupResults(List<LottoResult> results) {
    Map<int, List<String>> grouped = {};
    for (var r in results) {
      grouped.putIfAbsent(r.rid, () => []);
      grouped[r.rid]!.add(r.number);
    }

    if (!grouped.containsKey(4) || grouped[4]!.isEmpty) {
      if (grouped.containsKey(1) && grouped[1]!.isNotEmpty) {
        String prize1 = grouped[1]!.first;
        String last3 = prize1.length >= 3
            ? prize1.substring(prize1.length - 3)
            : prize1;
        grouped[4] = [last3];
      }
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: FutureBuilder<List<LottoResult>>(
        future: fetchLottoResult(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ยังไม่มีผลรางวัล'));
          }

          final grouped = groupResults(snapshot.data!);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "ผลรางวัล",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildPrizeCard(
                  "รางวัลที่ 1",
                  grouped[1]?.map((e) => e.toString()).join(" , ") ?? "-",
                ),
                const SizedBox(height: 12),
                _buildPrizeCard(
                  "รางวัลที่ 2",
                  grouped[2]?.map((e) => e.toString()).join(" , ") ?? "-",
                ),
                const SizedBox(height: 12),
                _buildPrizeCard(
                  "รางวัลที่ 3",
                  grouped[3]?.map((e) => e.toString()).join(" , ") ?? "-",
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildSmallPrize(
                        "เลขท้าย 3 ตัว",
                        grouped[4]?.map((e) => e.toString()).toList() ?? [],
                        lastDigits: 3,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSmallPrize(
                        "เลขท้าย 2 ตัว",
                        grouped[5]?.map((e) => e.toString()).toList() ?? [],
                        lastDigits: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
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

  Widget _buildPrizeCard(String title, String number) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
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
              fontSize: 18,
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
            number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallPrize(
    String title,
    List<String> numbers, {
    int lastDigits = 0,
  }) {
    String displayNumber = "-";

    if (numbers.isNotEmpty) {
      final n = numbers.first;
      displayNumber = n.length > lastDigits
          ? n.substring(n.length - lastDigits)
          : n;
    }
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.red, width: 2),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Text(
            displayNumber,
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
}
