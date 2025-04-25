import '../../domain/models/booking.dart';
import '../../domain/models/bookable_space.dart';
import '../api/api_client.dart';

class BookingRepository {
  final ApiClient _apiClient;

  BookingRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<Booking>> getBookings({
    DateTime? startDate,
    DateTime? endDate,
    String? spaceId,
    String? userId,
    BookingStatus? status,
  }) async {
    final queryParams = <String, dynamic>{
      if (startDate != null) 'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate.toIso8601String(),
      if (spaceId != null) 'spaceId': spaceId,
      if (userId != null) 'userId': userId,
      if (status != null) 'status': status.toString(),
    };

    final response =
        await _apiClient.get('/bookings', queryParameters: queryParams);
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => Booking.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Booking> createBooking({
    required BookableSpace space,
    required DateTime startTime,
    required DateTime endTime,
    String? comment,
  }) async {
    final response = await _apiClient.post(
      '/bookings',
      data: {
        'spaceId': space.id,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        if (comment != null) 'comment': comment,
      },
    );
    return Booking.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Booking> updateBooking({
    required String bookingId,
    DateTime? startTime,
    DateTime? endTime,
    String? comment,
    BookingStatus? status,
  }) async {
    final data = <String, dynamic>{
      if (startTime != null) 'startTime': startTime.toIso8601String(),
      if (endTime != null) 'endTime': endTime.toIso8601String(),
      if (comment != null) 'comment': comment,
      if (status != null) 'status': status.toString(),
    };

    final response = await _apiClient.put(
      '/bookings/$bookingId',
      data: data,
    );
    return Booking.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> cancelBooking(String bookingId) async {
    await _apiClient.delete('/bookings/$bookingId');
  }

  Future<List<Booking>> getSpaceBookings(
    String spaceId,
    DateTime date,
  ) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return getBookings(
      spaceId: spaceId,
      startDate: startOfDay,
      endDate: endOfDay,
      status: BookingStatus.confirmed,
    );
  }
}
