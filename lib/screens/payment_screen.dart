import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final List<Map<String, dynamic>> payments = [
    {
      'job': 'Construction Worker',
      'date': 'Apr 20, 2026',
      'amount': 600,
      'status': 'Paid',
      'icon': Icons.construction,
      'color': Colors.brown,
    },
    {
      'job': 'Electrician Helper',
      'date': 'Apr 19, 2026',
      'amount': 500,
      'status': 'Paid',
      'icon': Icons.electrical_services,
      'color': Colors.yellow,
    },
    {
      'job': 'Delivery Boy',
      'date': 'Apr 18, 2026',
      'amount': 450,
      'status': 'Pending',
      'icon': Icons.delivery_dining,
      'color': Colors.blue,
    },
    {
      'job': 'Plumber Assistant',
      'date': 'Apr 17, 2026',
      'amount': 480,
      'status': 'Paid',
      'icon': Icons.water_drop,
      'color': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final int totalEarned = payments
        .where((p) => p['status'] == 'Paid')
        .fold(0, (sum, p) => sum + (p['amount'] as int));

    final int pendingAmount = payments
        .where((p) => p['status'] == 'Pending')
        .fold(0, (sum, p) => sum + (p['amount'] as int));

    final int paidCount =
        payments.where((p) => p['status'] == 'Paid').length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [

          // ── SLIVER APP BAR ──────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: Colors.orange,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange[800]!, Colors.deepOrange[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Background circles
                    Positioned(top: -40, right: -40,
                      child: Container(width: 180, height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08)))),
                    Positioned(bottom: -30, left: -30,
                      child: Container(width: 130, height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06)))),

                    // Content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 40),
                          Text("Total Earned",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  letterSpacing: 1)),
                          SizedBox(height: 4),
                          Text("₹$totalEarned",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1)),
                          SizedBox(height: 16),

                          // Stats Row
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              _statChip(Icons.check_circle,
                                  "$paidCount Paid", Colors.green),
                              SizedBox(width: 12),
                              _statChip(Icons.pending,
                                  "₹$pendingAmount Pending",
                                  Colors.yellow[700]!),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── SUMMARY CARDS ───────────────
                  Row(
                    children: [
                      Expanded(
                        child: _summaryCard(
                          "This Week",
                          "₹${totalEarned}",
                          Icons.trending_up,
                          Colors.green,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _summaryCard(
                          "Pending",
                          "₹${pendingAmount}",
                          Icons.hourglass_bottom,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // ── PAYMENT HISTORY ─────────────
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.history,
                            color: Colors.orange, size: 20),
                      ),
                      SizedBox(width: 10),
                      Text("Payment History",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                    ],
                  ),

                  SizedBox(height: 12),

                  // Payment Cards
                  ...payments.map((p) => _paymentCard(p)).toList(),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ],
      ),
    );
  }

  Widget _summaryCard(String label, String value,
      IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10)
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
              Text(value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _paymentCard(Map<String, dynamic> p) {
    final bool isPaid = p['status'] == 'Paid';
    final Color statusColor = isPaid ? Colors.green : Colors.orange;
    final Color jobColor = p['color'] as Color;

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8)
        ],
      ),
      child: Row(
        children: [
          // Job Icon
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: jobColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(p['icon'] as IconData,
                color: jobColor, size: 24),
          ),
          SizedBox(width: 14),

          // Job Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['job'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87)),
                SizedBox(height: 4),
                Text(p['date'],
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),

          // Amount + Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("₹${p['amount']}",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Colors.black87)),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: statusColor.withOpacity(0.3)),
                ),
                child: Text(p['status'],
                    style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}