import 'package:flutter/material.dart';

abstract class OfficeMarker extends StatefulWidget {
  final bool booked;
  final bool selected;
  final bool isLegend;
  final double size;
  final Color color;

  const OfficeMarker({
    super.key,
    required this.booked,
    this.selected = false,
    this.isLegend = false,
    this.size = 40,
    this.color = Colors.red,
  });
}
