import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lotto/config/internal_config.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
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
        title: const Text(''),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: Container(),
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
