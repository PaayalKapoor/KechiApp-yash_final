import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:kechi/src/appointments/business.dart';
import 'package:kechi/src/appointments/notification.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:kechi/shared/widgets/bottom_navbar.dart';

void main() {
  runApp(MaterialApp(
    home: AppointmentsScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
class Appointment {
  String name;
  String mobileNumber;
  String service;
  String artist;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  double total;
  String gender;
  String email;
  int durationMinutes;
  bool isAccepted;
  String status;

  Appointment({
    required this.name,
    required this.mobileNumber,
    required this.service,
    required this.artist,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.total,
    required this.gender,
    required this.email,
    required this.durationMinutes,
    this.isAccepted = false,
    this.status = 'pending',
  });

  // Get the color based on status
  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'ongoing':
        return Colors.green;
      case 'delayed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Get the icon based on status
  IconData getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending_outlined;
      case 'ongoing':
        return Icons.play_circle_outline;
      case 'delayed':
        return Icons.timer_off_outlined;
      default:
        return Icons.pending;
    }
  }
}

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<String> artists = [
    'Yash',
    'Rahul',
    'Vikram',
    'Sara',
    'Rajiv',
    'Piku',
    'Riya',
    'Alia',
    'Aarav',
    'Anya'
  ];

  List<String> appointmentStatuses = [
    'pending',
    'ongoing',
    'delayed',
    'completed'
  ];

  // Sample client database
  Map<String, Map<String, String>> clientDatabase = {
    '9869912007': {
      'name': 'Nilesh Shah',
      'email': 'nileshshah123@gmail.com',
      'gender': 'Male'
    },
    '9136414509': {
      'name': 'Yash Patil',
      'email': 'yashpatil132654@gmail.com',
      'gender': 'Male'
    },
    '9820008894': {
      'name': 'Paayal Kapoor ',
      'email': 'paayalkapoor2018@gmail.com',
      'gender': 'Female'
    },
    '9876543213': {
      'name': 'Emily Davis',
      'email': 'emily.d@gmail.com',
      'gender': 'Female'
    }
  };
  List<String> artistImages = [
    'assets/artists/dpfile.png',
    'assets/artists/hello3m.jpg',
    'assets/artists/hello8m.jpg',
    'assets/artists/hello5f.jpg',
    'assets/artists/hello9m.jpg',
    'assets/artists/hello7f.jpg',
    'assets/artists/hello6f.jpg',
    'assets/artists/hello11f.jpg',
    'assets/artists/hello10m.jpg',
    'assets/artists/hello12f.jpg',
  ];

  List<DateTime> weekDates = [];
  int selectedArtistIndex = 0;
  DateTime selectedDate = DateTime.now();
  List<Appointment> appointments = [];
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  bool showUpcoming = true;

  @override
  void initState() {
    super.initState();
    _generateWeekDates();
    _addSampleAppointments();
    _pageController = PageController(initialPage: 3);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
        selectedDate = weekDates[_currentPage];
      });
    });
  }

  void _generateWeekDates() {
    weekDates = [];
    // Get today's date without time
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);

    // Generate dates centered around today
    for (int i = -3; i < 4; i++) {
      weekDates.add(today.add(Duration(days: i)));
    }

    // Set selected date to today and update page controller
    setState(() {
      selectedDate = today;
      if (_pageController.hasClients) {
        _pageController
            .jumpToPage(3); // Index 3 represents today in our 7-day window
      }
    });
  }

  void _addSampleAppointments() {
    // Create 5 sample appointments for each artist
    List<Appointment> sampleAppointments = [];

    for (int i = 0; i < artists.length; i++) {
      String artist = artists[i];
      sampleAppointments.addAll([
        Appointment(
          name: 'Customer ${i + 1}',
          mobileNumber: '98765432${i}0',
          email: 'customer${i + 1}@gmail.com',
          service: 'Haircut',
          artist: artist,
          date: DateTime.now().add(Duration(days: i % 3)),
          startTime: TimeOfDay(hour: 9 + i, minute: 0),
          endTime: TimeOfDay(hour: 9 + i, minute: 30),
          total: 300.0 + (i * 50),
          gender: i % 2 == 0 ? 'Male' : 'Female',
          durationMinutes: i % 2 == 0 ? 30 : 60,
          isAccepted: false, // Alternate acceptance status
          status: 'pending',
        ),
        Appointment(
          name: 'Customer ${i + 2}',
          mobileNumber: '98765432${i}1',
          email: 'customer${i + 2}@gmail.com',
          service: 'Hair Color',
          artist: artist,
          date: DateTime.now().add(Duration(days: (i + 1) % 4)),
          startTime: TimeOfDay(hour: 10 + i, minute: 0),
          endTime: TimeOfDay(hour: 11 + i, minute: 0),
          total: 800.0 + (i * 50),
          gender: 'Female',
          durationMinutes: 60,
        ),
        Appointment(
          name: 'Customer ${i + 3}',
          mobileNumber: '98765432${i}2',
          email: 'customer${i + 3}@gmail.com',
          service: 'Beard Trim',
          artist: artist,
          date: DateTime.now().add(Duration(days: (i + 2) % 5)),
          startTime: TimeOfDay(hour: 11 + i, minute: 0),
          endTime: TimeOfDay(hour: 11 + i, minute: 30),
          total: 200.0 + (i * 20),
          gender: 'Male',
          durationMinutes: 30,
        ),
        Appointment(
          name: 'Customer ${i + 4}',
          mobileNumber: '98765432${i}3',
          email: 'customer${i + 4}@gmail.com',
          service: 'Hair Spa',
          artist: artist,
          date: DateTime.now().add(Duration(days: (i + 3) % 6)),
          startTime: TimeOfDay(hour: 14 + i, minute: 0),
          endTime: TimeOfDay(hour: 15 + i, minute: 0),
          total: 600.0 + (i * 50),
          gender: 'Female',
          durationMinutes: 60,
        ),
        Appointment(
          name: 'Customer ${i + 5}',
          mobileNumber: '98765432${i}4',
          email: 'customer${i + 5}@gmail.com',
          service: 'Kids Haircut',
          artist: artist,
          date: DateTime.now().add(Duration(days: (i + 4) % 7)),
          startTime: TimeOfDay(hour: 15 + i, minute: 0),
          endTime: TimeOfDay(hour: 15 + i, minute: 30),
          total: 250.0 + (i * 30),
          gender: 'Male',
          durationMinutes: 30,
        ),
      ]);
    }

    setState(() {
      appointments = sampleAppointments;
    });
  }

  void _showRescheduleDialog(Appointment originalAppointment) {
    DateTime newDate = originalAppointment.date;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A73E8), Color(0xFF4285F4)],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Reschedule Appointment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${originalAppointment.name}\'s Appointment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      bool proceed = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.white,
                              elevation: 8,
                              title: Text(
                                'Ask Client',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A73E8),
                                ),
                              ),
                              content: Text(
                                'Would you like to send a reschedule request to the client?',
                                style: TextStyle(fontSize: 16),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text('No',
                                      style: TextStyle(color: Colors.grey)),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF1A73E8),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('Yes'),
                                ),
                              ],
                            ),
                          ) ??
                          false;

                      if (proceed) {
                        setState(() {
                          // Remove the appointment from old date
                          appointments.removeWhere((a) =>
                              a.date == originalAppointment.date &&
                              a.name == originalAppointment.name &&
                              a.startTime == originalAppointment.startTime);

                          // Add appointment to new date
                          appointments.add(Appointment(
                            name: originalAppointment.name,
                            mobileNumber: originalAppointment.mobileNumber,
                            email: originalAppointment.email,
                            service: originalAppointment.service,
                            artist: originalAppointment.artist,
                            date: newDate,
                            startTime: originalAppointment.startTime,
                            endTime: originalAppointment.endTime,
                            total: originalAppointment.total,
                            gender: originalAppointment.gender,
                            durationMinutes:
                                originalAppointment.durationMinutes,
                            isAccepted: false,
                            status: 'pending',
                          ));
                        });

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Appointment rescheduled to ${DateFormat('MMM dd, yyyy').format(newDate)}'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1A73E8),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      'Ask Client',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareAppointmentDetails(Appointment appointment) {
    final String shareText = '''
🏪 KECHI SALON & SPA
📱 Appointment Details 
━━━━━━━━━━━━━━━━

👤 Client Details:
   Name: ${appointment.name}
   Mobile: ${appointment.mobileNumber}
   Email: ${appointment.email}

💇 Service Details:
   Service: ${appointment.service}
   Artist: ${appointment.artist}
   Duration: ${appointment.durationMinutes} mins

📅 Schedule:
   Date: ${DateFormat('EEEE, MMMM d, yyyy').format(appointment.date)}
   Time: ${appointment.startTime.format(context)} - ${appointment.endTime.format(context)}

💰 Payment:
   Total Amount: ₹${appointment.total.toStringAsFixed(2)}
   Payment Mode: COD

📌 Status: ${appointment.status.toUpperCase()}

Thank you for choosing Kechi Salon & Spa!
For any queries, feel free to contact us.
''';

    Share.share(shareText);
  }

  void _showAppointmentDetails(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A73E8), Color(0xFF4285F4)],
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        // Left side (Appointment info) - Takes available space
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ' #${appointment.hashCode.abs() % 1000}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                DateFormat('EEEE, MMMM d')
                                    .format(appointment.date),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right side (Action buttons) - Takes only needed space
                        Row(
                          mainAxisSize:
                              MainAxisSize.min, // Important for button row
                          children: [
                            IconButton(
                              icon: Icon(Icons.share, color: Colors.white),
                              onPressed: () =>
                                  _shareAppointmentDetails(appointment),
                            ),
                            IconButton(
                              icon: Icon(Icons.print, color: Colors.white),
                              onPressed: () => _printAppointmentDetails(
                                  context, appointment),
                            ),
                            IconButton(
                              icon:
                                  Icon(Icons.info_outline, color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                                _showContactOptions(context, appointment);
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointment Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildStatusSelector(appointment),
                    SizedBox(height: 20),
                    _buildDetailRow('Client', appointment.name),
                    SizedBox(height: 8),
                    _buildDetailRow(
                        'Email',
                        appointment.email.isNotEmpty
                            ? appointment.email
                            : 'Not provided'),
                    SizedBox(height: 8),
                    _buildDetailRow('Mobile', appointment.mobileNumber),
                    SizedBox(height: 8),
                    _buildDetailRow('Service', appointment.service),
                    SizedBox(height: 8),
                    _buildDetailRow(
                      'Time',
                      '${appointment.startTime.format(context)} - ${appointment.endTime.format(context)}',
                    ),
                    SizedBox(height: 8),
                    _buildDetailRow(
                        'Duration', '${appointment.durationMinutes} mins'),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1A73E8).withOpacity(0.1),
                            Color(0xFF4285F4).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildPriceRow('Service Cost', appointment.total),
                          SizedBox(height: 8),
                          _buildPriceRow('Discount', 0.0),
                          SizedBox(height: 8),
                          _buildPriceRow('Wallet Discount', 0.0),
                          SizedBox(height: 8),
                          _buildPriceRow('Distance Cost', 0.0),
                          SizedBox(height: 8),
                          _buildPriceRow('Service Tax', 5.0),
                          Divider(
                              height: 24, color: Colors.grey.withOpacity(0.5)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '₹${(appointment.total + 5.0).toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A73E8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Payment: COD',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(1)}',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showContactOptions(BuildContext context, Appointment appointment) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contact Client',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF1A73E8).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.call, color: Color(0xFF1A73E8)),
              ),
              title: Text('Call'),
              subtitle: Text(appointment.mobileNumber),
              onTap: () {
                // Implement call functionality
              },
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF1A73E8).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(Icons.chat_bubble_outline, color: Color(0xFF1A73E8)),
              ),
              title: Text('Chat'),
              subtitle: Text('Send a message'),
              onTap: () {
                // Implement chat functionality
              },
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF1A73E8).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.email_outlined, color: Color(0xFF1A73E8)),
              ),
              title: Text('Email'),
              subtitle: Text(appointment.email.isNotEmpty
                  ? appointment.email
                  : 'Email not provided'),
              onTap: () {
                // Implement email functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSelector(Appointment appointment) {
    return DropdownButtonHideUnderline(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: appointment.getStatusColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<String>(
          value: appointment.status.toLowerCase(),
          isDense: true,
          icon:
              Icon(Icons.arrow_drop_down, color: appointment.getStatusColor()),
          items: ['pending', 'ongoing', 'delayed', 'completed']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    appointment.getStatusIcon(),
                    color: appointment.getStatusColor(),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    value.toUpperCase(),
                    style: TextStyle(
                      color: appointment.getStatusColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                appointment.status = value;
                if (value == 'completed') {
                  appointment.isAccepted = true;
                }
              });
              // Force rebuild of the parent widget
              Navigator.pop(context);
              _showAppointmentDetails(context, appointment);
            }
          },
        ),
      ),
    );
  }

  void _showDeclineConfirmation(Appointment appointment) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        elevation: 8,
        title: Text(
          'Decline Appointment?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Text(
          'Are you sure you want to decline this appointment?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                appointments.remove(appointment);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Appointment declined'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text('Yes'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  TimeOfDay addMinutesToTimeOfDay(TimeOfDay time, int minutesToAdd) {
    final totalMinutes = time.hour * 60 + time.minute + minutesToAdd;
    final newHour = (totalMinutes ~/ 60) % 24;
    final newMinute = totalMinutes % 60;
    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  @override
  Widget build(BuildContext context) {
    List<Appointment> filtered = appointments
        .where((a) =>
            a.artist == artists[selectedArtistIndex] &&
            a.date.day == selectedDate.day &&
            a.date.month == selectedDate.month &&
            a.date.year == selectedDate.year)
        .toList()
      ..sort((a, b) => a.startTime.hour.compareTo(b.startTime.hour));

    return Scaffold(
      backgroundColor: Color(0xFFF5F8FE),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.5,
              stops: [0.0, 0.8],
              colors: [Color(0xFF1A73E8), Color(0xFF1A73E8)],
            ),
          ),
        ),
        title: Text(
          'Appointments',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Search by Phone Number',
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                // Reset to normal filtered view
                                filtered = appointments
                                    .where((a) =>
                                        a.artist ==
                                            artists[selectedArtistIndex] &&
                                        a.date.day == selectedDate.day &&
                                        a.date.month == selectedDate.month &&
                                        a.date.year == selectedDate.year)
                                    .toList()
                                  ..sort((a, b) => a.startTime.hour
                                      .compareTo(b.startTime.hour));
                              } else {
                                // Filter by phone number
                                filtered = appointments
                                    .where(
                                        (a) => a.mobileNumber.contains(value))
                                    .toList()
                                  ..sort((a, b) => a.startTime.hour
                                      .compareTo(b.startTime.hour));
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.analytics_outlined, color: Colors.white, size: 30),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BusinessHubScreen()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white, size: 30),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NotificationScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF1A73E8),
        elevation: 4,
        onPressed: _addAppointment,
        child: Icon(Icons.calendar_month, color: Colors.white, size: 35),
      ),
      //removed
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 70, bottom: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A73E8),
                  Color(0xFF1A73E8),
                  Color(0xFF1A73E8),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF1A73E8).withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 0),
                  height: 3,
                  color: Colors.white.withOpacity(1),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: _selectMonthYear,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            DateFormat('MMMM yyyy').format(selectedDate),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: weekDates.length,
                    itemBuilder: (context, index) {
                      final date = weekDates[index];
                      final isSelected = date.day == selectedDate.day;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            children: [
                              Text(
                                DateFormat.E().format(date).substring(0, 3),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? RadialGradient(
                                          colors: [Colors.white, Colors.white],
                                          radius: 1,
                                        )
                                      : null,
                                  color: isSelected
                                      ? null
                                      : const Color.fromARGB(255, 255, 255, 255)
                                          .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          )
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: isSelected
                                          ? Color(0xFF1A73E8)
                                          : Colors.white,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 0),
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
          SizedBox(height: 10),
          // Artist Selector
          Container(
            height: 106,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF1A73E8).withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: artists.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedArtistIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedArtistIndex = index),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Color(0xFF1A73E8)
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: isSelected ? 24 : 22,
                            backgroundImage: AssetImage(artistImages[index]),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          artists[index],
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color:
                                isSelected ? Color(0xFF1A73E8) : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Appointments by Time
          SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No appointments for this day',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final appointment = filtered[index];
                      return Dismissible(
                        key: Key(appointment.name +
                            appointment.startTime.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF1A73E8),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Color(0xFF1A73E8).withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.archive, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.white,
                              elevation: 8,
                              title: Text(
                                'Archive Appointment?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A73E8),
                                ),
                              ),
                              content: Text(
                                'This action cannot be undone.',
                                style: TextStyle(fontSize: 16),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Archive'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) {
                          setState(() {
                            appointments.remove(appointment);
                          });
                        },
                        child: GestureDetector(
                          onTap: () =>
                              _showAppointmentDetails(context, appointment),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Color(0xFF1A73E8).withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF1A73E8).withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 4,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF1A73E8),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  appointment.name,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: appointment
                                                        .getStatusColor()
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        appointment
                                                            .getStatusIcon(),
                                                        size: 16,
                                                        color: appointment
                                                            .getStatusColor(),
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        appointment.status
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          color: appointment
                                                              .getStatusColor(),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  '₹${appointment.total.toStringAsFixed(0)}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF1A73E8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  'ID #${appointment.hashCode.abs() % 1000}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Icon(Icons.email_outlined,
                                                    size: 14,
                                                    color: Colors.grey[600]),
                                                SizedBox(width: 4),
                                                Text(
                                                  appointment.email.isNotEmpty
                                                      ? appointment.email
                                                      : 'Email not provided',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      appointment.service,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[800],
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      '(${appointment.startTime.format(context)})',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    if (appointment.status ==
                                                        'completed')
                                                      Text(
                                                        ' - ${appointment.durationMinutes}mins',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.grey[600],
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints: BoxConstraints(),
                                                  icon: Icon(
                                                    Icons.edit_outlined,
                                                    size: 20,
                                                    color: Color(0xFF1A73E8),
                                                  ),
                                                  onPressed: () =>
                                                      _showAppointmentEdit(
                                                          context, appointment),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1A73E8).withOpacity(0.05),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      if (!appointment.isAccepted)
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0),
                                            child: ElevatedButton.icon(
                                              icon: Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.green),
                                              label: Text('Accept',
                                                  style: TextStyle(
                                                      color: Colors.green)),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.green,
                                                elevation: 0,
                                                side: BorderSide(
                                                    color: Colors.green
                                                        .withOpacity(0.2)),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  appointment.isAccepted = true;
                                                  appointment.status =
                                                      'ongoing';
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      if (!appointment.isAccepted)
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0),
                                            child: ElevatedButton.icon(
                                              icon: Icon(Icons.schedule,
                                                  color: Colors.orange),
                                              label: Text('Reschedule',
                                                  style: TextStyle(
                                                      color: Colors.orange)),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.orange,
                                                elevation: 0,
                                                side: BorderSide(
                                                    color: Colors.orange
                                                        .withOpacity(0.2)),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                              ),
                                              onPressed: () =>
                                                  _showRescheduleDialog(
                                                      appointment),
                                            ),
                                          ),
                                        ),
                                      if (!appointment.isAccepted)
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0),
                                            child: ElevatedButton.icon(
                                              icon: Icon(Icons.close,
                                                  color: Colors.red),
                                              label: Text('Decline',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.red,
                                                elevation: 0,
                                                side: BorderSide(
                                                    color: Colors.red
                                                        .withOpacity(0.2)),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                              ),
                                              onPressed: () =>
                                                  _showDeclineConfirmation(
                                                      appointment),
                                            ),
                                          ),
                                        ),
                                      if (appointment.isAccepted)
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 0),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.check_circle,
                                                    size: 18,
                                                    color: Colors.green),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Appointment is confirmed',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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

  Future<void> _selectMonthYear() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF1A73E8), // header background color
              onPrimary:
                  const Color.fromARGB(255, 0, 0, 0), // header text color
              onSurface: Color(0xFF1A73E8), // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF1A73E8), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _generateWeekDates();
        _pageController.jumpToPage(0);
      });
    }
  }

  void _addAppointment() {
    String name = '',
        mobileNumber = '',
        email = '',
        service = '',
        artist = artists[selectedArtistIndex],
        gender = '';
    List<String> services = [
      'Nails',
      'Bridal Makeup',
      'Haircut',
      'Facewash',
      'Hair Color',
      'Hair Spa'
    ];
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    double total = 0.0;
    DateTime date = selectedDate;
    int durationMinutes = 30;
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final mobileController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Header section
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1A73E8), Color(0xFF4285F4)],
                    ),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'New Appointment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Flexible content section
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Customer Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.person_outline,
                                color: Color(0xFF1A73E8)),
                            errorText:
                                name.isEmpty ? 'Please enter a name' : null,
                          ),
                          onChanged: (value) {
                            setState(() => name = value);
                          },
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: mobileController,
                          decoration: InputDecoration(
                            labelText: 'Mobile Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.phone_outlined,
                                color: Color(0xFF1A73E8)),
                            helperText:
                                'Enter mobile number to auto-fill client details',
                            errorText: mobileNumber.isNotEmpty &&
                                    !RegExp(r'^\d{10}$').hasMatch(mobileNumber)
                                ? 'Please enter a valid 10-digit number'
                                : null,
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (v) {
                            setState(() {
                              mobileNumber = v;
                              if (clientDatabase.containsKey(v)) {
                                final client = clientDatabase[v]!;
                                nameController.text = client['name'] ?? '';
                                emailController.text = client['email'] ?? '';
                                name = client['name'] ?? '';
                                email = client['email'] ?? '';
                                gender = client['gender'] ?? '';
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Client details auto-filled'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.email_outlined,
                                color: Color(0xFF1A73E8)),
                            errorText: email.isNotEmpty &&
                                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(email)
                                ? 'Please enter a valid email address'
                                : null,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              email = value.trim();
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: gender.isEmpty ? null : gender,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Container(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.male,
                                      color: Color(0xFF1A73E8), size: 20),
                                  Icon(Icons.female,
                                      color: Color(0xFF1A73E8), size: 20),
                                ],
                              ),
                            ),
                            prefixIconConstraints:
                                BoxConstraints(minWidth: 40, minHeight: 40),
                          ),
                          dropdownColor: Colors.white,
                          hint: Text('Select Gender'),
                          items: ['Male', 'Female'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                gender = value;
                                durationMinutes = value == 'Male' ? 30 : 60;
                                if (startTime != null) {
                                  endTime = addMinutesToTimeOfDay(
                                      startTime!, durationMinutes);
                                }
                              });
                            }
                          },
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: service.isEmpty ? null : service,
                          decoration: InputDecoration(
                            labelText: 'Service',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.design_services_outlined,
                                color: Color(0xFF1A73E8)),
                          ),
                          dropdownColor: Colors.white,
                          hint: Text('Select Service'),
                          items: services.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                service = value;
                                switch (value) {
                                  case 'Nails':
                                    durationMinutes = 45;
                                    total = 500.0;
                                    break;
                                  case 'Bridal Makeup':
                                    durationMinutes = 120;
                                    total = 5000.0;
                                    break;
                                  case 'Haircut':
                                    durationMinutes = 30;
                                    total = 300.0;
                                    break;
                                  case 'Facewash':
                                    durationMinutes = 20;
                                    total = 200.0;
                                    break;
                                  case 'Hair Color':
                                    durationMinutes = 90;
                                    total = 1500.0;
                                    break;
                                  case 'Hair Spa':
                                    durationMinutes = 60;
                                    total = 1000.0;
                                    break;
                                }
                                endTime = addMinutesToTimeOfDay(
                                    startTime!, durationMinutes);
                              });
                            }
                          },
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.calendar_today),
                                label: Text(
                                    DateFormat('MMM dd, yyyy').format(date)),
                                onPressed: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: date,
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        DateTime.now().add(Duration(days: 365)),
                                  );
                                  if (pickedDate != null) {
                                    setState(() => date = pickedDate);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF1A73E8),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.access_time),
                                label: Text(startTime == null
                                    ? 'Select Time'
                                    : startTime!.format(context)),
                                onPressed: () async {
                                  final pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: Color(0xFF1A73E8),
                                            onPrimary: Colors.white,
                                            onSurface: Color(0xFF1A73E8),
                                            surface: Colors.white,
                                          ),
                                          timePickerTheme: TimePickerThemeData(
                                            backgroundColor: Colors.white,
                                            hourMinuteShape:
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: BorderSide(
                                                  color: Color(0xFF1A73E8)),
                                            ),
                                            dayPeriodBorderSide: BorderSide(
                                                color: Color(0xFF1A73E8)),
                                            dayPeriodColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            hourMinuteColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => states.contains(
                                                            MaterialState
                                                                .selected)
                                                        ? Color(0xFF1A73E8)
                                                            .withOpacity(0.12)
                                                        : Colors.transparent),
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  Color(0xFF1A73E8),
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedTime != null) {
                                    setState(() {
                                      startTime = pickedTime;
                                      endTime = addMinutesToTimeOfDay(
                                          pickedTime, durationMinutes);
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF1A73E8),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹${total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A73E8),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (name.isEmpty ||
                                mobileNumber.isEmpty ||
                                email.isEmpty ||
                                service.isEmpty ||
                                gender.isEmpty ||
                                startTime == null ||
                                total <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Please fill all fields correctly'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            setState(() {
                              appointments.add(Appointment(
                                name: nameController.text.trim(),
                                mobileNumber: mobileController.text.trim(),
                                email: emailController.text.trim(),
                                service: service,
                                artist: artist,
                                date: date,
                                startTime: startTime!,
                                endTime: endTime!,
                                total: total,
                                gender: gender,
                                durationMinutes: durationMinutes,
                                isAccepted: true,
                                status: 'pending',
                              ));
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Appointment added successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1A73E8),
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            'Add Appointment',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAppointmentEdit(BuildContext context, Appointment appointment) {
    final TextEditingController nameController =
        TextEditingController(text: appointment.name);
    final TextEditingController emailController =
        TextEditingController(text: appointment.email);
    final TextEditingController mobileController =
        TextEditingController(text: appointment.mobileNumber);
    final TextEditingController serviceController =
        TextEditingController(text: appointment.service);
    DateTime editDate = appointment.date;
    TimeOfDay editStartTime = appointment.startTime;
    String editGender = appointment.gender;
    String editStatus = appointment.status;
    double editTotal = appointment.total;

    List<String> services = [
      'Nails',
      'Bridal Makeup',
      'Haircut',
      'Facewash',
      'Hair colour'
    ];
    List<String> statuses = ['pending', 'ongoing', 'delayed', 'completed'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1A73E8), Color(0xFF4285F4)],
                    ),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Appointment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: mobileController,
                        decoration: InputDecoration(
                          labelText: 'Mobile',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: editGender,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.people_outline),
                        ),
                        items: ['Male', 'Female'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => editGender = value);
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: editStatus,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.pending_outlined),
                        ),
                        items: statuses.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Icon(
                                  appointment.getStatusIcon(),
                                  color: appointment.getStatusColor(),
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(value.toUpperCase()),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => editStatus = value);
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: serviceController.text,
                        decoration: InputDecoration(
                          labelText: 'Service',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.design_services_outlined,
                              color: Color(0xFF1A73E8)),
                        ),
                        hint: Text('Select Service'),
                        items: services.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              serviceController.text = value;
                              // Update price based on service
                              switch (value) {
                                case 'Nails':
                                  editTotal = 500.0;
                                  appointment.durationMinutes = 45;
                                  break;
                                case 'Bridal Makeup':
                                  editTotal = 5000.0;
                                  appointment.durationMinutes = 120;
                                  break;
                                case 'Haircut':
                                  editTotal = 300.0;
                                  appointment.durationMinutes = 30;
                                  break;
                                case 'Facewash':
                                  editTotal = 200.0;
                                  appointment.durationMinutes = 20;
                                  break;
                                case 'Hair colour':
                                  editTotal = 1500.0;
                                  appointment.durationMinutes = 90;
                                  break;
                              }
                            });
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: appointment.artist,
                        decoration: InputDecoration(
                          labelText: 'Artist',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon:
                              Icon(Icons.person_pin, color: Color(0xFF1A73E8)),
                        ),
                        items: artists.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => appointment.artist = value);
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.calendar_today),
                              label: Text(
                                DateFormat('MMM dd, yyyy').format(editDate),
                              ),
                              onPressed: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: editDate,
                                  firstDate: DateTime.now(),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 365)),
                                );
                                if (pickedDate != null) {
                                  setState(() => editDate = pickedDate);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1A73E8),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.access_time),
                              label: Text(editStartTime.format(context)),
                              onPressed: () async {
                                final pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: editStartTime,
                                );
                                if (pickedTime != null) {
                                  setState(() => editStartTime = pickedTime);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1A73E8),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${editTotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A73E8),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          // Update all appointment details
                          setState(() {
                            appointment.name = nameController.text;
                            appointment.email = emailController.text;
                            appointment.mobileNumber = mobileController.text;
                            appointment.gender = editGender;
                            appointment.service = serviceController.text;
                            appointment.date = editDate;
                            appointment.startTime = editStartTime;
                            appointment.endTime = addMinutesToTimeOfDay(
                                editStartTime, appointment.durationMinutes);
                            appointment.total = editTotal;
                            appointment.status = editStatus;
                          });

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Changes saved successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1A73E8),
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _printAppointmentDetails(
      BuildContext context, Appointment appointment) async {
    // Create PDF document
    final pdf = pw.Document();

    // Format times
    final startTimeStr = appointment.startTime.format(context);
    final endTimeStr = appointment.endTime.format(context);

    // Add content to PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context pdfContext) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('KECHI SALON & SPA',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Text('Client Details:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Name: ${appointment.name}'),
              pw.Text('Mobile: ${appointment.mobileNumber}'),
              pw.Text('Email: ${appointment.email}'),
              pw.SizedBox(height: 10),
              pw.Text('Service Details:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Service: ${appointment.service}'),
              pw.Text('Artist: ${appointment.artist}'),
              pw.Text('Duration: ${appointment.durationMinutes} mins'),
              pw.SizedBox(height: 10),
              pw.Text('Schedule:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(
                  'Date: ${DateFormat('EEEE, MMMM d, yyyy').format(appointment.date)}'),
              pw.Text('Time: $startTimeStr - $endTimeStr'),
              pw.SizedBox(height: 10),
              pw.Text('Payment:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Total Amount: ₹${appointment.total.toStringAsFixed(2)}'),
              pw.Text('Payment Mode: COD'),
              pw.SizedBox(height: 10),
              pw.Text('Status: ${appointment.status.toUpperCase()}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Thank you for choosing Kechi Salon & Spa!'),
              pw.Text('For any queries, feel free to contact us.'),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name:
          'Appointment_${appointment.name}_${DateFormat('yyyyMMdd').format(appointment.date)}.pdf',
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    Color getLineColor() {
      if (appointment.isAccepted && appointment.status == 'completed') {
        return Colors.green;
      } else if (appointment.status == 'rescheduled') {
        return Colors.orange;
      } else if (appointment.isAccepted) {
        return Colors.green;
      }
      return Color(0xFF1A73E8);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Color(0xFF1A73E8).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1A73E8).withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    color: getLineColor(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              appointment.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  appointment.getStatusColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  appointment.getStatusIcon(),
                                  size: 16,
                                  color: appointment.getStatusColor(),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  appointment.status.toUpperCase(),
                                  style: TextStyle(
                                    color: appointment.getStatusColor(),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₹${appointment.total.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A73E8),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'ID #${appointment.hashCode.abs() % 1000}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.email_outlined,
                              size: 14, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            appointment.email.isNotEmpty
                                ? appointment.email
                                : 'Email not provided',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                appointment.service,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '(${appointment.startTime.format(context)})',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (appointment.status == 'completed')
                                Text(
                                  ' - ${appointment.durationMinutes}mins',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                            ],
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: Color(0xFF1A73E8),
                            ),
                            onPressed: () =>
                                _showAppointmentEdit(context, appointment),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ... existing button row code ...
        ],
      ),
    );
  }
}
