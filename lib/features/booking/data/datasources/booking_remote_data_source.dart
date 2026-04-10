import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/booking_api_model.dart';
import '../models/booking_model.dart';
import '../models/user_booking_model.dart';
import '../models/workspace_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<BookingModel>> getBookings();
  Future<BookingModel> addBooking(BookingModel booking);
  Future<void> cancelBooking(String bookingCode);
  Future<BookingModel> completeBooking(String id);
  Future<BookingResponseModel> createBooking(CreateBookingRequestModel request);
  Future<List<UserBookingModel>> getUserBookingDetails();
  Future<void> userCheckIn(String bookingCode, String otp);
  Future<List<WorkspaceModel>> searchWorkspaces(String keyword);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final DioClient client;
  final SharedPreferences sharedPreferences;

  BookingRemoteDataSourceImpl(
      {required this.client, required this.sharedPreferences});

  final List<BookingModel> _mockBookings = [];

  @override
  Future<BookingResponseModel> createBooking(
      CreateBookingRequestModel request) async {
    final jsonString = sharedPreferences.getString('CACHED_USER_DATA');
    String? token;
    if (jsonString != null) {
      token = Map<String, dynamic>.from(json.decode(jsonString))['token'];
    }

    final response = await client.post(
      ApiEndpoints.createBooking,
      data: request.toJson(),
      options: Options(
        headers: token != null ? {'Authentication': token} : {},
      ),
    );

    final data = response.data['data'];
    return BookingResponseModel.fromJson(data);
  }

  @override
  Future<List<BookingModel>> getBookings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockBookings;
  }

  @override
  Future<BookingModel> addBooking(BookingModel booking) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockBookings.insert(0, booking);
    return booking;
  }

  @override
  Future<void> cancelBooking(String bookingCode) async {
    final jsonString = sharedPreferences.getString('CACHED_USER_DATA');
    String? token;
    if (jsonString != null) {
      token = Map<String, dynamic>.from(json.decode(jsonString))['token'];
    }

    final response = await client.get(
      '${ApiEndpoints.cancelBooking}?bookingCode=$bookingCode',
      options: Options(
        headers: token != null ? {'Authentication': token} : {},
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data['message'] ?? 'Cancellation failed');
    }
  }

  @override
  Future<BookingModel> completeBooking(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockBookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      final b = _mockBookings[index];
      final completeBooking = BookingModel(
        id: b.id,
        placeId: b.placeId,
        placeName: b.placeName,
        location: b.location,
        imageUrl: b.imageUrl,
        date: b.date,
        timeSlot: b.timeSlot,
        tableNumber: b.tableNumber,
        subtotal: b.subtotal,
        tax: b.tax,
        total: b.total,
        isCompleted: true,
        placeType: b.placeType,
      );
      _mockBookings[index] = completeBooking;
      return completeBooking;
    }
    throw Exception('Booking not found');
  }

  @override
  Future<List<UserBookingModel>> getUserBookingDetails() async {
    final jsonString = sharedPreferences.getString('CACHED_USER_DATA');
    String? token;
    if (jsonString != null) {
      token = Map<String, dynamic>.from(json.decode(jsonString))['token'];
    }

    final response = await client.get(
      ApiEndpoints.getBookings,
      options: Options(
        headers: token != null ? {'Authentication': token} : {},
      ),
    );

    final List data = response.data['data'] ?? [];
    return data.map((json) => UserBookingModel.fromJson(json)).toList();
  }

  @override
  Future<void> userCheckIn(String bookingCode, String otp) async {
    final jsonString = sharedPreferences.getString('CACHED_USER_DATA');
    String? token;
    if (jsonString != null) {
      token = Map<String, dynamic>.from(json.decode(jsonString))['token'];
    }

    final response = await client.get(
      '${ApiEndpoints.checkIn}?bookingCode=$bookingCode&otp=$otp',
      options: Options(
        headers: token != null ? {'Authentication': token} : {},
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data['message'] ?? 'Check-in failed');
    }
  }

  @override
  Future<List<WorkspaceModel>> searchWorkspaces(String keyword) async {
    final jsonString = sharedPreferences.getString('CACHED_USER_DATA');
    String? token;
    if (jsonString != null) {
      token = Map<String, dynamic>.from(json.decode(jsonString))['token'];
    }

    final response = await client.get(
      '${ApiEndpoints.searchCafes}?keyword=$keyword',
      options: Options(
        headers: token != null ? {'Authentication': token} : {},
      ),
    );

    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? [];
      return data.map((json) => WorkspaceModel.fromJson(json)).toList();
    } else {
      // Return empty list for any error status (including 500) to show "No results found"
      return [];
    }
  }
}
