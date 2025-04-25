import 'package:flutter/material.dart';
import 'package:neoflex_booking/domain/models/bookable_space.dart';
import 'package:neoflex_booking/domain/models/meeting_room.dart';
import 'package:neoflex_booking/domain/models/test_spaces.dart';
import 'package:neoflex_booking/domain/models/workspace.dart';
import 'package:neoflex_booking/domain/models/workspace_type.dart';
import 'package:neoflex_booking/domain/models/workspace_zone.dart';
import 'package:neoflex_booking/presentation/widgets/floor_map.dart';
import 'package:neoflex_booking/presentation/widgets/space_details.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late List<BookableSpace> spaces;
  final Set<BookableSpace> selectedSpaces = {};
  String _filter = 'all';
  bool _selectionMode = false;
  bool _showLegend = false;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    spaces = TestSpaces.getDemoSpaces();
  }

  void _bookSpaces(List<BookableSpace> spacesToBook) {
    setState(() {
      for (var space in spacesToBook) {
        final index = spaces.indexOf(space);
        if (index != -1) {
          spaces = List.from(spaces)
            ..[index] = space is Workspace
                ? (space as Workspace).copyWith(isAvailable: false)
                : (space as MeetingRoom).copyWith(isAvailable: false);
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          spacesToBook.length == 1
              ? '${spacesToBook.first.name} забронировано'
              : 'Забронировано ${spacesToBook.length} мест',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleSpaceSelection(BookableSpace space) {
    if (!space.isAvailable) return;

    setState(() {
      if (selectedSpaces.contains(space)) {
        selectedSpaces.remove(space);
      } else {
        selectedSpaces.add(space);
      }
    });
  }

  void _showSpaceDetails(BookableSpace space) {
    if (_selectionMode) {
      _toggleSpaceSelection(space);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => SpaceDetails(
        space: space,
        onBook: space.isAvailable
            ? () {
                _bookSpaces([space]);
                Navigator.pop(context);
              }
            : null,
      ),
    );
  }

  void _showSelectedSpacesDetails() {
    if (selectedSpaces.isEmpty) return;

    final zone = WorkspaceZone(
      id: DateTime.now().toString(),
      name: 'Рабочая зона',
      description:
          'Выбранные места: ${selectedSpaces.map((e) => e.name).join(", ")}',
      spaces: selectedSpaces.toList(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Бронирование рабочей зоны'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Выбрано мест: ${selectedSpaces.length}'),
            const SizedBox(height: 8),
            Text('Общая вместимость: ${zone.totalCapacity} человек'),
            const SizedBox(height: 8),
            Text('Расположение: ${zone.locationDescription}'),
            const SizedBox(height: 16),
            const Text('Выбранные места:'),
            ...selectedSpaces.map((space) => Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text('• ${space.name}'),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              _bookSpaces(selectedSpaces.toList());
              setState(() {
                selectedSpaces.clear();
                _selectionMode = false;
              });
              Navigator.pop(context);
            },
            child: const Text('Забронировать'),
          ),
        ],
      ),
    );
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSpaces = spaces.where((space) {
      switch (_filter) {
        case 'booked':
          return !space.isAvailable;
        case 'free':
          return space.isAvailable;
        default:
          return true;
      }
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _filter,
                    onChanged: (String? newValue) {
                      setState(() {
                        _filter = newValue!;
                      });
                    },
                    items: <String>['all', 'booked', 'free']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value == 'all'
                              ? 'Все места'
                              : value == 'booked'
                                  ? 'Занятые'
                                  : 'Свободные',
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                IconButton(
                  icon: Icon(_selectionMode ? Icons.done : Icons.select_all),
                  onPressed: () {
                    setState(() {
                      if (_selectionMode) {
                        if (selectedSpaces.isNotEmpty) {
                          _showSelectedSpacesDetails();
                        } else {
                          _selectionMode = false;
                        }
                      } else {
                        _selectionMode = true;
                      }
                    });
                  },
                  tooltip:
                      _selectionMode ? 'Завершить выбор' : 'Выбрать несколько',
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_out_map),
                  onPressed: _resetZoom,
                  tooltip: 'Сбросить масштаб',
                ),
                IconButton(
                  icon: Icon(_showLegend
                      ? Icons.legend_toggle
                      : Icons.legend_toggle_outlined),
                  onPressed: () {
                    setState(() {
                      _showLegend = !_showLegend;
                    });
                  },
                  tooltip: _showLegend ? 'Скрыть легенду' : 'Показать легенду',
                ),
              ],
            ),
          ),
          if (_selectionMode)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Выбрано мест: ${selectedSpaces.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (selectedSpaces.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedSpaces.clear();
                        });
                      },
                      child: const Text('Очистить'),
                    ),
                ],
              ),
            ),
          Expanded(
            child: FloorMap(
              spaces: filteredSpaces,
              onSpaceSelected: _showSpaceDetails,
              transformationController: _transformationController,
              backgroundImage: 'assets/office_map.png',
              showLegend: _showLegend,
              mapSize: const Size(1200, 800),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }
}
