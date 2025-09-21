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
import 'package:lotto/pages/login.dart';
import 'package:lotto/pages/member.dart';
import 'package:lotto/pages/reward.dart';
import 'package:lotto/pages/search.dart';

class HomePage extends StatefulWidget {
  final UserResponse currentUser;

  const HomePage({super.key, required this.currentUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> selectedNumbers = ['', '', '', '', '', ''];
  List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  int _selectedIndex = 0;

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _randomNumbers() {
    final random = Random();
    setState(() {
      for (int i = 0; i < 6; i++) {
        final num = random.nextInt(10);
        selectedNumbers[i] = num.toString();
        controllers[i].text = num.toString();
      }
    });
  }

  late Future<List<Lottery>> _futureLotteries;
  int _wallet = 0;

  @override
  void initState() {
    super.initState();
    _futureLotteries = fetchLotteries();
    _wallet = widget.currentUser.wallet.toInt();
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

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
                _wallet.toString(),
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
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.asset(
                    "assets/image/logo.png",
                    fit: BoxFit.cover,
                    width: 200,
                  ),
                  SizedBox(height: 20),

                  Text(
                    'ค้นหาเลขเด็ดงวดนี้',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 40,
                        child: TextField(
                          controller: controllers[index],
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Colors.red[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedNumbers[index] = value;
                            });

                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _randomNumbers,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          'สุ่มเลข',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String searchNumber = controllers
                              .map((c) => c.text)
                              .join();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPage(
                                status: widget.currentUser.status,
                                currentUser: widget.currentUser,
                                searchNumber: searchNumber,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          'ค้นหา',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'เลขเด็ด แนะนำ โดยแม่คะนั่ง',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                FutureBuilder<List<Lottery>>(
                  future: _futureLotteries,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('ไม่มีเลขเด็ดล่าสุด'));
                    }

                    final lotteries = snapshot.data!;

                    return Column(
                      children: List.generate(lotteries.length, (index) {
                        final lottery = lotteries[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lottery.number.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "ราคา ${lottery.price} บาท",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed:
                                    (widget.currentUser.status == 'admin')
                                    ? null
                                    : lottery.status == 'still'
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("ยืนยันการซื้อ"),
                                            content: Text(
                                              "คุณต้องการซื้อเลข ${lottery.number} ราคา ${lottery.price} บาท ใช่หรือไม่?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("ยกเลิก"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  buyLotto(lottery);
                                                },
                                                child: const Text("ตกลง"),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    : null,
                                icon: const Icon(Icons.shopping_cart),
                                label: Text(
                                  widget.currentUser.status == 'admin'
                                      ? (lottery.status == 'still'
                                            ? "ยังไม่ขาย"
                                            : "ขายแล้ว")
                                      : (lottery.status == 'still'
                                            ? "ซื้อเลย"
                                            : "ขายแล้ว"),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  },
                ),
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

  Future<List<Lottery>> fetchLotteries() async {
    final response = await http.get(Uri.parse('$API_ENDPOINT/createlotto'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((json) => Lottery.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load lotteries');
    }
  }

  Future<void> buyLotto(Lottery lottery) async {
    try {
      final response = await http.post(
        Uri.parse('$API_ENDPOINT/buyLotto'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'lid': lottery.lid,
          'uid': widget.currentUser.uid,
          'price': lottery.price,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("ซื้อหวยสำเร็จ")));

        setState(() {
          _wallet -= lottery.price;
          widget.currentUser.wallet = _wallet.toDouble();
          _futureLotteries = fetchLotteries();
        });
      } else {
        final msg = jsonDecode(response.body)['message'];
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("ซื้อหวยไม่สำเร็จ: $msg")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("เกิดข้อผิดพลาด: $e")));
    }
  }
}
