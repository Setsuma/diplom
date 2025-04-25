import 'package:flutter/material.dart';
import '../widgets/booking_date_picker.dart';
import '../../domain/models/booking.dart';
import '../../domain/models/bookable_space.dart';

class BookingDialog extends StatefulWidget {
  final BookableSpace space;

  const BookingDialog({
    super.key,
    required this.space,
  });

  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _startTime = const TimeOfDay(hour: 9, minute: 0);
    _endTime = const TimeOfDay(hour: 10, minute: 0);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onDateTimeSelected(
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
  ) {
    setState(() {
      _selectedDate = date;
      _startTime = startTime;
      _endTime = endTime;
    });
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  void _handleBooking() {
    final booking = Booking(
      id: '',
      space: widget.space,
      user: null, // Будет установлено в репозитории
      startTime: _combineDateAndTime(_selectedDate, _startTime),
      endTime: _combineDateAndTime(_selectedDate, _endTime),
      comment: _commentController.text,
      status: BookingStatus.pending,
    );

    Navigator.of(context).pop(booking);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Бронирование ${widget.space.name}',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            BookingDatePicker(
              initialDate: _selectedDate,
              initialStartTime: _startTime,
              initialEndTime: _endTime,
              onDateTimeSelected: _onDateTimeSelected,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Комментарий',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Отмена'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _handleBooking,
                  child: const Text('Забронировать'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
