import 'package:neoflex_booking/domain/models/bookable_space.dart';
import 'package:neoflex_booking/domain/models/meeting_room.dart';
import 'package:neoflex_booking/domain/models/workspace.dart';
import 'package:neoflex_booking/domain/models/workspace_type.dart';

class TestSpaces {
  static List<BookableSpace> getDemoSpaces() {
    final List<BookableSpace> spaces = [];

    // Создаем сетку рабочих мест 4x4
    final workspaceTypes = [
      WorkspaceType.noComputer,
      WorkspaceType.withMonitor,
      WorkspaceType.withOneMonitor,
      WorkspaceType.withDualMonitor,
    ];

    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        final int index = row * 4 + col + 1;
        final type = workspaceTypes[(row * 4 + col) % workspaceTypes.length];

        spaces.add(
          Workspace(
            id: 'ws_$index',
            name: 'Рабочее место $index',
            description: _getWorkspaceDescription(type),
            isAvailable: index % 3 != 0, // Каждое третье место занято
            equipment: _getWorkspaceEquipment(type),
            location: 'Этаж 2',
            x: 100.0 + col * 150,
            y: 80.0 + row * 120,
            width: 70,
            height: 70,
            type: type,
            hasNetwork: true,
            deskNumber: index,
          ),
        );
      }
    }

    // Добавляем переговорные комнаты разных размеров
    spaces.addAll([
      // Большая переговорная с полным оснащением
      MeetingRoom(
        id: 'mr_1',
        name: 'Переговорная Большая',
        description: 'Большая переговорная комната для совещаний',
        isAvailable: true,
        equipment: {
          'Проектор': 'Epson EB-L630SU',
          'Экран': '120"',
          'Система ВКС': 'Polycom',
          'ТВ': '75" Samsung',
          'Маркерная доска': '180x120 см',
        },
        location: 'Этаж 2',
        x: 800,
        y: 80,
        width: 70,
        height: 70,
        capacity: 16,
        hasProjector: true,
        hasVideoConference: true,
        hasWhiteboard: true,
      ),

      // Средняя переговорная только с ВКС
      MeetingRoom(
        id: 'mr_2',
        name: 'Переговорная Средняя',
        description: 'Средняя переговорная комната для видеоконференций',
        isAvailable: false,
        equipment: {
          'ТВ': '65" LG',
          'Система ВКС': 'Logitech Rally',
        },
        location: 'Этаж 2',
        x: 800,
        y: 180,
        width: 70,
        height: 70,
        capacity: 8,
        hasProjector: false,
        hasVideoConference: true,
        hasWhiteboard: false,
      ),

      // Малая переговорная только с маркерной доской
      MeetingRoom(
        id: 'mr_3',
        name: 'Переговорная Малая 1',
        description: 'Малая переговорная комната для обсуждений',
        isAvailable: true,
        equipment: {
          'Маркерная доска': '120x90 см',
        },
        location: 'Этаж 2',
        x: 100,
        y: 450,
        width: 70,
        height: 70,
        capacity: 4,
        hasProjector: false,
        hasVideoConference: false,
        hasWhiteboard: true,
      ),

      // Малая переговорная с проектором
      MeetingRoom(
        id: 'mr_4',
        name: 'Переговорная Малая 2',
        description: 'Малая переговорная комната для презентаций',
        isAvailable: true,
        equipment: {
          'Проектор': 'Epson EB-W49',
          'Экран': '100"',
        },
        location: 'Этаж 2',
        x: 200,
        y: 450,
        width: 70,
        height: 70,
        capacity: 4,
        hasProjector: true,
        hasVideoConference: false,
        hasWhiteboard: false,
      ),
    ]);

    return spaces;
  }

  static String _getWorkspaceDescription(WorkspaceType type) {
    switch (type) {
      case WorkspaceType.noComputer:
        return 'Рабочее место только со столом и розеткой, подходит для работы со своим ноутбуком';
      case WorkspaceType.withMonitor:
        return 'Рабочее место с внешним монитором 24" и док-станцией для ноутбука';
      case WorkspaceType.withOneMonitor:
        return 'Рабочее место с компьютером и 24" монитором';
      case WorkspaceType.withDualMonitor:
        return 'Рабочее место с компьютером и двумя мониторами 27"';
    }
  }

  static Map<String, dynamic> _getWorkspaceEquipment(WorkspaceType type) {
    switch (type) {
      case WorkspaceType.noComputer:
        return {
          'Розетка': '220В, 2 разъема',
          'Сетевой кабель': 'Cat 6',
          'Стол': 'Рабочий стол 120x60 см',
        };
      case WorkspaceType.withMonitor:
        return {
          'Монитор': '24" Dell P2419H',
          'Док-станция': 'Dell D6000',
          'Розетка': '220В, 2 разъема',
          'Сетевой кабель': 'Cat 6',
        };
      case WorkspaceType.withOneMonitor:
        return {
          'Компьютер': 'Dell OptiPlex 5090',
          'Монитор': '24" Dell P2419H',
          'Клавиатура': 'Dell KB216',
          'Мышь': 'Dell MS116',
        };
      case WorkspaceType.withDualMonitor:
        return {
          'Компьютер': 'Dell OptiPlex 7090',
          'Монитор 1': '27" Dell U2719D',
          'Монитор 2': '27" Dell U2719D',
          'Клавиатура': 'Dell KB216',
          'Мышь': 'Dell MS116',
        };
    }
  }
}
