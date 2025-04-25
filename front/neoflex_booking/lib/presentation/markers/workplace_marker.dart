import 'package:flutter/material.dart';
import 'office_marker.dart';

enum WorkspaceType {
  noComputer,
  withMonitor,
  withOneMonitor,
  withDualMonitor,
}

class WorkPlaceMarker extends OfficeMarker {
  final WorkspaceType type;
  final int? deskNumber;

  const WorkPlaceMarker({
    super.key,
    required super.booked,
    required this.type,
    this.deskNumber,
    super.selected = false,
    super.isLegend = false,
    super.size = 40,
    super.color = Colors.red,
  });

  @override
  State<WorkPlaceMarker> createState() => _WorkPlaceMarkerState();
}

class _WorkPlaceMarkerState extends State<WorkPlaceMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  static const double _iconSize = 12.0;
  static const EdgeInsets _iconPadding = EdgeInsets.all(2);

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

  IconData _getIconForType() {
    switch (widget.type) {
      case WorkspaceType.noComputer:
        return Icons.table_restaurant;
      case WorkspaceType.withMonitor:
        return Icons.laptop_mac;
      case WorkspaceType.withOneMonitor:
        return Icons.desktop_windows;
      case WorkspaceType.withDualMonitor:
        return Icons.view_array;
    }
  }

  Widget _buildDeskNumber() {
    if (widget.deskNumber == null) return const SizedBox.shrink();

    return Text(
      '${widget.deskNumber}',
      style: TextStyle(
        color: widget.booked ? Colors.grey : widget.color,
        fontSize: widget.size * 0.3,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildBookedIcon() {
    if (!widget.booked) return const SizedBox.shrink();

    return Positioned(
      right: 0,
      top: -8,
      child: Container(
        padding: _iconPadding,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close,
          color: Colors.white,
          size: _iconSize,
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
          _getIconForType(),
          color: color,
          size: widget.size,
        ),
        _buildDeskNumber(),
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
            _buildBookedIcon(),
          ],
        ),
      ),
    );
  }
}
