import 'package:flutter/material.dart';
import '../../domain/models/workspace.dart';

class WorkSpaceMarker extends StatelessWidget {
  final double size;
  final bool booked;

  const WorkSpaceMarker({
    super.key,
    required this.size,
    required this.booked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: booked ? Colors.red[100] : Colors.green[100],
        border: Border.all(
          color: booked ? Colors.red : Colors.green,
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        color: booked ? Colors.red : Colors.green,
        size: size * 0.6,
      ),
    );
  }
}
