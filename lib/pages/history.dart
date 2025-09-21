import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lotto/config/internal_config.dart';
import 'package:lotto/model/request/UserResponse.dart';
import 'package:lotto/pages/check.dart';
import 'package:lotto/pages/create.dart';
import 'package:lotto/pages/home.dart';
import 'package:lotto/pages/login.dart';
import 'package:lotto/pages/member.dart';
import 'package:lotto/pages/reward.dart';

class HistoryPage extends StatefulWidget {
  final UserResponse currentUser;
  const HistoryPage({super.key, required this.currentUser});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _selectedIndex = 0;

  Future<List<dynamic>> fetchMyLottos(int uid) async {
    final response = await http.get(Uri.parse("$API_ENDPOINT/myLotto/$uid"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("โหลดลอตเตอรี่ไม่สำเร็จ");
    }
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
              decoration: const BoxDecoration(
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
                    const PopupMenuItem<String>(
                      value: 'create',
                      child: Text('สร้างหวย'),
                    ),
                  );
                  items.add(
                    const PopupMenuItem<String>(
                      value: 'reward',
                      child: Text('ออกรางวัล'),
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
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("เกิดข้อผิดพลาด: ${snapshot.error}"));
          }
          final lottos = snapshot.data ?? [];
          if (lottos.isEmpty) {
            return const Center(child: Text("ไม่พบข้อมูล"));
          }

          return ListView.builder(
            itemCount: lottos.length,
            itemBuilder: (context, index) {
              final lotto = lottos[index];

              if (widget.currentUser.status == "admin") {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.star, color: Colors.orange),
                    title: Text("เลข ${lotto['number']}"),
                    subtitle: Text(
                      "รางวัล: ${lotto['reward_type']} - ${lotto['reward_money']} บาท\n"
                      "ผู้ซื้อ: ${lotto['user_name']} (${lotto['email']})",
                    ),
                  ),
                );
              } else {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.confirmation_number,
                          color: Colors.red,
                        ),
                        title: Text("เลข ${lotto['number']}"),
                        subtitle: Text("สถานะ: ${lotto['status']}"),
                      ),
                      if (lotto['rid'] != null && lotto['status'] == 'sell')
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => claimReward(lotto['lid']),
                            child: const Text("💰 ขึ้นเงิน"),
                          ),
                        ),
                    ],
                  ),
                );
              }
            },
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
          setState(() => _selectedIndex = index);
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

  Future<List<dynamic>> fetchData() async {
    if (widget.currentUser.status == "admin") {
      final response = await http.get(
        Uri.parse("$API_ENDPOINT/admin/rewardedLottos"),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("โหลดข้อมูลแอดมินล้มเหลว");
      }
    } else {
      return await fetchMyLottos(widget.currentUser.uid);
    }
  }

  Future<void> claimReward(int lid) async {
    final response = await http.post(Uri.parse("$API_ENDPOINT/claim/$lid"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("คุณได้รับ ${data['amount']} บาท")),
      );
      setState(() {
        widget.currentUser.wallet += data['amount'];
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("ขึ้นเงินไม่สำเร็จ")));
    }
  }
}
