import 'package:lawyer_appointment_app/main_layout.dart';
import 'package:lawyer_appointment_app/models/auth_model.dart';
import 'package:lawyer_appointment_app/screens/auth_page.dart';
import 'package:lawyer_appointment_app/screens/booking_page.dart';
import 'package:lawyer_appointment_app/screens/home_page.dart';
import 'package:lawyer_appointment_app/screens/success_booked.dart';
import 'package:lawyer_appointment_app/screens/update_profile.dart';
import 'package:lawyer_appointment_app/screens/detail_profile.dart';
import 'package:lawyer_appointment_app/utils/config.dart';
import 'package:lawyer_appointment_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //this is for push navigator
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    //define ThemeData here
    return ChangeNotifierProvider<AuthModel>(
      create: (context) => AuthModel(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Lawyer App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //pre-define input decoration
          inputDecorationTheme: const InputDecorationTheme(
            focusColor: Config.primaryColor,
            border: Config.outlinedBorder,
            focusedBorder: Config.focusBorder,
            errorBorder: Config.errorBorder,
            enabledBorder: Config.outlinedBorder,
            floatingLabelStyle: TextStyle(color: Config.primaryColor),
            prefixIconColor: Colors.black38,
          ),
          scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Color.fromARGB(255, 255, 0, 0),
            selectedItemColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.grey.shade700,
            elevation: 10,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthPage(),
          'main': (context) => const MainLayout(),
          'home_page': (context) => const HomePage(),
          'booking_page': (context) => BookingPage(),
          'booking': (context) => BookingPage(),
          'success_booking': (context) => const AppointmentBooked(),
          'update-profile': (context) => UpdateProfilePage(),
          'detail-profile': (context) => DetailProfile(),
        },
      ),
    );
  }
}
