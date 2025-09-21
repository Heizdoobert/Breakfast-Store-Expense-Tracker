import 'package:flutter/material.dart';
import 'package:extractorapplication/View/Components/header.dart';
import 'package:extractorapplication/View/Components/stat_card.dart';

class FinanceHomePage extends StatelessWidget {
  const FinanceHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Header(),
            const SizedBox(height: 16),

            /// Nội dung chính
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Tổng quan tài chính
                    const Text(
                      "📊 Tổng quan tài chính",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Thống kê nhanh - Placeholder cho dữ liệu từ DB
                    Row(
                      children: [
                        Expanded(
                          child: MiniStatCard(
                            icon: Icons.arrow_downward_rounded,
                            value: "0đ", // Placeholder
                            subtitle: "Thu nhập",
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MiniStatCard(
                            icon: Icons.arrow_upward_rounded,
                            value: "0đ", // Placeholder
                            subtitle: "Chi tiêu",
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    MiniStatCard(
                      icon: Icons.account_balance_wallet_rounded,
                      value: "0đ", // Placeholder
                      subtitle: "Số dư hiện tại",
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 24),

                    /// Chi tiết chi tiêu - Placeholder cho dữ liệu từ DB
                    StatCard(
                      title: "Chi tiêu hôm nay",
                      value: "0đ", // Placeholder
                      icon: Icons.shopping_cart_rounded,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Chi tiết chi tiêu",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Placeholder - sẽ thay bằng dữ liệu từ DB
                          const Center(
                            child: Text(
                              "Dữ liệu chi tiêu sẽ hiển thị tại đây",
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Ghi chú - Placeholder cho dữ liệu từ DB
                    StatCard(
                      title: "Ghi chú công việc",
                      value: "0 ghi chú", // Placeholder
                      icon: Icons.note_rounded,
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Danh sách ghi chú",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Placeholder - sẽ thay bằng dữ liệu từ DB
                          const Center(
                            child: Text(
                              "Danh sách ghi chú sẽ hiển thị tại đây",
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Thống kê chi tiết - Placeholder cho dữ liệu từ DB
                    const Text(
                      "📈 Thống kê chi tiết",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      height: 200,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bar_chart_rounded,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Biểu đồ thống kê sẽ hiển thị tại đây",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}