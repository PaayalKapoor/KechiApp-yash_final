import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'title': 'New Message from Sejal',
      'subtitle': 'Hey! Will be 10 mins late for the appointment.',
      'time': '5 mins ago',
      'icon': '💬'
    },
    {
      'title': 'Payment Received 💸',
      'subtitle': '₹162.50 has been received from Nilesh Shah.',
      'time': '15 mins ago',
      'icon': '✅'
    },
    {
      'title': 'Upcoming Appointment',
      'subtitle': 'You have a booking at 4:00 PM today.',
      'time': '30 mins ago',
      'icon': '🕓'
    },
    {
      'title': 'Reminder',
      'subtitle': 'Follow up with Riya regarding hair spa session.',
      'time': '1 hr ago',
      'icon': '📌'
    },
    {
      'title': 'App Update Available',
      'subtitle': 'New features have been added. Update now!',
      'time': '2 hrs ago',
      'icon': '🚀'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Color(0xFF2196F3),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => Divider(),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xFF2196F3).withOpacity(0.1),
              child: Text(notif['icon']!, style: TextStyle(fontSize: 20)),
            ),
            title: Text(
              notif['title']!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(notif['subtitle']!),
            trailing: Text(
              notif['time']!,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          );
        },
      ),
    );
  }
}
