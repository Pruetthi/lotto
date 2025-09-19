import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lotto/config/internal_config.dart';

class SearchPage extends StatefulWidget {
  final String status;
  final String searchNumber; // ✅ รับค่ามาจาก HomePage
  const SearchPage({
    super.key,
    required this.status,
    required this.searchNumber,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> lottoResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLotto(); // ✅ เรียกตอนเปิดหน้า
  }

  Future<void> fetchLotto() async {
    final url = Uri.parse('$API_ENDPOINT/searchlotto');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'number': widget.searchNumber}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          lottoResults = data['data'];
          isLoading = false; // ✅ ปิด loading
        });
      } else {
        setState(() => isLoading = false);
        print('Failed to fetch lotto: ${response.body}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ผลการค้นหาเลข ${widget.searchNumber}"),
        backgroundColor: const Color(0xFF9E090F),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : lottoResults.isEmpty
          ? Center(child: Text("ไม่พบเลขที่ค้นหา"))
          : ListView.builder(
              itemCount: lottoResults.length,
              itemBuilder: (context, index) {
                final lotto = lottoResults[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text("เลข: ${lotto['number']}"),
                    subtitle: Text(
                      "ราคา: ${lotto['price']} ฿ | สถานะ: ${lotto['status']}",
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // TODO: ฟังก์ชันซื้อหวย
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text("ซื้อเลย"),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
