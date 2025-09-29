// import 'package:flutter/material.dart';
// import 'package:lotto/model/request/UserResponse.dart';
// import 'package:lotto/pages/check.dart';
// import 'package:lotto/pages/create.dart';
// import 'package:lotto/pages/history.dart';
// import 'package:lotto/pages/home.dart';
// import 'package:lotto/pages/login.dart';
// import 'package:lotto/pages/member.dart';
// import 'package:lotto/pages/reward.dart';

// class MainPage extends StatefulWidget {
//   final UserResponse currentUser;
//   const MainPage({super.key, required this.currentUser});

//   // สร้าง GlobalKey เพื่อให้ PopupMenuButton เข้าถึง State
//   static final GlobalKey<_MainPageState> mainKey = GlobalKey<_MainPageState>();

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   int _selectedIndex = 0;

//   late final List<Widget> _pages;

//   @override
//   void initState() {
//     super.initState();
//     _pages = [
//       HomePage(currentUser: widget.currentUser),
//       HistoryPage(currentUser: widget.currentUser),
//       LotteryResultPage(currentUser: widget.currentUser),
//       MemberPage(currentUser: widget.currentUser),
//     ];
//   }

//   // ฟังก์ชันเปลี่ยนหน้า
//   void setPage(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: MainPage.mainKey,
//       // appBar: AppBar(
//       //   automaticallyImplyLeading: false,
//       //   backgroundColor: const Color(0xFF9E090F),
//       //   titleSpacing: 0,
//       //   title: Row(
//       //     children: [
//       //       Container(
//       //         width: 40,
//       //         height: 40,
//       //         decoration: const BoxDecoration(
//       //           color: Colors.white,
//       //           shape: BoxShape.circle,
//       //         ),
//       //         child: ClipOval(
//       //           child: Image.asset("assets/image/logo.png", fit: BoxFit.cover),
//       //         ),
//       //       ),
//       //       const Spacer(),
//       //       Container(
//       //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       //         decoration: BoxDecoration(
//       //           color: Colors.white,
//       //           borderRadius: BorderRadius.circular(20),
//       //         ),
//       //         child: Text(
//       //           widget.currentUser.wallet.toString(),
//       //           style: const TextStyle(
//       //             fontSize: 20,
//       //             color: Colors.red,
//       //             fontWeight: FontWeight.bold,
//       //           ),
//       //         ),
//       //       ),
//       //       const SizedBox(width: 12),
//       //       PopupMenuButton<String>(
//       //         icon: const Icon(Icons.menu, color: Colors.white),
//       //         onSelected: (value) {
//       //           switch (value) {
//       //             case 'home':
//       //               setPage(0);
//       //               break;
//       //             case 'orders':
//       //               setPage(1);
//       //               break;
//       //             case 'check':
//       //               setPage(2);
//       //               break;
//       //             case 'profile':
//       //               setPage(3);
//       //               break;
//       //             case 'create':
//       //               Navigator.push(
//       //                 context,
//       //                 MaterialPageRoute(
//       //                   builder: (context) =>
//       //                       CreatePage(currentUser: widget.currentUser),
//       //                 ),
//       //               );
//       //               break;
//       //             case 'reward':
//       //               Navigator.push(
//       //                 context,
//       //                 MaterialPageRoute(
//       //                   builder: (context) =>
//       //                       Reward(currentUser: widget.currentUser),
//       //                 ),
//       //               );
//       //               break;
//       //             case 'admin':
//       //               ScaffoldMessenger.of(context).showSnackBar(
//       //                 const SnackBar(
//       //                   content: Text("นี่คือเมนูสำหรับผู้ดูแลระบบ"),
//       //                 ),
//       //               );
//       //               break;
//       //             case 'logout':
//       //               showDialog(
//       //                 context: context,
//       //                 builder: (BuildContext context) => AlertDialog(
//       //                   title: const Text("ยืนยันการออกจากระบบ"),
//       //                   content: const Text(
//       //                     "คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?",
//       //                   ),
//       //                   actions: [
//       //                     TextButton(
//       //                       child: const Text("ยกเลิก"),
//       //                       onPressed: () => Navigator.of(context).pop(),
//       //                     ),
//       //                     TextButton(
//       //                       child: const Text("ยืนยัน"),
//       //                       onPressed: () {
//       //                         Navigator.of(context).pop();
//       //                         Navigator.pushAndRemoveUntil(
//       //                           context,
//       //                           MaterialPageRoute(
//       //                             builder: (context) => const LoginPage(),
//       //                           ),
//       //                           (route) => false,
//       //                         );
//       //                       },
//       //                     ),
//       //                   ],
//       //                 ),
//       //               );
//       //               break;
//       //           }
//       //         },
//       //         itemBuilder: (context) {
//       //           List<PopupMenuEntry<String>> items = [
//       //             const PopupMenuItem(value: 'home', child: Text('หน้าหลัก')),
//       //             const PopupMenuItem(value: 'profile', child: Text('โปรไฟล์')),
//       //             const PopupMenuItem(
//       //               value: 'orders',
//       //               child: Text('คำสั่งซื้อ'),
//       //             ),
//       //             const PopupMenuItem(value: 'check', child: Text('ผลรางวัล')),
//       //           ];

//       //           if (widget.currentUser.status == 'admin') {
//       //             items.add(
//       //               const PopupMenuItem(
//       //                 value: 'create',
//       //                 child: Text('สร้างหวย'),
//       //               ),
//       //             );
//       //             items.add(
//       //               const PopupMenuItem(
//       //                 value: 'reward',
//       //                 child: Text('ออกรางวัล'),
//       //               ),
//       //             );
//       //           }

//       //           items.add(
//       //             const PopupMenuItem(
//       //               value: 'logout',
//       //               child: Text('ออกจากระบบ'),
//       //             ),
//       //           );
//       //           return items;
//       //         },
//       //       ),
//       //     ],
//       //   ),
//       // ),
//       body: IndexedStack(index: _selectedIndex, children: _pages),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.white70,
//         backgroundColor: const Color(0xFF9E090F),
//         onTap: setPage,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าแรก'),
//           BottomNavigationBarItem(icon: Icon(Icons.list), label: 'คำสั่งซื้อ'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.card_membership),
//             label: 'ผลรางวัล',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'สมาชิก'),
//         ],
//       ),
//     );
//   }
// }
