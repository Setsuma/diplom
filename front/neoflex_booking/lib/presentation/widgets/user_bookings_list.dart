import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/booking.dart';
import '../../data/repositories/booking_repository.dart';

class UserBookingsList extends StatefulWidget {
  final String userId;

  const UserBookingsList({
    super.key,
    required this.userId,
  });

  @override
  State<UserBookingsList> createState() => _UserBookingsListState();
}

class _UserBookingsListState extends State<UserBookingsList> {
  final _bookingRepository = BookingRepository();
  List<Booking>? _bookings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final bookings = await _bookingRepository.getBookings(
        userId: widget.userId,
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 30)),
      );

      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при загрузке бронирований: $e'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _cancelBooking(Booking booking) async {
    try {
      await _bookingRepository.cancelBooking(booking.id);
      await _loadBookings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Бронирование отменено'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при отмене бронирования: $e'),
          ),
        );
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm', 'ru');
    return dateFormat.format(dateTime);
  }

  Color _getStatusColor(BookingStatus status) {
    return switch (status) {
      BookingStatus.confirmed => Colors.green,
      BookingStatus.pending => Colors.orange,
      BookingStatus.cancelled => Colors.red,
      BookingStatus.expired => Colors.grey,
    };
  }

  String _getStatusText(BookingStatus status) {
    return switch (status) {
      BookingStatus.confirmed => 'Подтверждено',
      BookingStatus.pending => 'Ожидает подтверждения',
      BookingStatus.cancelled => 'Отменено',
      BookingStatus.expired => 'Истекло',
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_bookings == null || _bookings!.isEmpty) {
      return const Center(
        child: Text('Нет бронирований'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _bookings!.length,
      itemBuilder: (context, index) {
        final booking = _bookings![index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(booking.space.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Начало: ${_formatDateTime(booking.startTime)}'),
                Text('Окончание: ${_formatDateTime(booking.endTime)}'),
                if (booking.comment != null)
                  Text(
                    'Комментарий: ${booking.comment}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withOpacity(0.1),
                    border: Border.all(
                      color: _getStatusColor(booking.status),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getStatusText(booking.status),
                    style: TextStyle(
                      color: _getStatusColor(booking.status),
                      fontSize: 12,
                    ),
                  ),
                ),
                if (booking.isActive || booking.isPending)
                  TextButton(
                    onPressed: () => _cancelBooking(booking),
                    child: const Text(
                      'Отменить',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
