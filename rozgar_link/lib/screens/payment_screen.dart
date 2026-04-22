// lib/screens/payment_screen.dart
import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final List<Map> payments = [
    {'job': 'Construction Worker', 'date': 'Apr 20',
     'amount': 600, 'status': 'Paid'},
    {'job': 'Electrician Helper', 'date': 'Apr 19',
     'amount': 500, 'status': 'Paid'},
    {'job': 'Delivery Boy', 'date': 'Apr 18',
     'amount': 450, 'status': 'Pending'},
  ];

  @override
  Widget build(BuildContext context) {
    int total = payments
      .where((p) => p['status'] == 'Paid')
      .fold(0, (sum, p) => sum + (p['amount'] as int));

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment History"),
        backgroundColor: Colors.orange),
      body: Column(
        children: [
          // Total Card
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              Text("Total Earned",
                style: TextStyle(color: Colors.white,
                fontSize: 16)),
              Text("₹$total",
                style: TextStyle(color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold)),
            ]),
          ),
          // Payment List
          Expanded(
            child: ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, i) {
                final p = payments[i];
                return Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: Icon(Icons.currency_rupee,
                      color: p['status'] == 'Paid'
                        ? Colors.green : Colors.orange),
                    title: Text(p['job']),
                    subtitle: Text(p['date']),
                    trailing: Column(
                      mainAxisAlignment:
                        MainAxisAlignment.center,
                      children: [
                        Text("₹${p['amount']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                        Text(p['status'],
                          style: TextStyle(
                            color: p['status'] == 'Paid'
                              ? Colors.green : Colors.orange,
                            fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}