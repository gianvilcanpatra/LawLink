import 'package:lawyer_appointment_app/main.dart';
import 'package:lawyer_appointment_app/screens/lawyer_details.dart';
import 'package:lawyer_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:lawyer_appointment_app/providers/dio_provider.dart'; // Import DioProvider
import 'package:shared_preferences/shared_preferences.dart';

class LawyerCard extends StatefulWidget {
  const LawyerCard({
    Key? key,
    required this.lawyer,
    required this.isFav,
  }) : super(key: key);

  final Map<String, dynamic> lawyer;
  final bool isFav;

  @override
  _LawyerCardState createState() => _LawyerCardState();
}

class _LawyerCardState extends State<LawyerCard> {
  double? rating;
  int totalReviews = 0;

  @override
  void initState() {
    super.initState();
    _fetchLawyerDetails();
  }

  Future<void> _fetchLawyerDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      var data = await DioProvider().getLawyerDetails(token);
      if (data != null) {
        var lawyerDetails = data['lawyers']
            .firstWhere((lawyer) => lawyer['id'] == widget.lawyer['id']);
        setState(() {
          rating = lawyerDetails['rating']?.toDouble();
          totalReviews = lawyerDetails['total_reviews'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Row(
            children: [
              SizedBox(
                width: Config.widthSize * 0.33,
                child: Image.network(
                  'assets/lawyer_1.jpg',
                  fit: BoxFit.fill,
                ),
              ),
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${widget.lawyer['lawyer_name']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${widget.lawyer['category']}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 16,
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Text(rating != null ? rating!.toString() : 'N/A'),
                          Spacer(
                            flex: 1,
                          ),
                          Text('Reviews'),
                          Spacer(
                            flex: 1,
                          ),
                          Text('($totalReviews)'),
                          Spacer(
                            flex: 7,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          // Pass the details to detail page
          MyApp.navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (_) => LawyerDetails(
                    lawyer: widget.lawyer,
                    isFav: widget.isFav,
                  )));
        },
      ),
    );
  }
}
