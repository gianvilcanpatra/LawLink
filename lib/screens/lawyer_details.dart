import 'package:lawyer_appointment_app/components/button.dart';
import 'package:lawyer_appointment_app/models/auth_model.dart';
import 'package:lawyer_appointment_app/providers/dio_provider.dart';
import 'package:lawyer_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components//custom_appbar.dart';

class LawyerDetails extends StatefulWidget {
  const LawyerDetails({Key? key, required this.lawyer, required this.isFav})
      : super(key: key);
  final Map<String, dynamic> lawyer;
  final bool isFav;

  @override
  State<LawyerDetails> createState() => _LawyerDetailsState();
}

class _LawyerDetailsState extends State<LawyerDetails> {
  Map<String, dynamic> lawyer = {};
  bool isFav = false;

  @override
  void initState() {
    lawyer = widget.lawyer;
    isFav = widget.isFav;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Lawyer Details',
        icon: const FaIcon(Icons.arrow_back_ios),
        actions: [
          // Favorite Button
          IconButton(
            // Press this button to add/remove favorite lawyer
            onPressed: () async {
              // Get latest favorite list from auth model
              final list =
                  Provider.of<AuthModel>(context, listen: false).getFav;

              // If law id is already exist, mean remove the law id
              if (list.contains(lawyer['law_id'])) {
                list.removeWhere((id) => id == lawyer['law_id']);
              } else {
                // Else, add new lawyer to favorite list
                list.add(lawyer['law_id']);
              }

              // Update the list into auth model and notify all widgets
              Provider.of<AuthModel>(context, listen: false).setFavList(list);

              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              final token = prefs.getString('token') ?? '';

              if (token.isNotEmpty && token != '') {
                // Update the favorite list into database
                final response = await DioProvider().storeFavLaw(token, list);
                // If insert successfully, then change the favorite status
                if (response == 200) {
                  setState(() {
                    isFav = !isFav;
                  });
                }
              }
            },
            icon: FaIcon(
              isFav ? Icons.favorite_rounded : Icons.favorite_outline,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    AboutLawyer(
                      lawyer: lawyer,
                    ),
                    DetailBody(
                      lawyer: lawyer,
                    ),
                    ReviewsList(reviews: lawyer['reviews'] ?? []),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Button(
                width: double.infinity,
                title: 'Book Appointment',
                onPressed: () {
                  Navigator.of(context).pushNamed('booking_page',
                      arguments: {"lawyer_id": lawyer['law_id']});
                },
                disable: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewsList extends StatelessWidget {
  const ReviewsList({Key? key, required this.reviews}) : super(key: key);

  final List reviews;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'User Reviews',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: 10),
          ...reviews.map((review) {
            return ReviewItem(review: review);
          }).toList(),
        ],
      ),
    );
  }
}

class ReviewItem extends StatelessWidget {
  const ReviewItem({Key? key, required this.review}) : super(key: key);

  final Map review;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                review['reviewed_by'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${review['ratings']} Stars',
                style: TextStyle(color: Colors.orange.shade600),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(review['reviews']),
        ],
      ),
    );
  }
}

class AboutLawyer extends StatelessWidget {
  const AboutLawyer({Key? key, required this.lawyer}) : super(key: key);

  final Map<dynamic, dynamic> lawyer;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/lawyer_1.jpg',
            width: 250.0,
            height: 250.0,
          ),
          Config.spaceSmall,
          Text(
            "Mr ${lawyer['lawyer_name']}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Config.spaceMedium, // Added space between bio and education

          // Bio data
          SizedBox(
            width: Config.widthSize * 0.75,
            child: Text(
              lawyer['bio_data'] ?? 'No bio data available.',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.left,
            ),
          ),

          Config.spaceSmall, // Added space after bio

          // Education
          Text(
            "Pendidikan terakhir:", // Added label for education
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: Config.widthSize * 0.75,
            child: Text(
              lawyer['pendidikan'] ?? 'No pendidikan available.',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({Key? key, required this.lawyer}) : super(key: key);

  final Map<dynamic, dynamic> lawyer;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    final List availabilities = lawyer['availability'] ?? [];

    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...availabilities.map((availability) {
              return Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    availability['date'] ?? 'N/A',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ],
              );
            }).toList(),
            LawyerInfo(
              totalReviews: lawyer['total_reviews'],
              exp: lawyer['experience'],
              rating: lawyer['average_rating'],
            ),
          ],
        ),
      ),
    );
  }
}

class LawyerInfo extends StatelessWidget {
  const LawyerInfo({
    Key? key,
    required this.totalReviews,
    required this.exp,
    required this.rating,
  }) : super(key: key);

  final int totalReviews;
  final int exp;
  final double? rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InfoCard(
          label: 'Total Reviews',
          value: totalReviews.toString(),
        ),
        const SizedBox(
          width: 15,
        ),
        InfoCard(
          label: 'Experiences',
          value: '$exp years',
        ),
        const SizedBox(
          width: 15,
        ),
        InfoCard(
          label: 'Rating',
          value: rating != null ? rating.toString() : 'N/A',
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key, required this.label, required this.value})
      : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(255, 255, 65, 65),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
