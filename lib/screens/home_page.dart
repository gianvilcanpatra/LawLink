import 'dart:convert'; // Import this for JSON decoding
import 'package:lawyer_appointment_app/components/appointment_card.dart';
import 'package:lawyer_appointment_app/components/lawyer_card.dart';
import 'package:lawyer_appointment_app/models/auth_model.dart';
import 'package:lawyer_appointment_app/providers/dio_provider.dart'; // Import the DioProvider
import 'package:lawyer_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {};
  Map<String, dynamic> lawyer = {};
  List<dynamic> favList = [];
  String selectedCategory = 'All';
  List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.list,
      "category": "All",
    },
    {
      "icon": FontAwesomeIcons.userGraduate,
      "category": "General",
    },
    {
      "icon": FontAwesomeIcons.heartPulse,
      "category": "Divorce",
    },
    {
      "icon": FontAwesomeIcons.flag,
      "category": "Immigration",
    },
    {
      "icon": FontAwesomeIcons.moneyBill,
      "category": "Tax",
    },
  ];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isNotEmpty && token != '') {
      final response = await DioProvider().getUser(token);
      if (response != null) {
        setState(() {
          user = json.decode(response);

          for (var lawyerData in user['lawyer']) {
            if (lawyerData['appointments'] != null) {
              DateTime appointmentDate =
                  DateFormat('yMd').parse(lawyerData['appointments']['date']);
              DateTime today = DateTime.now();
              DateTime tomorrow = today.add(Duration(days: 1));
              if (appointmentDate.day == today.day ||
                  appointmentDate.day == tomorrow.day) {
                lawyer = lawyerData;
              }
            }
          }
        });
      }
    }
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    user = Provider.of<AuthModel>(context, listen: false).getUser;
    lawyer = Provider.of<AuthModel>(context, listen: false).getAppointment;
    favList = Provider.of<AuthModel>(context, listen: false).getFav;

    return Scaffold(
      // if user is empty, then return progress indicator
      body: user.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            user['name'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  AssetImage('assets/profile1.jpg'),
                            ),
                          )
                        ],
                      ),
                      Config.spaceMedium,
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall,
                      SizedBox(
                        height: Config.heightSize * 0.05,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              List<Widget>.generate(medCat.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                selectCategory(medCat[index]['category']);
                              },
                              child: Card(
                                margin: const EdgeInsets.only(right: 20),
                                color: selectedCategory ==
                                        medCat[index]['category']
                                    ? Colors.red
                                    : Colors.grey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      FaIcon(
                                        medCat[index]['icon'],
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        medCat[index]['category'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Config.spaceSmall,
                      const Text(
                        'Appointment Today',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall,
                      lawyer.isNotEmpty
                          ? AppointmentCard(
                              lawyer: lawyer,
                              color: const Color.fromARGB(255, 255, 47, 0),
                            )
                          : Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 188, 0, 0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    'No Appointment Today',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      Config.spaceSmall,
                      const Text(
                        'Available Lawyer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall,
                      Column(
                        children: List.generate(user['lawyer'].length, (index) {
                          if (selectedCategory == 'All' ||
                              user['lawyer'][index]['category'] ==
                                  selectedCategory) {
                            return LawyerCard(
                              lawyer: user['lawyer'][index],
                              // if latest fav list contains particular lawyer id, then show fav icon
                              isFav: favList
                                      .contains(user['lawyer'][index]['law_id'])
                                  ? true
                                  : false,
                            );
                          } else {
                            return Container();
                          }
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
