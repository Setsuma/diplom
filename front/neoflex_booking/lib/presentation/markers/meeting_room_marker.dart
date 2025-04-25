import 'package:flutter/material.dart';
import 'office_marker.dart';

class MeetingRoomMarker extends OfficeMarker {
  final int capacity;
  final bool hasVideoConference;
  final bool hasWhiteboard;

  const MeetingRoomMarker({
    super.key,
    required super.booked,
    required this.capacity,
    required this.hasVideoConference,
    required this.hasWhiteboard,
    super.selected = false,
    super.isLegend = false,
    super.size = 40,
    super.color = Colors.blue,
  });

  @override
  State<MeetingRoomMarker> createState() => _MeetingRoomMarkerState();
}

class _MeetingRoomMarkerState extends State<MeetingRoomMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  static const double _iconSize = 10.0;
  static const double _iconSpacing = 16.0;
  static const EdgeInsets _iconPadding = EdgeInsets.all(1.5);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _animation = Tween(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (!widget.booked && !widget.isLegend) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFeatureIcon({
    required IconData icon,
    required Color color,
    required double top,
    required bool isLeft,
  }) {
    return Positioned(
      top: top,
      left: isLeft ? 0 : null,
      right: isLeft ? null : 0,
      child: Container(
        padding: _iconPadding,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: _iconSize,
        ),
      ),
    );
  }

  Widget _buildCapacityLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: widget.booked ? Colors.grey : widget.color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${widget.capacity}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.booked ? Colors.grey : widget.color;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.meeting_room,
          color: color,
          size: widget.size,
        ),
        _buildCapacityLabel(),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: widget.selected
          ? BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            )
          : null,
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (!widget.booked && !widget.isLegend)
              ScaleTransition(
                scale: _animation,
                child: content,
              )
            else
              content,
            if (widget.hasVideoConference)
              _buildFeatureIcon(
                icon: Icons.videocam,
                color: widget.booked ? Colors.grey : Colors.green,
                top: -8,
                isLeft: false,
              ),
            if (widget.hasWhiteboard)
              _buildFeatureIcon(
                icon: Icons.edit,
                color: widget.booked ? Colors.grey : Colors.orange,
                top: widget.hasVideoConference ? _iconSpacing - 8 : -8,
                isLeft: false,
              ),
            if (widget.booked)
              _buildFeatureIcon(
                icon: Icons.close,
                color: Colors.red,
                top: -8,
                isLeft: true,
              ),
          ],
        ),
      ),
    );
  }
}
