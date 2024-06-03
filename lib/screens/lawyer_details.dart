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
          //Favarite Button
          IconButton(
            //press this button to add/remove favorite lawyer
            onPressed: () async {
              //get latest favorite list from auth model
              final list =
                  Provider.of<AuthModel>(context, listen: false).getFav;

              //if law id is already exist, mean remove the law id
              if (list.contains(lawyer['law_id'])) {
                list.removeWhere((id) => id == lawyer['law_id']);
              } else {
                //else, add new lawyer to favorite list
                list.add(lawyer['law_id']);
              }

              //update the list into auth model and notify all widgets
              Provider.of<AuthModel>(context, listen: false).setFavList(list);

              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              final token = prefs.getString('token') ?? '';

              if (token.isNotEmpty && token != '') {
                //update the favorite list into database
                final response = await DioProvider().storeFavLaw(token, list);
                //if insert successfully, then change the favorite status

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
            AboutLawyer(
              lawyer: lawyer,
            ),
            DetailBody(
              lawyer: lawyer,
            ),
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
                color: Colors.black,
                fontWeight: FontWeight.bold,
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
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Config.spaceSmall,
          LawyerInfo(
            patients: lawyer['patients'],
            exp: lawyer['experience'],
            // rating: lawyer['rating'], // Add this line
          ),
          Config.spaceMedium,
          const Text(
            'About Lawyer',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Config.spaceSmall,
          Text(
            '${lawyer['lawyer_name']} is an experience ${lawyer['category']} Lawyer in Jakarta, graduated since 2008, and completed his/her at Universitas Gadjah Mada.',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            softWrap: true,
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}

class LawyerInfo extends StatelessWidget {
  const LawyerInfo({
    Key? key,
    required this.patients,
    required this.exp,
    // this.rating, // Add rating
  }) : super(key: key);

  final int patients;
  final int exp;
  // final double rating; // Add rating

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InfoCard(
          label: 'Client',
          value: '$patients',
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
          value: '5', // Display rating from backend
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
