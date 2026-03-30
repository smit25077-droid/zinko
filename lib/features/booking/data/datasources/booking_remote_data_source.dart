import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<BookingModel>> getBookings();
  Future<BookingModel> addBooking(BookingModel booking);
  Future<void> removeBooking(String id);
  Future<BookingModel> completeBooking(String id);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final List<BookingModel> _mockBookings = [];

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
  Future<void> removeBooking(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockBookings.removeWhere((b) => b.id == id);
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
}
