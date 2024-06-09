import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lawyer_appointment_app/components/button.dart';
import 'package:lawyer_appointment_app/models/auth_model.dart';
import 'package:lawyer_appointment_app/providers/dio_provider.dart';
import 'package:lawyer_appointment_app/utils/config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_appbar.dart';

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
    super.initState();
    lawyer = widget.lawyer;
    isFav = widget.isFav;
    fetchLawyerDetails();
  }

  void fetchLawyerDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isNotEmpty) {
      final response = await DioProvider().getLawyerDetails(token);
      if (response != null) {
        setState(() {
          lawyer = response;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Lawyer Details',
        icon: const FaIcon(Icons.arrow_back_ios),
        actions: [
          IconButton(
            onPressed: () async {
              final list =
                  Provider.of<AuthModel>(context, listen: false).getFav;
              if (list.contains(lawyer['law_id'])) {
                list.removeWhere((id) => id == lawyer['law_id']);
              } else {
                list.add(lawyer['law_id']);
              }
              Provider.of<AuthModel>(context, listen: false).setFavList(list);
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              final token = prefs.getString('token') ?? '';
              if (token.isNotEmpty) {
                final response = await DioProvider().storeFavLaw(token, list);
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
            AboutLawyer(lawyer: lawyer),
            const InfoBox(),
            DetailBody(lawyer: lawyer),
            ReviewsList(reviews: lawyer['reviews'] ?? []),
            const Spacer(),
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

class InfoBox extends StatelessWidget {
  const InfoBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InfoCard(
          title: 'Clients',
          value: '100+',
          icon: Icons.person,
          color: Colors.blue,
        ),
        InfoCard(
          title: 'Experience',
          value: '10 Years',
          icon: Icons.work,
          color: Colors.orange,
        ),
        InfoCard(
          title: 'Rating',
          value: '4.8',
          icon: Icons.star,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const InfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            color: color,
            size: 32.0,
          ),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
        ],
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
        child: Column(children: <Widget>[
          CircleAvatar(
            radius: 65.0,
            backgroundImage: NetworkImage(
              "http://127.0.0.1:8000${lawyer['lawyer_profile']}",
            ),
            backgroundColor: Colors.white,
          ),
          Config.spaceMedium,
          Text(
            "Mr ${lawyer['lawyer_name']}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'S1 Ilmu Hukum Universitar Gadjah Mada ( Yogyakarta )',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'Kantor Pengadilan Jakarta',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.yellow[600], size: 20),
              SizedBox(width: 5),
              Text(
                lawyer['average_rating']?.toStringAsFixed(1) ?? 'N/A',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ]));
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({Key? key, required this.lawyer}) : super(key: key);

  final Map<dynamic, dynamic> lawyer;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    final List availabilities = lawyer['availability'] ?? [];

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Config.spaceSmall,
          Text(
            lawyer['description'] ?? 'No description available.',
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.justify,
            softWrap: true,
          ),
          Config.spaceMedium,
          const Text(
            'Available Time',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Config.spaceSmall,
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
        ],
      ),
    );
  }
}
