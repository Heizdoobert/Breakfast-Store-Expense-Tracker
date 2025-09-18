import 'package:extractorapplication/Controller/AuthController.dart';
import 'package:extractorapplication/Model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//component
import 'package:extractorapplication/View/Components/header.dart';
import 'package:extractorapplication/View/Components/search_box.dart';
import 'package:extractorapplication/View/Components/menu_card.dart';
import 'package:extractorapplication/View/Components/stat_card.dart';
import 'package:extractorapplication/View/Components/quick_action.dart';

class OwnerHomePage extends StatefulWidget {
  @override
  _OwnerHomePageState createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {
  final auth = AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Đơn hàng"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Báo cáo"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Tài khoản"),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(),
              const SizedBox(height: 16),
              const SearchBox(hintText: "Tìm kiếm đơn hàng, khách hàng..."),
              const SizedBox(height: 16),

              /// Menu chính
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  MenuCard(icon: Icons.attach_money, label: "Doanh thu"),
                  MenuCard(icon: Icons.money_off, label: "Chi phí"),
                  MenuCard(icon: Icons.inventory, label: "Sản phẩm"),
                  MenuCard(icon: Icons.group, label: "Nhân viên"),
                ],
              ),
              const SizedBox(height: 20),

              /// Thẻ tài chính
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "📊 Tóm tắt tài chính hôm nay",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              /// Thống kê nhanh
              Row(
                children: const [
                  Expanded(child: StatCard(title: "Đơn hàng", value: "25")),
                  SizedBox(width: 12),
                  Expanded(child: StatCard(title: "Khách mới", value: "8")),
                ],
              ),
              const SizedBox(height: 20),

              /// Chức năng nhanh
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  QuickAction(icon: Icons.pending_actions, label: "Chờ xử lý"),
                  QuickAction(icon: Icons.check_circle, label: "Hoàn tất"),
                  QuickAction(icon: Icons.undo, label: "Hoàn trả"),
                  QuickAction(icon: Icons.add, label: "Thêm đơn"),
                ],
              ),
              const SizedBox(height: 20),

              const Text("Top sản phẩm bán chạy",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  CircleAvatar(radius: 28, child: Text("SP1")),
                  CircleAvatar(radius: 28, child: Text("SP2")),
                  CircleAvatar(radius: 28, child: Text("SP3")),
                  CircleAvatar(radius: 28, child: Text("SP4")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}