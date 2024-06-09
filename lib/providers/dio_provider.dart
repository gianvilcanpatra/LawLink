import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lawyer_appointment_app/models/review.dart';

class DioProvider {
  Future<dynamic> getLawyerDetails(String token) async {
    try {
      var response = await Dio().get(
        'http://127.0.0.1:8000/api/lawyers',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  //get token

  Future<dynamic> getToken(String email, String password) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/login',
          data: {'email': email, 'password': password});

      if (response.statusCode == 200 && response.data != '') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false; // Kembali nilai false jika terjadi kesalahan
    }
  }

  //get user data
  Future<dynamic> getUser(String token) async {
    try {
      var user = await Dio().get('http://127.0.0.1:8000/api/user',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (user.statusCode == 200 && user.data != '') {
        return json.encode(user.data);
      }
    } catch (error) {
      return error;
    }
  }

  //register new user
  Future<dynamic> registerUser(
      String username, String email, String password) async {
    try {
      var user = await Dio().post('http://127.0.0.1:8000/api/register',
          data: {'name': username, 'email': email, 'password': password});
      if (user.statusCode == 201 && user.data != '') {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return error;
    }
  }

  //store booking details
  Future<dynamic> bookAppointment(
      String date, String day, String time, int lawyer, String token) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/book',
          data: {'date': date, 'day': day, 'time': time, 'lawyer_id': lawyer},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //retrieve booking details
  Future<dynamic> getAppointments(String token) async {
    try {
      var response = await Dio().get('http://127.0.0.1:8000/api/appointments',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return json.encode(response.data);
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //store rating details
  Future<dynamic> storeReviews(
      String reviews, double ratings, int id, int lawyer, String token) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/reviews',
          data: {
            'ratings': ratings,
            'reviews': reviews,
            'appointment_id': id,
            'lawyer_id': lawyer
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //store fav lawyer
  Future<dynamic> storeFavLaw(String token, List<dynamic> favList) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/fav',
          data: {
            'favList': favList,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

//logout
  Future<dynamic> logout(String token) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  Future<bool> checkSlotAvailability(
      String date, String time, int lawyerId, String token) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/check-slot',
          data: {'date': date, 'time': time, 'lawyer_id': lawyerId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      return response.statusCode == 200;
    } catch (error) {
      return false;
    }
  }

  Future<int> cancelAppointment(int appointmentId, String token) async {
    try {
      var response = await Dio().post(
        'http://127.0.0.1:8000/api/appointments/cancel/$appointmentId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode ?? 500;
    } catch (error) {
      return 500;
    }
  }

  Future<int> rescheduleAppointment(
      int appointmentId, String date, String time, String token) async {
    try {
      final response = await Dio().post(
        'http://127.0.0.1:8000/api/reschedule',
        data: {
          'appointment_id': appointmentId,
          'date': date,
          'time': time,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.statusCode!;
    } catch (e) {
      print(e);
      return 400; // Return an error code if request fails
    }
  }

  //update user
  Future<bool> updateUser(String token, String? name, String? email) async {
    try {
      var response = await Dio().put(
        'http://127.0.0.1:8000/api/update',
        data: {'name': name, 'email': email},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.statusCode == 200;
    } catch (error) {
      return false;
    }
  }

  Future<bool> uploadPhoto(String token, File image) async {
    try {
      FormData formData = FormData.fromMap({
        'profile_photo': await MultipartFile.fromFile(image.path),
      });

      var response = await Dio().post(
        'http://127.0.0.1:8000/api/update/photo',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.statusCode == 200;
    } catch (error) {
      return false;
    }
  }
}
