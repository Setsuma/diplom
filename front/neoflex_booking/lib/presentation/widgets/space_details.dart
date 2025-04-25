import 'package:flutter/material.dart';
import 'package:neoflex_booking/domain/models/bookable_space.dart';
import 'package:neoflex_booking/domain/models/meeting_room.dart';
import 'package:neoflex_booking/domain/models/workspace.dart';

class SpaceDetails extends StatelessWidget {
  final BookableSpace space;
  final VoidCallback? onBook;

  const SpaceDetails({
    super.key,
    required this.space,
    this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      space.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildStatusChip(),
              const SizedBox(height: 16),
              _buildInfoSection('Расположение', space.location),
              if (space.description.isNotEmpty)
                _buildInfoSection('Описание', space.description),
              if (space is Workspace) ...[
                _buildInfoSection(
                    'Тип места', (space as Workspace).type.displayName),
                _buildInfoSection(
                    'Номер стола', (space as Workspace).deskNumber.toString()),
                _buildInfoSection(
                  'Сетевое подключение',
                  (space as Workspace).hasNetwork ? 'Есть' : 'Нет',
                ),
              ],
              if (space is MeetingRoom) ...[
                _buildInfoSection(
                  'Вместимость',
                  '${(space as MeetingRoom).capacity} человек',
                ),
                _buildInfoSection(
                  'Оборудование',
                  _buildEquipmentList(space as MeetingRoom),
                ),
              ],
              if (space.equipment.isNotEmpty)
                _buildInfoSection(
                  'Дополнительное оборудование',
                  space.equipment.entries
                      .map((e) => '${e.key}: ${e.value}')
                      .join('\n'),
                ),
              const SizedBox(height: 16),
              if (onBook != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onBook,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Забронировать'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Chip(
      label: Text(
        space.isAvailable ? 'Свободно' : 'Занято',
        style: TextStyle(
          color: space.isAvailable ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: space.isAvailable
          ? Colors.green.withOpacity(0.1)
          : Colors.red.withOpacity(0.1),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }

  String _buildEquipmentList(MeetingRoom room) {
    final equipment = <String>[];
    if (room.hasProjector) equipment.add('Проектор');
    if (room.hasVideoConference) equipment.add('Система видеоконференций');
    if (room.hasWhiteboard) equipment.add('Маркерная доска');
    return equipment.isEmpty ? 'Нет' : equipment.join('\n');
  }
}
