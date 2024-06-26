import 'package:lawyer_appointment_app/components/button.dart';
import 'package:lawyer_appointment_app/components/custom_appbar.dart';
import 'package:lawyer_appointment_app/main.dart';
import 'package:lawyer_appointment_app/models/booking_datetime_converted.dart';
import 'package:lawyer_appointment_app/providers/dio_provider.dart';
import 'package:lawyer_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingPage extends StatefulWidget {
  BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _dateSelected = false;
  bool _timeSelected = false;
  String? token;
  bool isReschedule = false;
  int? appointmentId;

  Future<void> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  bool isTimeSlotDisabled(int index) {
    final now = DateTime.now();
    if (_currentDay.year == now.year &&
        _currentDay.month == now.month &&
        _currentDay.day == now.day) {
      // Check if the current slot time has passed
      final slotTime = DateTime(now.year, now.month, now.day, index + 9);
      return slotTime.isBefore(now);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    final lawyer = ModalRoute.of(context)!.settings.arguments as Map;
    isReschedule = lawyer.containsKey('appointmentId');
    if (isReschedule) {
      appointmentId = lawyer['appointmentId'];
    }
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Appointment',
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                _tableCalendar(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Center(
                    child: Text(
                      'Select Consultation Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final isDisabled = isTimeSlotDisabled(index);
                return InkWell(
                  splashColor: Colors.transparent,
                  onTap: isDisabled
                      ? null
                      : () {
                          setState(() {
                            _currentIndex = index;
                            _timeSelected = true;
                          });
                        },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: isDisabled
                          ? Colors.grey
                          : _currentIndex == index
                              ? Config.primaryColor
                              : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 9}:00 ${index + 9 >= 12 ? "PM" : "AM"}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDisabled
                            ? Colors.white
                            : _currentIndex == index
                                ? Colors.white
                                : null,
                      ),
                    ),
                  ),
                );
              },
              childCount: 8,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: 1.5),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: Button(
                width: double.infinity,
                title: isReschedule
                    ? 'Reschedule Appointment'
                    : 'Make Appointment',
                onPressed: () async {
                  final getDate = DateConverted.getDate(_currentDay);
                  final getDay = DateConverted.getDay(_currentDay.weekday);
                  final getTime = DateConverted.getTime(_currentIndex!);

                  bool isAvailable = await DioProvider().checkSlotAvailability(
                      getDate, getTime, lawyer['lawyer_id'], token!);

                  if (!isAvailable) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Booking Failed'),
                          content: Text('Slot already booked!'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  if (isReschedule) {
                    final response = await DioProvider().rescheduleAppointment(
                        appointmentId!, getDate, getTime, token!);
                    if (response == 200) {
                      MyApp.navigatorKey.currentState!
                          .pushNamed('success_booking');
                    }
                  } else {
                    final booking = await DioProvider().bookAppointment(
                        getDate, getDay, getTime, lawyer['lawyer_id'], token!);
                    if (booking == 200) {
                      MyApp.navigatorKey.currentState!
                          .pushNamed('success_booking');
                    }
                  }
                },
                disable: _timeSelected && _dateSelected ? false : true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(Duration(days: 366)),
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 48,
      calendarStyle: const CalendarStyle(
        todayDecoration:
            BoxDecoration(color: Config.primaryColor, shape: BoxShape.circle),
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          _dateSelected = true;
          _currentIndex = null; // Reset selected time slot when date changes
          _timeSelected = false; // Reset time selected flag
        });
      },
    );
  }
}
