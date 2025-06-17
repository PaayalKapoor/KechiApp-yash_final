import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BusinessHubScreen extends StatelessWidget {
  final List<double> revenueData = [12000, 18000, 15000, 22000, 25000, 20000];

  final List<Map<String, String>> subscribers = [
    {'type': 'Monthly Plan', 'count': '128'},
    {'type': 'Yearly Plan', 'count': '37'},
  ];

  final List<Map<String, dynamic>> priorityCustomers = [
    {'name': 'Riya Malhotra', 'spend': '₹12,500'},
    {'name': 'Amit Sharma', 'spend': '₹10,100'},
    {'name': 'Neha Verma', 'spend': '₹9,800'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Hub'),
        backgroundColor: Color(0xFF2196F3),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(' Revenue Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 200, child: RevenueChart(data: revenueData)),
          SizedBox(height: 24),
          Text('👥 Subscribers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          ...subscribers.map((sub) => ListTile(
                leading: Icon(Icons.star, color: Colors.amber),
                title: Text(sub['type']!),
                trailing: Text(sub['count']!, style: TextStyle(fontSize: 16)),
              )),
          SizedBox(height: 24),
          SizedBox(height: 24),
          Text('⭐ Priority Customers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...priorityCustomers.map((customer) => ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text(customer['name']!),
                subtitle: Text('Total Spend: ${customer['spend']}'),
              )),
        ],
      ),
    );
  }
}

class RevenueChart extends StatelessWidget {
  final List<double> data;

  RevenueChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
              data.length, (i) => FlSpot(i.toDouble(), data[i] / 1000)),
          isCurved: true,
          color: Color(0xFF2196F3),
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
              show: true, color: Color(0xFF2196F3).withOpacity(0.3)),
        )
      ],
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, _) {
              const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
              if (value.toInt() < months.length) {
                return Text(months[value.toInt()]);
              }
              return Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
      ),
      gridData: FlGridData(show: true),
      borderData: FlBorderData(show: true),
    ));
  }
}
