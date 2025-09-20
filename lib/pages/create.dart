import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lotto/config/internal_config.dart';
import 'package:lotto/model/request/UserResponse.dart';
import 'package:lotto/pages/check.dart';
import 'package:lotto/pages/history.dart';
import 'package:lotto/pages/home.dart';
import 'package:lotto/pages/login.dart';
import 'package:lotto/pages/member.dart';
import 'package:lotto/pages/reward.dart';

class CreatePage extends StatefulWidget {
  final UserResponse currentUser;
  const CreatePage({super.key, required this.currentUser});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
                              Navigator.of(context).pop(); // ปิด dialog
                            },
                          ),
                          TextButton(
                            child: Text("ยืนยัน"),
                            onPressed: () {
                              Navigator.of(context).pop(); // ปิด dialog ก่อน
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // หัวข้อ
              const Text(
                'สร้างหวย',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 40),

              // อันบอนที่ต้องการ
              const Text(
                'จำนวนใบที่ต้องการ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              // ช่องกรอกจำนวนใบ
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: 'กรอกจำนวนใบที่ต้องการ',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกจำนวนใบ';
                    }
                    final quantity = int.tryParse(value);
                    if (quantity == null || quantity <= 0) {
                      return 'จำนวนใบต้องมากกว่า 0';
                    }
                    if (quantity > 1000) {
                      return 'จำนวนใบไม่ควรเกิน 1000 ใบ';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 30),

              // ราคาที่ต้องการขาย
              const Text(
                'ราคาที่ต้องการขาย',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              // ช่องกรอกราคา
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: 'กรอกราคาที่ต้องการขาย',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกราคา';
                    }
                    final price = int.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'ราคาต้องเป็นตัวเลขที่มากกว่า 0';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 50),

              // ปุ่มเริ่มสร้างหวย
              Center(
                child: Container(
                  width: 180,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE53E3E), Color(0xFFFF4444)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE53E3E).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: create,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'เริ่มสร้างหวย',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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

  void create() async {
    if (_formKey.currentState!.validate()) {
      final int quantity = int.parse(_quantityController.text);
      final int price = int.parse(_priceController.text);

      try {
        final url = Uri.parse("$API_ENDPOINT/createlotto");
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"quantity": quantity, "price": price}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("สำเร็จ"),
              content: Text(
                "สร้างหวยจำนวน ${data['count']} ใบ\n"
                "ราคา ${data['price']} บาท/ใบ\n"
                "สถานะเริ่มต้น: ${data['status']}",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("ตกลง"),
                ),
              ],
            ),
          );
        } else {
          final err = jsonDecode(response.body);
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("ผิดพลาด"),
              content: Text(err['message'] ?? "สร้างหวยไม่สำเร็จ"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("ปิด"),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("ผิดพลาด"),
            content: Text("เกิดข้อผิดพลาด: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("ปิด"),
              ),
            ],
          ),
        );
      }
    }
  }
}
