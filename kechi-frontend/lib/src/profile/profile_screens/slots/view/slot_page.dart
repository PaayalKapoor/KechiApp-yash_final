import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kechi/shared/theme/theme.dart';

class ArtistAvailabilityScheduler extends StatefulWidget {
  const ArtistAvailabilityScheduler({Key? key}) : super(key: key);

  @override
  _ArtistAvailabilitySchedulerState createState() =>
      _ArtistAvailabilitySchedulerState();
}

class _ArtistAvailabilitySchedulerState
    extends State<ArtistAvailabilityScheduler> with TickerProviderStateMixin {
  // Theme color
  final Color primaryColor = const Color(0xFF1A73E8);
  final Color secondaryColor = const Color(0xFF5C9CE6);
  final Color accentColor = const Color(0xFF8AB4F8);

  // For animations
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Selected days
  final List<String> weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  final Map<String, bool> selectedDays = {
    'Mon': true,
    'Tue': true,
    'Wed': true,
    'Thu': true,
    'Fri': true,
    'Sat': false,
    'Sun': false,
  };
  bool allDaysSelected = true;

  // Time slots
  final List<String> hourOptions = List.generate(24, (index) {
    final hour = index;
    return hour < 10 ? '0$hour:00' : '$hour:00';
  });

  String openTime = '08:00';
  String closeTime = '22:00';

  // For advanced features
  bool enableBreakTime = false;
  String breakStartTime = '12:00';
  String breakEndTime = '13:00';

  bool enableSlotBlockers = true;
  List<BlockedTimeSlot> blockedSlots = [];

  // For dual timing slots
  bool enableDualTiming = false;
  String secondShiftStartTime = '17:00';
  String secondShiftEndTime = '22:00';

  // For additional settings
  int slotDuration = 60; // in minutes
  bool allowWeekendsBooking = false;
  bool enableBufferTime = false;
  int bufferTime = 15; // in minutes

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();

    // Add some sample blocked slots
    blockedSlots.add(
      BlockedTimeSlot(
        id: '1',
        title: 'Lunch Break',
        day: 'All Days',
        startTime: '12:00',
        endTime: '13:00',
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleAllDays(bool? value) {
    setState(() {
      allDaysSelected = value ?? false;
      for (var day in weekDays) {
        selectedDays[day] = allDaysSelected;
      }
    });
  }

  void _toggleDay(String day) {
    setState(() {
      selectedDays[day] = !(selectedDays[day] ?? false);

      // Check if all days are selected
      allDaysSelected = selectedDays.values.every((selected) => selected);
    });
  }

  void _addBlockedSlot() {
    setState(() {
      blockedSlots.add(
        BlockedTimeSlot(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Blocked Time',
          day: 'Mon',
          startTime: '14:00',
          endTime: '15:00',
        ),
      );
    });
  }

  void _removeBlockedSlot(String id) {
    setState(() {
      blockedSlots.removeWhere((slot) => slot.id == id);
    });
  }

  void _showTimePicker(BuildContext context, String currentTime,
      Function(String) onTimeSelected) async {
    final parts = currentTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final hour = pickedTime.hour.toString().padLeft(2, '0');
      final minute = pickedTime.minute.toString().padLeft(2, '0');
      onTimeSelected('$hour:$minute');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Update Availability',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(),
                _buildWeekdaySelector(),
                _buildBusinessHours(),
                if (enableDualTiming) _buildDualTimingSection(),
                _buildAdvancedSettings(),
                _buildBlockedTimeSlots(),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Let your customers know when to reach you. You can also configure dual timing slots in a single day.',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdaySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Days of the Week',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDays.map((day) => _buildDayButton(day)).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: allDaysSelected,
                activeColor: primaryColor,
                onChanged: _toggleAllDays,
              ),
              Text(
                'Select All Days',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayButton(String day) {
    final isSelected = selectedDays[day] ?? false;

    return GestureDetector(
      onTap: () => _toggleDay(day),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessHours() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, color: primaryColor),
              const SizedBox(width: 8),
              const Text(
                'Business Hours',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Opens at',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTimeSelector(openTime, (newTime) {
                      setState(() {
                        openTime = newTime;
                      });
                    }),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Closes at',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTimeSelector(closeTime, (newTime) {
                      setState(() {
                        closeTime = newTime;
                      });
                    }),
                  ],
                ),
              ),
            ],
          ),

          // Toggle for dual timing
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              setState(() {
                enableDualTiming = !enableDualTiming;
              });
            },
            child: Row(
              children: [
                Switch(
                  value: enableDualTiming,
                  activeColor: primaryColor,
                  onChanged: (value) {
                    setState(() {
                      enableDualTiming = value;
                    });
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  'Enable Dual Timing (Split Shift)',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDualTimingSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, color: secondaryColor),
              const SizedBox(width: 8),
              const Text(
                'Second Shift Hours',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Opens at',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTimeSelector(secondShiftStartTime, (newTime) {
                      setState(() {
                        secondShiftStartTime = newTime;
                      });
                    }),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Closes at',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTimeSelector(secondShiftEndTime, (newTime) {
                      setState(() {
                        secondShiftEndTime = newTime;
                      });
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune, color: primaryColor),
              const SizedBox(width: 8),
              const Text(
                'Advanced Settings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Slot duration
          Row(
            children: [
              const Text(
                'Appointment Duration:',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<int>(
                  value: slotDuration,
                  underline: const SizedBox(),
                  icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                  items: [30, 45, 60, 90, 120].map((duration) {
                    return DropdownMenuItem<int>(
                      value: duration,
                      child: Text(
                        duration == 60 ? '1 hour' : '$duration min',
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      slotDuration = value!;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Buffer time
          Row(
            children: [
              Switch(
                value: enableBufferTime,
                activeColor: primaryColor,
                onChanged: (value) {
                  setState(() {
                    enableBufferTime = value;
                  });
                },
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Add buffer time between appointments',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          if (enableBufferTime)
            Padding(
              padding: const EdgeInsets.only(left: 56),
              child: Row(
                children: [
                  const Text(
                    'Buffer Duration:',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<int>(
                      value: bufferTime,
                      underline: const SizedBox(),
                      icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                      items: [5, 10, 15, 20, 30].map((duration) {
                        return DropdownMenuItem<int>(
                          value: duration,
                          child: Text(
                            '$duration min',
                            style: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          bufferTime = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Allow weekends
          Row(
            children: [
              Switch(
                value: allowWeekendsBooking,
                activeColor: primaryColor,
                onChanged: (value) {
                  setState(() {
                    allowWeekendsBooking = value;
                    if (value) {
                      selectedDays['Sat'] = true;
                      selectedDays['Sun'] = true;
                    } else {
                      selectedDays['Sat'] = false;
                      selectedDays['Sun'] = false;
                    }
                    // Update all days selected
                    allDaysSelected =
                        selectedDays.values.every((selected) => selected);
                  });
                },
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Allow weekend bookings',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Break time
          Row(
            children: [
              Switch(
                value: enableBreakTime,
                activeColor: primaryColor,
                onChanged: (value) {
                  setState(() {
                    enableBreakTime = value;
                  });
                },
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Set daily break time',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          if (enableBreakTime)
            Padding(
              padding: const EdgeInsets.only(left: 56, top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Break starts',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildTimeSelector(breakStartTime, (newTime) {
                          setState(() {
                            breakStartTime = newTime;
                          });
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Break ends',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildTimeSelector(breakEndTime, (newTime) {
                          setState(() {
                            breakEndTime = newTime;
                          });
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBlockedTimeSlots() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.block, color: primaryColor),
                  const SizedBox(width: 8),
                  const Text(
                    'Blocked Time Slots',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: _addBlockedSlot,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.add, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Switch(
                value: enableSlotBlockers,
                activeColor: primaryColor,
                onChanged: (value) {
                  setState(() {
                    enableSlotBlockers = value;
                  });
                },
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Enable blocked time slots / off schedule',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          if (enableSlotBlockers && blockedSlots.isNotEmpty)
            const SizedBox(height: 16),
          if (enableSlotBlockers)
            ...blockedSlots.map((slot) => _buildBlockedSlotItem(slot)).toList(),
        ],
      ),
    );
  }

  Widget _buildBlockedSlotItem(BlockedTimeSlot slot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.event_busy,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${slot.day} • ${slot.startTime} - ${slot.endTime}',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
            onPressed: () => _removeBlockedSlot(slot.id),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(
      String currentTime, Function(String) onTimeSelected) {
    return InkWell(
      onTap: () => _showTimePicker(context, currentTime, onTimeSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentTime,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Handle save
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Availability updated successfully!'),
              backgroundColor: primaryColor,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Save Availability',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Model classes
class BlockedTimeSlot {
  final String id;
  final String title;
  final String day;
  final String startTime;
  final String endTime;

  BlockedTimeSlot({
    required this.id,
    required this.title,
    required this.day,
    required this.startTime,
    required this.endTime,
  });
}

// Main app widget
class ArtistSchedulerApp extends StatelessWidget {
  const ArtistSchedulerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kechi Artist Scheduler',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const ArtistAvailabilityScheduler(),
    );
  }
}

void main() {
  runApp(const ArtistSchedulerApp());
}
