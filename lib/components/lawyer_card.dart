import 'package:lawyer_appointment_app/main.dart';
import 'package:lawyer_appointment_app/screens/lawyer_details.dart';
import 'package:lawyer_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';

class LawyerCard extends StatelessWidget {
  final Map<String, dynamic> lawyer;
  final bool isFav;

  const LawyerCard({
    Key? key,
    required this.lawyer,
    required this.isFav,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    double? rating = lawyer['average_rating']?.toDouble();
    int totalReviews = lawyer['total_reviews'] ?? 0;

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
                        "${lawyer['lawyer_name']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${lawyer['category']}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 16,
                          ),
                          const Spacer(flex: 1),
                          Text(rating != null
                              ? rating.toStringAsFixed(1)
                              : 'N/A'),
                          const Spacer(flex: 1),
                          const Text('Reviews'),
                          const Spacer(flex: 1),
                          Text('($totalReviews)'),
                          const Spacer(flex: 7),
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
                    lawyer: lawyer,
                    isFav: isFav,
                  )));
        },
      ),
    );
  }
}
